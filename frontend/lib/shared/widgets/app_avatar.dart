import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Универсальный виджет аватара с fallback на инициалы
/// Генерирует уникальный цвет фона на основе хэша userId для лучшей узнаваемости
class AppAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String? userId;
  final String? fallbackName;
  final double radius;
  final Color? backgroundColor;

  const AppAvatar({
    super.key,
    this.avatarUrl,
    this.userId,
    this.fallbackName,
    this.radius = 20,
    this.backgroundColor,
  });

  /// Генерирует цвет на основе хэша userId
  /// Это гарантирует, что у каждого пользователя без фото всегда будет один и тот же цвет
  Color _generateColorFromUserId(String userId) {
    // Простой хэш от userId
    int hash = 0;
    for (int i = 0; i < userId.length; i++) {
      hash = userId.codeUnitAt(i) + ((hash << 5) - hash);
    }
    
    // Генерируем цвет из хэша (яркие, но не слишком светлые цвета)
    final hue = (hash.abs() % 360).toDouble();
    final saturation = 0.6 + (hash.abs() % 20) / 100.0; // 0.6-0.8
    final lightness = 0.5 + (hash.abs() % 15) / 100.0; // 0.5-0.65
    
    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }

  /// Извлекает инициалы из имени
  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? 
        (userId != null && userId!.isNotEmpty ? _generateColorFromUserId(userId!) : Colors.grey[400]!);
    final initials = _getInitials(fallbackName);

    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      child: avatarUrl != null
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: avatarUrl!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: radius * 0.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                placeholder: (context, url) => SizedBox(
                  width: radius * 2,
                  height: radius * 2,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                initials,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: radius * 0.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}
