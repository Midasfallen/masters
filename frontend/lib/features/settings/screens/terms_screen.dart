import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Условия использования'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Последнее обновление: 28 января 2026 года',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection('1. Принятие условий', '''
Используя приложение Service Platform, вы принимаете настоящие условия использования и обязуетесь их соблюдать. Если вы не согласны с какой-либо частью этих условий, вы не можете использовать наше приложение.'''),
            _buildSection('2. Использование услуг', '''
Наше приложение предоставляет платформу для соединения пользователей с мастерами разных специальностей. Вы обязуетесь использовать сервис исключительно в законных целях и в соответствии с действующим законодательством.'''),
            _buildSection('3. Аккаунт и авторизация', '''
Вы несёте ответственность за безопасность вашего аккаунта и пароля. Нельзя передавать доступ к аккаунту третьим лицам. Мы оставляем за собой право приостановить аккаунт при нарушении условий.'''),
            _buildSection('4. Бронирование и оплата', '''
Бронирования оформляются через приложение. Оплата производится в соответствии с указанными ценами мастеров. Отмена бронирования возможна не менее чем за 24 часа до начала услуги.'''),
            _buildSection('5. Оценки и отзывы', '''
Пользователи могут оставлять оценки и отзывы о проведённых сессиях. Отзывы должны быть честными и содержательными. Запрещается оставлять ложные или оскорбительные отзывы.'''),
            _buildSection('6. Ответственность', '''
Мы не несём ответственности за качество услуг мастеров. Наша платформа является посредником. Мы оставляем право на изменение условий в любой момент.'''),
            _buildSection('7. Прекращение доступа', '''
Мы оставляем право на ограничение или прекращение доступа к приложению в случае нарушения условий использования.'''),
            const SizedBox(height: 24),
            Text(
              'Связаться с нами: support@service-platform.ru',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content.trim(),
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
