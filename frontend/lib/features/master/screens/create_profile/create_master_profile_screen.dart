import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'steps/step1_basic_info.dart';
import 'steps/step2_categories.dart';
import 'steps/step3_services.dart';
import 'steps/step4_schedule.dart';
import 'steps/step5_location.dart';

class CreateMasterProfileScreen extends StatefulWidget {
  const CreateMasterProfileScreen({super.key});

  @override
  State<CreateMasterProfileScreen> createState() => _CreateMasterProfileScreenState();
}

class _CreateMasterProfileScreenState extends State<CreateMasterProfileScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Data from steps
  final Map<String, dynamic> _profileData = {};

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep(Map<String, dynamic> stepData) {
    _profileData.addAll(stepData);

    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
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
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeProfileCreation() {
    // В реальном приложении здесь будет отправка данных на сервер
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
        content: const Text(
          'Теперь вы можете создавать посты, принимать записи и общаться с клиентами.',
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
    return WillPopScope(
      onWillPop: () async {
        if (_currentStep > 0) {
          _previousStep();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
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
              value: (_currentStep + 1) / 5,
              backgroundColor: Colors.grey[200],
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Шаг ${_currentStep + 1} из 5',
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
                  Step3Services(
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
      ),
    );
  }
}
