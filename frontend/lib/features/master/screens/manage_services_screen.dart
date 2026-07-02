import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/api/category_tree_model.dart';
import '../../../core/models/api/service_model.dart';
import '../../../core/providers/api/auth_provider.dart';
import '../../../core/providers/api/categories_tree_provider.dart';
import '../../../core/providers/api/masters_provider.dart';
import '../../../core/repositories/service_repository.dart';

/// Экран управления услугами мастера: список + добавить/редактировать/удалить.
/// Открывается из «Настройки → Редактировать услуги» (только для мастера).
class ManageServicesScreen extends ConsumerWidget {
  const ManageServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final userId = authState.valueOrNull?.user?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать услуги'),
      ),
      floatingActionButton: userId == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _openServiceSheet(context, ref, userId),
              icon: const Icon(Icons.add),
              label: const Text('Добавить услугу'),
            ),
      body: userId == null
          ? const Center(child: Text('Не удалось определить пользователя'))
          : _buildList(context, ref, userId),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref, String userId) {
    final servicesAsync = ref.watch(masterServicesProvider(userId));

    return servicesAsync.when(
      data: (services) {
        if (services.isEmpty) {
          return _emptyState();
        }
        return RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(masterServicesProvider(userId)),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
            itemCount: services.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) =>
                _serviceCard(context, ref, userId, services[index]),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Не удалось загрузить услуги: $error'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(masterServicesProvider(userId)),
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.work_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text('Нет услуг',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              const SizedBox(height: 8),
              Text(
                'Нажмите «Добавить услугу», чтобы создать первую',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );

  Widget _serviceCard(
    BuildContext context,
    WidgetRef ref,
    String userId,
    ServiceModel service,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        title: Text(service.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${service.price.toStringAsFixed(0)} ₽ · ${service.durationMinutes} мин',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Редактировать',
              onPressed: () =>
                  _openServiceSheet(context, ref, userId, service: service),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red[400]),
              tooltip: 'Удалить',
              onPressed: () => _confirmDelete(context, ref, userId, service),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String userId,
    ServiceModel service,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить услугу?'),
        content: Text('«${service.name}» будет удалена без возможности отмены.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red[600]),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(serviceRepositoryProvider).deleteService(service.id);
      ref.invalidate(masterServicesProvider(userId));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Услуга удалена')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Не удалось удалить: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _openServiceSheet(
    BuildContext context,
    WidgetRef ref,
    String userId, {
    ServiceModel? service,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _ServiceFormSheet(userId: userId, service: service),
      ),
    );
  }
}

/// Bottom sheet формы создания/редактирования услуги.
class _ServiceFormSheet extends ConsumerStatefulWidget {
  final String userId;
  final ServiceModel? service; // null → создание

  const _ServiceFormSheet({required this.userId, this.service});

  @override
  ConsumerState<_ServiceFormSheet> createState() => _ServiceFormSheetState();
}

class _ServiceFormSheetState extends ConsumerState<_ServiceFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _price;
  late String _duration;
  late String _description;
  String? _categoryId; // L1 — только для создания
  bool _saving = false;

  bool get _isEdit => widget.service != null;

  @override
  void initState() {
    super.initState();
    final s = widget.service;
    _name = s?.name ?? '';
    _price = s != null ? s.price.toStringAsFixed(0) : '';
    _duration = s?.durationMinutes.toString() ?? '60';
    _description = s?.description ?? '';
    _categoryId = s?.categoryId;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isEdit ? 'Редактировать услугу' : 'Новая услуга',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Категория (только при создании)
              if (!_isEdit) ...[
                _buildCategoryDropdown(),
                const SizedBox(height: 12),
              ],

              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Название',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => _name = v,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Введите название' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _price,
                      decoration: const InputDecoration(
                        labelText: 'Цена (₽)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _price = v,
                      validator: (v) {
                        final n = double.tryParse((v ?? '').trim());
                        if (n == null || n < 0) return 'Цена';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: _duration,
                      decoration: const InputDecoration(
                        labelText: 'Время (мин)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _duration = v,
                      validator: (v) {
                        final n = int.tryParse((v ?? '').trim());
                        if (n == null || n < 5) return 'Мин 5';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(
                  labelText: 'Описание (опционально)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (v) => _description = v,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Сохранить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    final profileAsync = ref.watch(myMasterProfileProvider);
    final treeAsync = ref.watch(categoriesTreeProvider(language: 'ru'));

    return profileAsync.when(
      data: (profile) {
        final subIds = profile?.subcategoryIds ?? const <String>[];
        return treeAsync.when(
          data: (roots) {
            // Собираем L1-подкатегории профиля с названиями.
            final subs = <CategoryTreeModel>[];
            for (final root in roots) {
              for (final child in root.children) {
                if (subIds.contains(child.id)) subs.add(child);
              }
            }
            if (subs.isEmpty) {
              return const Text(
                'В профиле нет подкатегорий. Добавьте их в разделе «Стать мастером».',
                style: TextStyle(color: Colors.red),
              );
            }
            _categoryId ??= subs.first.id;
            return DropdownButtonFormField<String>(
              initialValue: _categoryId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Подкатегория',
                border: OutlineInputBorder(),
              ),
              items: subs
                  .map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.name, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _categoryId = v),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Выберите подкатегорию' : null,
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('Ошибка категорий: $e',
              style: const TextStyle(color: Colors.red)),
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text('Ошибка профиля: $e',
          style: const TextStyle(color: Colors.red)),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final repo = ref.read(serviceRepositoryProvider);
    final price = double.tryParse(_price.trim()) ?? 0;
    final duration = int.tryParse(_duration.trim()) ?? 60;
    final desc = _description.trim().isEmpty ? null : _description.trim();

    try {
      if (_isEdit) {
        await repo.updateService(
          widget.service!.id,
          UpdateServiceRequest(
            name: _name.trim(),
            price: price,
            durationMinutes: duration,
            description: desc,
          ),
        );
      } else {
        await repo.createService(
          CreateServiceRequest(
            categoryId: _categoryId!,
            name: _name.trim(),
            price: price,
            durationMinutes: duration,
            description: desc,
          ),
        );
      }
      ref.invalidate(masterServicesProvider(widget.userId));
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEdit ? 'Услуга обновлена' : 'Услуга добавлена')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Не удалось сохранить: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
