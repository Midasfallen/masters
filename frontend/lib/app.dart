import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';

class ServicePlatformApp extends StatefulWidget {
  const ServicePlatformApp({super.key});

  @override
  State<ServicePlatformApp> createState() => _ServicePlatformAppState();
}

class _ServicePlatformAppState extends State<ServicePlatformApp> {
  ThemeMode _themeMode = ThemeMode.light;
  String _themeName = 'light';

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('theme') ?? 'light';
    setState(() {
      _themeName = savedTheme;
      _themeMode = _getThemeModeFromName(savedTheme);
    });
  }

  ThemeMode _getThemeModeFromName(String name) {
    switch (name) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  void changeTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', themeName);
    setState(() {
      _themeName = themeName;
      _themeMode = _getThemeModeFromName(themeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Service Platform',
      debugShowCheckedModeBanner: false,
      theme: _themeName == 'custom'
          ? AppTheme.customTheme
          : AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return ThemeNotifier(
          changeTheme: changeTheme,
          currentTheme: _themeName,
          child: child!,
        );
      },
    );
  }
}

// Theme notifier для доступа к функции смены темы из любого места
class ThemeNotifier extends InheritedWidget {
  final Function(String) changeTheme;
  final String currentTheme;

  const ThemeNotifier({
    super.key,
    required this.changeTheme,
    required this.currentTheme,
    required super.child,
  });

  static ThemeNotifier? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeNotifier>();
  }

  @override
  bool updateShouldNotify(ThemeNotifier oldWidget) {
    return currentTheme != oldWidget.currentTheme;
  }
}
