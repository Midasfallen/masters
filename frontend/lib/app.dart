import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
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
  final Set<String> _favoriteIds = {};

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await initializeDateFormatting('ru', null);
    await _loadThemePreference();
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

  void toggleFavorite(String masterId) {
    setState(() {
      if (_favoriteIds.contains(masterId)) {
        _favoriteIds.remove(masterId);
      } else {
        _favoriteIds.add(masterId);
      }
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', 'RU'),
      ],
      locale: const Locale('ru', 'RU'),
      builder: (context, child) {
        return FavoritesNotifier(
          favoriteIds: _favoriteIds,
          toggleFavorite: toggleFavorite,
          child: ThemeNotifier(
            changeTheme: changeTheme,
            currentTheme: _themeName,
            child: child!,
          ),
        );
      },
    );
  }
}

// Favorites notifier для управления избранным
class FavoritesNotifier extends InheritedWidget {
  final Set<String> favoriteIds;
  final Function(String) toggleFavorite;

  const FavoritesNotifier({
    super.key,
    required this.favoriteIds,
    required this.toggleFavorite,
    required super.child,
  });

  static FavoritesNotifier? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FavoritesNotifier>();
  }

  @override
  bool updateShouldNotify(FavoritesNotifier oldWidget) {
    return favoriteIds != oldWidget.favoriteIds;
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
