import 'package:flutter/material.dart';

class Step1BasicInfo extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onNext;

  const Step1BasicInfo({
    super.key,
    required this.initialData,
    required this.onNext,
  });

  @override
  State<Step1BasicInfo> createState() => _Step1BasicInfoState();
}

class _Step1BasicInfoState extends State<Step1BasicInfo> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialData['masterName'] ?? '';
    _bioController.text = widget.initialData['bio'] ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      widget.onNext({
        'masterName': _nameController.text,
        'bio': _bioController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Основная информация',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Расскажите о себе, чтобы клиенты могли вас найти',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Имя мастера *',
                hintText: 'Как вас будут видеть клиенты',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите имя';
                }
                if (value.length < 2) {
                  return 'Имя должно быть не менее 2 символов';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: 'О себе *',
                hintText: 'Опыт, специализация, достижения...',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.edit),
                helperText: '${_bioController.text.length}/500 символов',
              ),
              maxLines: 5,
              maxLength: 500,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Расскажите о себе';
                }
                if (value.length < 50) {
                  return 'Минимум 50 символов (сейчас ${value.length})';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {}); // Update character counter
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Хорошее описание увеличивает шанс найти клиентов на 60%',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _continue,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Продолжить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
