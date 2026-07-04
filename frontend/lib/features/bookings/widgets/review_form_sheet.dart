import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exceptions.dart';
import '../../../core/models/api/review_model.dart';
import '../../../core/repositories/review_repository.dart';

/// Bottom sheet формы отзыва: звёзды 1-5 (обязательно) + комментарий (опц.).
/// Направление отзыва определяет бэк по booking; здесь только заголовок/подпись.
class ReviewFormSheet extends ConsumerStatefulWidget {
  final String bookingId;
  final String targetName;
  final bool aboutMaster; // true: клиент оценивает мастера; false: мастер клиента

  const ReviewFormSheet({
    super.key,
    required this.bookingId,
    required this.targetName,
    required this.aboutMaster,
  });

  @override
  ConsumerState<ReviewFormSheet> createState() => _ReviewFormSheetState();

  /// Показать форму; возвращает true, если отзыв успешно отправлен.
  static Future<bool?> show(
    BuildContext context, {
    required String bookingId,
    required String targetName,
    required bool aboutMaster,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ReviewFormSheet(
          bookingId: bookingId,
          targetName: targetName,
          aboutMaster: aboutMaster,
        ),
      ),
    );
  }
}

class _ReviewFormSheetState extends ConsumerState<ReviewFormSheet> {
  int _rating = 0;
  String _comment = '';
  bool _submitting = false;

  Future<void> _submit() async {
    if (_rating < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Поставьте оценку (1–5 звёзд)')),
      );
      return;
    }
    final comment = _comment.trim();
    if (comment.isNotEmpty && comment.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Комментарий — минимум 10 символов (или оставьте пустым)'),
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await ref.read(reviewRepositoryProvider).createReview(
            CreateReviewRequest(
              bookingId: widget.bookingId,
              rating: _rating,
              comment: comment.isEmpty ? null : comment,
            ),
          );
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Спасибо за отзыв!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        // 409 — отзыв уже существует: считаем цель достигнутой и закрываем.
        if (e is ApiException && e.statusCode == 409) {
          Navigator.pop(context, true);
          return;
        }
        final msg = e is ApiException ? e.message : e.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Не удалось отправить отзыв: $msg'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.aboutMaster ? 'Оцените мастера' : 'Оцените клиента';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(widget.targetName, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final filled = i < _rating;
                  return IconButton(
                    iconSize: 40,
                    onPressed: _submitting
                        ? null
                        : () => setState(() => _rating = i + 1),
                    icon: Icon(
                      filled ? Icons.star : Icons.star_border,
                      color: Colors.amber[700],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              enabled: !_submitting,
              minLines: 3,
              maxLines: 5,
              maxLength: 1000,
              decoration: const InputDecoration(
                labelText: 'Комментарий (необязательно)',
                hintText: 'Расскажите о впечатлениях (минимум 10 символов)',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => _comment = v,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submitting ? null : _submit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Отправить отзыв'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
