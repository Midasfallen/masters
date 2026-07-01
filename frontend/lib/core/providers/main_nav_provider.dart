import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Индекс активного таба нижней навигации в [MainNavigationScreen].
/// 0 — Feed, 1 — Поиск, 2 — Чаты, 3 — Записи, 4 — Профиль.
///
/// Позволяет другим экранам программно переключать таб (напр. кнопка
/// «Новая запись» на табе «Записи» переводит пользователя на таб «Поиск»),
/// т.к. табы живут в IndexedStack, а не в отдельных GoRoute.
final mainNavIndexProvider = StateProvider<int>((ref) => 0);

/// Удобные константы индексов табов, чтобы не хардкодить числа по коду.
class MainNavTab {
  static const int feed = 0;
  static const int search = 1;
  static const int chats = 2;
  static const int bookings = 3;
  static const int profile = 4;
}
