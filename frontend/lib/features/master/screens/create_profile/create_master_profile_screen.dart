import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/api/service_model.dart';
import '../../../../core/providers/api/auth_provider.dart';
import '../../../../core/providers/api/user_provider.dart';
import '../../../../core/repositories/master_repository.dart';
import '../../../../core/repositories/service_repository.dart';
import 'steps/step1_basic_info.dart';
import 'steps/step2_categories.dart';
import 'steps/step4_schedule.dart';
import 'steps/step5_location.dart';

/// Визард «Стать мастером».
///
/// 4 UI-шага (bio → категории+услуги → расписание → локация), которые при
/// завершении реально отправляются на backend: init профиля → PATCH шагов 1..5 →
/// создание услуг. После успеха пользователь становится мастером
/// (user.is_master=true) и кнопка «Стать мастером» на профиле исчезает.
class CreateMasterProfileScreen extends ConsumerStatefulWidget {
  const CreateMasterProfileScreen({super.key});

  @override
  ConsumerState<CreateMasterProfileScreen> createState() =>
      _CreateMasterProfileScreenState();
}

class _CreateMasterProfileScreenState
    extends ConsumerState<CreateMasterProfileScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _submitting = false;

  /// Данные, накопленные шагами.
  final Map<String, dynamic> _profileData = {};

  /// Русские дни → английские ключи для working_hours JSON.
  static const Map<String, String> _dayKeys = {
    'Понедельник': 'monday',
    'Вторник': 'tuesday',
    'Среда': 'wednesday',
    'Четверг': 'thursday',
    'Пятница': 'friday',
    'Суббота': 'saturday',
    'Воскресенье': 'sunday',
  };

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep(Map<String, dynamic> stepData) {
    _profileData.addAll(stepData);

    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeProfileCreation();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Формирует working_hours JSON вида {monday: {start, end, enabled}, ...}.
  Map<String, dynamic> _buildWorkingHours() {
    final days = (_profileData['workingDays'] as Map?)?.cast<String, bool>() ??
        const {};
    final start = _profileData['startTime']?.toString() ?? '09:00';
    final end = _profileData['endTime']?.toString() ?? '18:00';
    final result = <String, dynamic>{};
    days.forEach((ruDay, enabled) {
      final key = _dayKeys[ruDay];
      if (key != null) {
        result[key] = {'start': start, 'end': end, 'enabled': enabled};
      }
    });
    return result;
  }

  /// Реальная отправка визарда на backend.
  Future<void> _completeProfileCreation() async {
    if (_submitting) return;
    setState(() => _submitting = true);

    final masterRepo = ref.read(masterRepositoryProvider);
    final serviceRepo = ref.read(serviceRepositoryProvider);

    try {
      // 0. Инициализация профиля (может уже существовать — тогда просто продолжаем).
      try {
        await masterRepo.initMasterProfile();
      } catch (_) {
        // «Профиль уже создан» и т.п. — не блокируем, идём к шагам.
      }

      // 1. Категории (L0 ∪ L1) + подкатегории.
      final categoryIds = List<String>.from(_profileData['category_ids'] ?? []);
      final subcategoryIds =
          List<String>.from(_profileData['subcategory_ids'] ?? []);
      await masterRepo.updateMasterStep(1, {
        'category_ids': categoryIds,
        if (subcategoryIds.isNotEmpty) 'subcategory_ids': subcategoryIds,
      });

      // 2. Био.
      await masterRepo.updateMasterStep(2, {
        'bio': _profileData['bio']?.toString() ?? '',
      });

      // 3. Портфолио — пропускаем (пустой шаг для последовательности setup_step).
      await masterRepo.updateMasterStep(3, {});

      // 4. Локация.
      final address = _profileData['address']?.toString();
      final radius = _profileData['radius'];
      await masterRepo.updateMasterStep(4, {
        if (address != null && address.isNotEmpty) 'location_address': address,
        if (radius != null) 'service_radius_km': (radius as num).round(),
        'is_mobile': radius != null && (radius as num) > 0,
        'has_location': address != null && address.isNotEmpty,
      });

      // 5. Расписание — ФИНАЛИЗАЦИЯ (is_master=true).
      await masterRepo.updateMasterStep(5, {
        'working_hours': _buildWorkingHours(),
      });

      // 6. Услуги (после финализации: master_profile_completed=true).
      final services =
          List<Map<String, dynamic>>.from(_profileData['services'] ?? []);
      final failedServices = <String>[];
      for (final s in services) {
        try {
          final price = double.tryParse(s['price'].toString()) ?? 0;
          final duration = int.tryParse(s['duration'].toString()) ?? 60;
          final templateId = s['service_template_id']?.toString();
          await serviceRepo.createService(CreateServiceRequest(
            categoryId: s['category_id'].toString(),
            serviceTemplateId:
                (templateId != null && templateId.isNotEmpty) ? templateId : null,
            name: s['name']?.toString(),
            description: (s['description']?.toString().isNotEmpty ?? false)
                ? s['description'].toString()
                : null,
            price: price,
            durationMinutes: duration,
          ));
        } catch (_) {
          failedServices.add(s['name']?.toString() ?? 'услуга');
        }
      }

      // 7. Обновляем статус пользователя → кнопка «Стать мастером» исчезнет.
      ref.invalidate(authNotifierProvider);
      ref.invalidate(currentUserProfileProvider);

      if (!mounted) return;
      _showSuccessDialog(failedServices);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Не удалось создать профиль мастера: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _showSuccessDialog(List<String> failedServices) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.check_circle,
          size: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('Профиль мастера создан!'),
        content: Text(
          failedServices.isEmpty
              ? 'Теперь вы можете принимать записи и общаться с клиентами.'
              : 'Профиль создан. Не удалось добавить услуги: '
                  '${failedServices.join(', ')}. Добавьте их позже в профиле.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/');
            },
            child: const Text('Начать работу'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentStep == 0 && !_submitting,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentStep > 0 && !_submitting) {
          _previousStep();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _submitting
                ? null
                : () {
                    if (_currentStep > 0) {
                      _previousStep();
                    } else {
                      context.pop();
                    }
                  },
          ),
          title: const Text(
            'Стать мастером',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / 4,
              backgroundColor: Colors.grey[200],
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Шаг ${_currentStep + 1} из 4',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Step1BasicInfo(
                        initialData: _profileData,
                        onNext: _nextStep,
                      ),
                      Step2Categories(
                        initialData: _profileData,
                        onNext: _nextStep,
                        onBack: _previousStep,
                      ),
                      Step4Schedule(
                        initialData: _profileData,
                        onNext: _nextStep,
                        onBack: _previousStep,
                      ),
                      Step5Location(
                        initialData: _profileData,
                        onNext: _nextStep,
                        onBack: _previousStep,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_submitting)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
