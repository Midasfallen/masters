import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  // Configure timeago for Russian locale
  timeago.setLocaleMessages('ru', timeago.RuMessages());

  runApp(
    const ProviderScope(
      child: ServicePlatformApp(),
    ),
  );
}

class ServicePlatformApp extends ConsumerWidget {
  const ServicePlatformApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Service Platform v2.0',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
