import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/providers/api/auth_provider.dart';
import '../../../core/providers/api/user_provider.dart';
import '../../../core/models/api/user_model.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;

  String? _language;
  String? _timezone;
  bool _isLoading = false;
  UserModel? _currentUser;

  static const List<String> _languages = ['en', 'ru', 'de', 'fr', 'es', 'it'];
  static const List<String> _timezones = [
    'UTC', 'Europe/Moscow', 'Europe/London', 'America/New_York',
    'America/Los_Angeles', 'Asia/Tokyo', 'Asia/Shanghai',
  ];

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final authState = ref.read(authNotifierProvider);
      final user = authState.valueOrNull?.user;
      if (user != null) {
        // Fetch full profile
        final fullUser = await ref.read(currentUserProfileProvider.future);
        setState(() {
          _currentUser = fullUser;
          _firstNameController.text = fullUser.firstName;
          _lastNameController.text = fullUser.lastName;
          _phoneController.text = fullUser.phone ?? '';
          _language = fullUser.language;
          _timezone = fullUser.timezone;
        });
      }
    } catch (_) {
      // Use auth state data as fallback
      final authState = ref.read(authNotifierProvider);
      final user = authState.valueOrNull?.user;
      if (user != null) {
        setState(() {
          _firstNameController.text = user.firstName;
          _lastNameController.text = user.lastName;
        });
      }
    }
  }

  Future<void> _handleAvatarChange() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    try {
      setState(() => _isLoading = true);
      await ref.read(userNotifierProvider.notifier).uploadAvatar(image.path);

      ref.invalidate(currentUserProfileProvider);
      ref.invalidate(authNotifierProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Аватар успешно обновлен'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки аватара: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final request = UpdateUserRequest(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        language: _language,
        timezone: _timezone,
      );

      await ref.read(userNotifierProvider.notifier).updateProfile(request);

      ref.invalidate(currentUserProfileProvider);
      ref.invalidate(authNotifierProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Профиль успешно обновлен'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка сохранения: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать профиль'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: const Text('Сохранить'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Avatar
            Center(
              child: GestureDetector(
                onTap: _isLoading ? null : _handleAvatarChange,
                child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundImage: _currentUser?.avatarUrl != null
                          ? NetworkImage(_currentUser!.avatarUrl!)
                          : null,
                      child: _currentUser?.avatarUrl == null
                          ? Text(
                              (_currentUser?.firstName.isNotEmpty ?? false)
                                  ? _currentUser!.firstName[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(fontSize: 36),
                            )
                          : null,
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // First Name
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'Имя',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите имя';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Last Name
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Фамилия',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите фамилию';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Phone
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Телефон (опционально)',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            // Language
            DropdownButtonFormField<String>(
              initialValue: _language,
              decoration: const InputDecoration(
                labelText: 'Язык',
                prefixIcon: Icon(Icons.language),
              ),
              items: _languages
                  .map((lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(lang.toUpperCase()),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _language = value),
            ),
            const SizedBox(height: 16),

            // Timezone
            DropdownButtonFormField<String>(
              initialValue: _timezone,
              decoration: const InputDecoration(
                labelText: 'Часовой пояс',
                prefixIcon: Icon(Icons.access_time_outlined),
              ),
              items: _timezones
                  .map((tz) => DropdownMenuItem(
                        value: tz,
                        child: Text(tz),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _timezone = value),
            ),
            const SizedBox(height: 32),

            // Save button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveProfile,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Сохранить изменения'),
            ),
          ],
        ),
      ),
    );
  }
}
