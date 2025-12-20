import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();

    // Navigate to onboarding after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.miscellaneous_services_rounded,
                size: 100,
                color: theme.colorScheme.onPrimary,
              ),
              const SizedBox(height: 24),
              Text(
                'Service Platform',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Найди своего мастера',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
