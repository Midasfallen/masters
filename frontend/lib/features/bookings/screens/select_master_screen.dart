import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/api/chat_model.dart';
import '../../../core/providers/api/bookings_provider.dart';
import '../../../core/providers/main_nav_provider.dart';

/// Экран выбора мастера для новой записи.
/// Показывает мастеров, к которым пользователь уже записывался или с которыми
/// переписывался. Тап по мастеру открывает его профиль.
class SelectMasterScreen extends ConsumerWidget {
  const SelectMasterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mastersAsync = ref.watch(myMastersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Выберите мастера',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: mastersAsync.when(
        data: (masters) {
          if (masters.isEmpty) {
            return _buildEmptyState(context, ref);
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: masters.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) =>
                _buildMasterTile(context, masters[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Ошибка загрузки: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(myMastersProvider),
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMasterTile(BuildContext context, ChatUserModel master) {
    final name = (master.fullName != null && master.fullName!.isNotEmpty)
        ? master.fullName!
        : '${master.firstName} ${master.lastName}';
    final avatarUrl = master.avatarUrl;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.grey[300],
        backgroundImage: hasAvatar
            ? CachedNetworkImageProvider(avatarUrl)
            : null,
        child: hasAvatar
            ? null
            : const Icon(Icons.person, size: 28, color: Colors.white),
      ),
      title: Text(
        name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: master.isVerified
          ? const Text('Проверенный мастер')
          : const Text('Мастер'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => context.push('/master/${master.id}'),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 72, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Пока нет мастеров',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Здесь появятся мастера, к которым вы записывались\nили с которыми переписывались.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                // Уходим на таб «Поиск» и закрываем этот экран.
                ref.read(mainNavIndexProvider.notifier).state =
                    MainNavTab.search;
                if (context.canPop()) context.pop();
              },
              icon: const Icon(Icons.search),
              label: const Text('Найти мастера'),
            ),
          ],
        ),
      ),
    );
  }
}
