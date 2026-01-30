import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<_FaqItem> _faqItems = [
    _FaqItem(
      question: 'Как зарегистрироваться?',
      answer: 'Нажмите кнопку "Регистрация" на стартовом экране. Введите email, пароль и основные данные о себе.',
    ),
    _FaqItem(
      question: 'Как найти мастера?',
      answer: 'Используйте поиск или Browse по категориям. Можно также настроить геолокацию для поиска мастеров рядом.',
    ),
    _FaqItem(
      question: 'Как забронировать услугу?',
      answer: 'Зайдите в профиль мастера, выберите услугу и доступное время, нажмите "Забронировать".',
    ),
    _FaqItem(
      question: 'Как отменить бронирование?',
      answer: 'Зайдите в "Бронирования" → выберите нужное → нажмите "Отменить". Отмена возможна не менее чем за 24 часа.',
    ),
    _FaqItem(
      question: 'Как оставить отзыв?',
      answer: 'После завершения сессии вы получите уведомление. Нажмите на него или зайдите в раздел бронирований.',
    ),
    _FaqItem(
      question: 'Как стать мастером?',
      answer: 'Зайдите в профиль → нажмите "Стать мастером" → заполните информацию о себе и ваших услугах.',
    ),
    _FaqItem(
      question: 'Что такое Premium?',
      answer: 'Premium — расширенные возможности: приоритетное размещение, больше бронирований, аналитика.',
    ),
    _FaqItem(
      question: 'Как изменить пароль?',
      answer: 'Настройки → Изменить пароль. Или используйте восстановление пароля на странице входа.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Помощь и поддержка'),
      ),
      body: ListView(
        children: [
          // Contact support
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(Icons.support_agent, size: 40),
                const SizedBox(height: 8),
                const Text(
                  'Нужна помощь?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Наша поддержка работает ежедневно с 9:00 до 21:00',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                const Text(
                  'support@service-platform.ru',
                  style: TextStyle(fontSize: 14, color: Colors.blue),
                ),
              ],
            ),
          ),

          // FAQ section
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'ЧАСТО ЗАДАВАЕМЫЕ ВОПРОСЫ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),

          // FAQ items
          ..._faqItems.map((item) => _FaqTile(item: item)),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;

  _FaqItem({required this.question, required this.answer});
}

class _FaqTile extends StatefulWidget {
  final _FaqItem item;

  const _FaqTile({required this.item});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.help_outline),
      title: Text(widget.item.question),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              widget.item.answer,
              style: const TextStyle(height: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
