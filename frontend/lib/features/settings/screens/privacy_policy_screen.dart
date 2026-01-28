import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Политика конфиденциальности'),
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
            _buildSection('1. Сбор данных', '''
Мы собираем информацию, которую вы предоставляете при регистрации: имя, email, номер телефона. Также мы собираем данные об использовании приложения для улучшения сервиса.'''),
            _buildSection('2. Использование данных', '''
Ваши данные используются для обеспечения работы сервиса, персонализации предложений и коммуникации с вами. Мы не используем ваши данные для рекламных целей без вашего явного согласия.'''),
            _buildSection('3. Хранение данных', '''
Все данные хранятся на серверах в соответствии с требованиями безопасности. Период хранения определяется необходимостью для работы сервиса.'''),
            _buildSection('4. Доступ к данным', '''
Только авторизованные сотрудники нашей команды имеют доступ к вашим данным, и только в случае необходимости для поддержки сервиса.'''),
            _buildSection('5. Передача третьим лицам', '''
Мы не передаём ваши персональные данные третьим лицам без вашего согласия, за исключением случаев, предусмотренных законодательством.'''),
            _buildSection('6. Ваши права', '''
Вы имеете право на получение, исправление и удаление ваших персональных данных. Для этого обратитесь в нашу поддержку.'''),
            _buildSection('7. Изменения политики', '''
Мы оставляем право на изменение данной политики. О существенных изменениях мы уведомим вас через приложение или по электронной почте.'''),
            const SizedBox(height: 24),
            Text(
              'Контакт по вопросам конфиденциальности: privacy@service-platform.ru',
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
