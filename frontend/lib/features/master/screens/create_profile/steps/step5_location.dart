import 'package:flutter/material.dart';

class Step5Location extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onBack;

  const Step5Location({
    super.key,
    required this.initialData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step5Location> createState() => _Step5LocationState();
}

class _Step5LocationState extends State<Step5Location> {
  final _addressController = TextEditingController();
  double _radius = 5.0;
  int _travelFee = 0;
  final Set<String> _paymentMethods = {};

  final List<String> _availablePaymentMethods = [
    'Наличные',
    'Карта',
    'СБП',
    'Перевод на карту',
  ];

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.initialData['address'] ?? '';
    _radius = widget.initialData['radius'] ?? 5.0;
    _travelFee = widget.initialData['travelFee'] ?? 0;
    _paymentMethods.addAll(
      List<String>.from(widget.initialData['paymentMethods'] ?? ['Наличные']),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _complete() {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Укажите адрес')),
      );
      return;
    }

    if (_paymentMethods.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите хотя бы один способ оплаты')),
      );
      return;
    }

    widget.onNext({
      'address': _addressController.text,
      'radius': _radius,
      'travelFee': _travelFee,
      'paymentMethods': _paymentMethods.toList(),
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
            'Локация и оплата',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Укажите адрес и условия работы',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Базовый адрес',
              hintText: 'Город, улица, дом',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          Text('Радиус выезда', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _radius,
                  min: 0,
                  max: 50,
                  divisions: 10,
                  label: '${_radius.toInt()} км',
                  onChanged: (value) {
                    setState(() {
                      _radius = value;
                    });
                  },
                ),
              ),
              Text('${_radius.toInt()} км'),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Доплата за выезд (₽)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.local_taxi),
            ),
            keyboardType: TextInputType.number,
            controller: TextEditingController(text: _travelFee.toString()),
            onChanged: (value) {
              _travelFee = int.tryParse(value) ?? 0;
            },
          ),
          const SizedBox(height: 24),
          Text('Способы оплаты', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availablePaymentMethods.map((method) {
              return FilterChip(
                label: Text(method),
                selected: _paymentMethods.contains(method),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _paymentMethods.add(method);
                    } else {
                      _paymentMethods.remove(method);
                    }
                  });
                },
              );
            }).toList(),
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
                  onPressed: _complete,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Завершить'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
