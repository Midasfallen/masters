import 'package:flutter/material.dart';

class Step4Schedule extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onBack;

  const Step4Schedule({
    super.key,
    required this.initialData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step4Schedule> createState() => _Step4ScheduleState();
}

class _Step4ScheduleState extends State<Step4Schedule> {
  final Map<String, bool> _workingDays = {
    'Понедельник': true,
    'Вторник': true,
    'Среда': true,
    'Четверг': true,
    'Пятница': true,
    'Суббота': false,
    'Воскресенье': false,
  };

  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 18, minute: 0);

  @override
  void initState() {
    super.initState();
    if (widget.initialData['workingDays'] != null) {
      _workingDays.addAll(Map<String, bool>.from(widget.initialData['workingDays']));
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _continue() {
    final selectedDays = _workingDays.entries.where((e) => e.value).map((e) => e.key).toList();

    if (selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите хотя бы один рабочий день')),
      );
      return;
    }

    widget.onNext({
      'workingDays': _workingDays,
      'startTime': '${_startTime.hour}:${_startTime.minute.toString().padLeft(2, '0')}',
      'endTime': '${_endTime.hour}:${_endTime.minute.toString().padLeft(2, '0')}',
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Расписание работы',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Укажите дни и часы работы',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),
          Text('Рабочие дни', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ..._workingDays.entries.map((entry) {
            return CheckboxListTile(
              title: Text(entry.key),
              value: entry.value,
              onChanged: (value) {
                setState(() {
                  _workingDays[entry.key] = value ?? false;
                });
              },
            );
          }),
          const SizedBox(height: 24),
          Text('Часы работы', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selectTime(context, true),
                  icon: const Icon(Icons.access_time),
                  label: Text('С ${_startTime.format(context)}'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selectTime(context, false),
                  icon: const Icon(Icons.access_time),
                  label: Text('До ${_endTime.format(context)}'),
                ),
              ),
            ],
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
