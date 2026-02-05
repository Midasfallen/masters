import 'package:service_platform/core/api/api_exceptions.dart';

/// Возвращает человекопонятное сообщение об ошибке для экранов входа и регистрации.
String authErrorMessage(Object error, {required bool isLogin}) {
  if (error is ApiException) {
    if (error is UnauthorizedException) {
      return isLogin
          ? 'Неверный email или пароль. Проверьте данные и попробуйте снова.'
          : 'Ошибка авторизации. Проверьте введённые данные.';
    }
    if (error is ValidationException) {
      final msg = error.message;
      if (msg.isNotEmpty && msg != 'Validation failed') {
        return msg;
      }
      return 'Проверьте правильность введённых данных.';
    }
    if (error is BadRequestException) {
      final msg = error.message;
      if (msg.isNotEmpty && msg != 'Bad request') {
        return msg;
      }
      return isLogin
          ? 'Не удалось войти. Проверьте email и пароль.'
          : 'Не удалось создать аккаунт. Проверьте данные.';
    }
    if (error is NetworkException) {
      return 'Нет подключения к интернету. Проверьте сеть и попробуйте снова.';
    }
    if (error is TimeoutException) {
      return 'Превышено время ожидания. Попробуйте снова.';
    }
    if (error is ServerException) {
      return 'Сервер временно недоступен. Попробуйте позже.';
    }
    if (error is ForbiddenException) {
      return 'Доступ запрещён.';
    }
    // 409 Conflict (дубликат email/телефона) может приходить как BadRequest с сообщением
    // Любая другая ApiException — показываем message, если он по-русски или короткий
    final msg = error.message;
    if (msg.isNotEmpty && _looksUserFriendly(msg)) {
      return msg;
    }
  }
  return isLogin
      ? 'Не удалось войти. Проверьте данные и попробуйте снова.'
      : 'Не удалось зарегистрироваться. Попробуйте позже.';
}

bool _looksUserFriendly(String s) {
  final lower = s.toLowerCase();
  if (s.length > 120) return false;
  // Избегаем показывать технические фразы
  if (lower.contains('exception') ||
      lower.contains('null') ||
      lower.contains('subtype') ||
      lower.contains('type \'') ||
      lower.contains('status:')) {
    return false;
  }
  return true;
}
