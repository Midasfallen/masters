import 'package:flutter/material.dart';

class Step3Services extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onBack;

  const Step3Services({
    super.key,
    required this.initialData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step3Services> createState() => _Step3ServicesState();
}

class _Step3ServicesState extends State<Step3Services> {
  List<Map<String, dynamic>> _services = [];

  @override
  void initState() {
    super.initState();
    _services = List<Map<String, dynamic>>.from(widget.initialData['services'] ?? []);
    if (_services.isEmpty) {
      _services.add(_createEmptyService());
    }
  }

  Map<String, dynamic> _createEmptyService() {
    return {
      'name': '',
      'price': '',
      'duration': '60',
      'description': '',
    };
  }

  void _addService() {
    setState(() {
      _services.add(_createEmptyService());
    });
  }

  void _removeService(int index) {
    setState(() {
      _services.removeAt(index);
    });
  }

  void _continue() {
    final validServices = _services.where((service) {
      return service['name'].toString().isNotEmpty &&
          service['price'].toString().isNotEmpty;
    }).toList();

    if (validServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Добавьте хотя бы одну услугу')),
      );
      return;
    }

    widget.onNext({'services': validServices});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Услуги и цены',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Добавьте услуги, которые вы предоставляете',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _services.length,
            itemBuilder: (context, index) => _buildServiceCard(index),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _addService,
            icon: const Icon(Icons.add),
            label: const Text('Добавить услугу'),
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

  Widget _buildServiceCard(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Услуга ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                if (_services.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeService(index),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Название',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _services[index]['name'] = value;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Цена (₽)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _services[index]['price'] = value;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Время (мин)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: _services[index]['duration']),
                    onChanged: (value) {
                      _services[index]['duration'] = value;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
