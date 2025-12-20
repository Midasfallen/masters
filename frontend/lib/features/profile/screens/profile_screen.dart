import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeNotifier = ThemeNotifier.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/200?img=68',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Иван Петров',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ivan.petrov@example.com',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSection(
            context,
            title: 'Настройки',
            items: [
              _MenuItem(
                icon: Icons.person_outline,
                title: 'Редактировать профиль',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Редактирование профиля')),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.notifications_outlined,
                title: 'Уведомления',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Настройки уведомлений')),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.language_outlined,
                title: 'Язык',
                subtitle: 'Русский',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Выбор языка')),
                  );
                },
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            title: 'Тема',
            items: [
              _MenuItem(
                icon: Icons.light_mode_outlined,
                title: 'Светлая',
                trailing: themeNotifier?.currentTheme == 'light'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () => themeNotifier?.changeTheme('light'),
              ),
              _MenuItem(
                icon: Icons.dark_mode_outlined,
                title: 'Тёмная',
                trailing: themeNotifier?.currentTheme == 'dark'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () => themeNotifier?.changeTheme('dark'),
              ),
              _MenuItem(
                icon: Icons.palette_outlined,
                title: 'Кастомная',
                trailing: themeNotifier?.currentTheme == 'custom'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () => themeNotifier?.changeTheme('custom'),
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            title: 'Поддержка',
            items: [
              _MenuItem(
                icon: Icons.help_outline,
                title: 'Помощь и FAQ',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Помощь и FAQ')),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Политика конфиденциальности',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Политика конфиденциальности')),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.description_outlined,
                title: 'Условия использования',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Условия использования')),
                  );
                },
              ),
            ],
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Выйти из аккаунта?'),
                    content: const Text(
                      'Вы уверены, что хотите выйти?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Отмена'),
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.go('/login');
                        },
                        child: const Text('Выйти'),
                      ),
                    ],
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                minimumSize: const Size(double.infinity, 48),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Выйти из аккаунта'),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Версия 1.0.0',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<_MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        ...items.map((item) => ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
              trailing: item.trailing ?? const Icon(Icons.chevron_right),
              onTap: item.onTap,
            )),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });
}
