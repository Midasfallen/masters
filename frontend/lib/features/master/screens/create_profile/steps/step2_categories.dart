import 'package:flutter/material.dart';

class Step2Categories extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onBack;

  const Step2Categories({
    super.key,
    required this.initialData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step2Categories> createState() => _Step2CategoriesState();
}

class _Step2CategoriesState extends State<Step2Categories> {
  final List<String> _allCategories = [
    'Красота',
    'Маникюр',
    'Педикюр',
    'Стрижка',
    'Окрашивание',
    'Макияж',
    'Массаж',
    'Косметология',
    'Наращивание ресниц',
    'Брови',
    'Депиляция',
    'Татуаж',
    'Перманентный макияж',
  ];

  Set<String> _selectedCategories = {};

  @override
  void initState() {
    super.initState();
    _selectedCategories = Set<String>.from(widget.initialData['categories'] ?? []);
  }

  void _continue() {
    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите хотя бы одну категорию')),
      );
      return;
    }

    if (_selectedCategories.length > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Максимум 5 категорий')),
      );
      return;
    }

    widget.onNext({'categories': _selectedCategories.toList()});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Выберите категории',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'От 1 до 5 категорий услуг, которые вы предоставляете',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allCategories.map((category) {
              final isSelected = _selectedCategories.contains(category);
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      if (_selectedCategories.length < 5) {
                        _selectedCategories.add(category);
                      }
                    } else {
                      _selectedCategories.remove(category);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text(
            'Выбрано: ${_selectedCategories.length}/5',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Назад'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
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
        ],
      ),
    );
  }
}
