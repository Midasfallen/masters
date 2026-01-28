import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_platform/core/providers/api/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _emailNotifications = prefs.getBool('email_notifications') ?? true;
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _darkMode = prefs.getBool('dark_mode') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('email_notifications', _emailNotifications);
    await prefs.setBool('push_notifications', _pushNotifications);
    await prefs.setBool('dark_mode', _darkMode);
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(authNotifierProvider.notifier).logout();
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final currentUser = authState.valueOrNull?.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: ListView(
        children: [
          // User info section
          if (currentUser != null)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: currentUser.avatarUrl != null
                        ? NetworkImage(currentUser.avatarUrl!)
                        : null,
                    child: currentUser.avatarUrl == null
                        ? Text(
                            (currentUser.fullName?.isNotEmpty ?? false)
                                ? currentUser.fullName![0].toUpperCase()
                                : 'U',
                            style: const TextStyle(fontSize: 32),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser.fullName ?? '${currentUser.firstName} ${currentUser.lastName}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentUser.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      context.push('/edit-profile');
                    },
                  ),
                ],
              ),
            ),
          const Divider(),

          // Account section
          _buildSectionHeader('Аккаунт'),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Редактировать профиль'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push('/edit-profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Изменить пароль'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push('/forgot-password');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shield_outlined),
            title: const Text('Приватность и безопасность'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push('/privacy-settings');
            },
          ),

          const Divider(),

          // Notifications section
          _buildSectionHeader('Уведомления'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Уведомления'),
            subtitle: const Text('Получать уведомления от приложения'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
                if (!value) {
                  _emailNotifications = false;
                  _pushNotifications = false;
                }
              });
              _saveSettings();
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.email_outlined),
            title: const Text('Email уведомления'),
            subtitle: const Text('Получать уведомления на почту'),
            value: _emailNotifications && _notificationsEnabled,
            onChanged: _notificationsEnabled
                ? (value) {
                    setState(() => _emailNotifications = value);
                    _saveSettings();
                  }
                : null,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.phone_android),
            title: const Text('Push уведомления'),
            subtitle: const Text('Получать push-уведомления на устройство'),
            value: _pushNotifications && _notificationsEnabled,
            onChanged: _notificationsEnabled
                ? (value) {
                    setState(() => _pushNotifications = value);
                    _saveSettings();
                  }
                : null,
          ),

          const Divider(),

          // Appearance section
          _buildSectionHeader('Внешний вид'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Темная тема'),
            subtitle: const Text('Использовать темную тему оформления'),
            value: _darkMode,
            onChanged: (value) {
              setState(() => _darkMode = value);
              _saveSettings();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Перезапустите приложение для применения темы'),
                ),
              );
            },
          ),

          const Divider(),

          // Support section
          _buildSectionHeader('Поддержка'),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Помощь и FAQ'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push('/help');
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: const Text('Обратная связь'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push('/feedback');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('О приложении'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAboutDialog(),
          ),

          const Divider(),

          // Legal section
          _buildSectionHeader('Юридическая информация'),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Условия использования'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push('/terms');
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Политика конфиденциальности'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push('/privacy-policy');
            },
          ),

          const Divider(),

          // Logout section
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: _handleLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Выйти из аккаунта'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Version info
          Center(
            child: Text(
              'Версия 2.0.0',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Service Platform',
      applicationVersion: '2.0.0',
      applicationIcon: const FlutterLogo(size: 48),
      children: [
        const Text(
          'Социальная платформа для поиска и бронирования услуг мастеров.',
        ),
        const SizedBox(height: 16),
        const Text(
          '© 2026 Service Platform. Все права защищены.',
        ),
      ],
    );
  }
}
