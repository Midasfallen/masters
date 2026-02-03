import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/api/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _hasNavigated = false; // Prevent multiple navigations

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
  }

  Future<void> _navigateBasedOnAuth(bool isAuthenticated) async {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;

    // Check first run flag
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final isFirstRun = prefs.getBool('isFirstRun') ?? true;

    if (!mounted) return;

    // Navigation logic: Auth has priority over onboarding
    // 1. If authenticated - always go to Feed (ignore isFirstRun)
    if (isAuthenticated) {
      context.go('/');
    } 
    // 2. If not authenticated AND first run - show onboarding
    else if (isFirstRun) {
      context.go('/onboarding');
    } 
    // 3. If not authenticated AND not first run - go to Login
    else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth state reactively - this will rebuild when state changes
    final authState = ref.watch(authNotifierProvider);

    // Handle navigation based on auth state
    authState.when(
      data: (state) {
        // Navigate after frame is built to avoid navigation during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _hasNavigated) return;
          _navigateBasedOnAuth(state.isAuthenticated);
        });
      },
      loading: () {
        // Show splash screen while loading
      },
      error: (error, stackTrace) {
        // On error, navigate to login
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _hasNavigated) return;
          _hasNavigated = true;
          context.go('/login');
        });
      },
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.miscellaneous_services_rounded,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                Text(
                  'Service Platform',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Найди своего мастера',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
