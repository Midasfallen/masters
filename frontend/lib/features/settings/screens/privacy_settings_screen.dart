import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  // Profile visibility: 'all' or 'friends'
  String _profileVisibility = 'all';
  // Who can message: 'all' or 'friends'
  String _messageVisibility = 'all';
  // Search visibility
  bool _showInSearch = true;
  // Online status
  bool _showOnlineStatus = true;
  // Rating & reviews
  bool _showRatingReviews = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileVisibility = prefs.getString('privacy_profile_visibility') ?? 'all';
      _messageVisibility = prefs.getString('privacy_message_visibility') ?? 'all';
      _showInSearch = prefs.getBool('privacy_show_in_search') ?? true;
      _showOnlineStatus = prefs.getBool('privacy_show_online_status') ?? true;
      _showRatingReviews = prefs.getBool('privacy_show_rating_reviews') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('privacy_profile_visibility', _profileVisibility);
    await prefs.setString('privacy_message_visibility', _messageVisibility);
    await prefs.setBool('privacy_show_in_search', _showInSearch);
    await prefs.setBool('privacy_show_online_status', _showOnlineStatus);
    await prefs.setBool('privacy_show_rating_reviews', _showRatingReviews);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Приватность и безопасность'),
      ),
      body: ListView(
        children: [
          // Profile visibility section
          _buildSectionHeader('Видимость профиля'),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Профиль виден'),
            subtitle: Text(_profileVisibility == 'all' ? 'Все пользователи' : 'Только друзья'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => _buildVisibilityPicker(
                  title: 'Кто видит профиль',
                  current: _profileVisibility,
                  onChanged: (value) {
                    setState(() => _profileVisibility = value);
                    _saveSettings();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.message_outlined),
            title: const Text('Сообщения от'),
            subtitle: Text(_messageVisibility == 'all' ? 'Все пользователи' : 'Только друзья'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => _buildVisibilityPicker(
                  title: 'Кто может писать',
                  current: _messageVisibility,
                  onChanged: (value) {
                    setState(() => _messageVisibility = value);
                    _saveSettings();
                  },
                ),
              );
            },
          ),

          const Divider(),

          // Search & discovery section
          _buildSectionHeader('Поиск и обнаружение'),
          SwitchListTile(
            secondary: const Icon(Icons.search_outlined),
            title: const Text('Показывать в поисковых результатах'),
            subtitle: const Text('Другие смогут найти ваш профиль'),
            value: _showInSearch,
            onChanged: (value) {
              setState(() => _showInSearch = value);
              _saveSettings();
            },
          ),

          const Divider(),

          // Activity section
          _buildSectionHeader('Активность'),
          SwitchListTile(
            secondary: const Icon(Icons.lens_blur_outlined),
            title: const Text('Показывать статус "в сети"'),
            subtitle: const Text('Другие видят когда вы активны'),
            value: _showOnlineStatus,
            onChanged: (value) {
              setState(() => _showOnlineStatus = value);
              _saveSettings();
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.star_outline),
            title: const Text('Показывать рейтинг и отзывы'),
            subtitle: const Text('Информация будет видна на вашем профиле'),
            value: _showRatingReviews,
            onChanged: (value) {
              setState(() => _showRatingReviews = value);
              _saveSettings();
            },
          ),

          const Divider(),

          // Data section
          _buildSectionHeader('Данные'),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Скачать мои данные'),
            subtitle: const Text('Получить копию всех ваших данных'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Функция в разработке')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Удалить аккаунт', style: TextStyle(color: Colors.red)),
            subtitle: const Text('Навсегда удалит все ваши данные'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showDeleteAccountDialog();
            },
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

  Widget _buildVisibilityPicker({
    required String title,
    required String current,
    required ValueChanged<String> onChanged,
  }) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.public_outlined),
              title: const Text('Все пользователи'),
              trailing: current == 'all'
                  ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                  : null,
              onTap: () {
                onChanged('all');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_outlined),
              title: const Text('Только друзья'),
              trailing: current == 'friends'
                  ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                  : null,
              onTap: () {
                onChanged('friends');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить аккаунт?'),
        content: const Text(
          'Это действие необратимо. Все ваши данные, посты и сообщения будут удалены навсегда.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}
