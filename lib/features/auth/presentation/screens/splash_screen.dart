import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_background.dart';
import '../../domain/auth_state.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _didPrecache = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_didPrecache) return;
    _didPrecache = true;

    // Precache heavy image assets to avoid flashing during the first render.
    precacheImage(const AssetImage(AppConstants.backgroundAsset), context);
    precacheImage(const AssetImage(AppConstants.navKonstitutsiya), context);
    precacheImage(const AssetImage(AppConstants.navKodekslar), context);
    precacheImage(const AssetImage(AppConstants.navChatbot), context);
    precacheImage(const AssetImage(AppConstants.navQonunlar), context);
    precacheImage(const AssetImage(AppConstants.navYangiliklar), context);
  }

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Run auth check but don't let it block the splash forever.
    try {
      await Future.any<void>(
        [
          // Real auth status check
          ref.read(authProvider.notifier).checkAuthStatus(),
          // Fallback timeout in case secure storage/auth hangs
          Future.delayed(const Duration(seconds: 3)),
        ],
      );
    } catch (_) {
      // Ignore errors here – we'll just treat the user as logged out.
    }

    // Short splash delay for brand feel.
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authState = ref.read(authProvider);

    // If logged in -> go to main app, otherwise -> login screen
    if (authState.isLoggedIn) {
      context.go(AppRoutes.constitution);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoldBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'YuristAI',
                style: AppTypography.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Yuridik yordamchi',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.gold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
