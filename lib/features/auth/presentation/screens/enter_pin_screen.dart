import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_background.dart';
import '../../domain/auth_state.dart';
import '../widgets/pin_keypad.dart';

class EnterPinScreen extends ConsumerStatefulWidget {
  const EnterPinScreen({super.key});

  @override
  ConsumerState<EnterPinScreen> createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends ConsumerState<EnterPinScreen> {
  String _pin = '';
  bool _hasError = false;
  int _attempts = 0;

  void _onKeyPressed(String key) {
    if (_pin.length < AppConstants.pinLength) {
      setState(() {
        _pin += key;
        _hasError = false;
      });

      HapticFeedback.lightImpact();

      if (_pin.length == AppConstants.pinLength) {
        _verifyPin();
      }
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _hasError = false;
      });
      HapticFeedback.selectionClick();
    }
  }

  Future<void> _verifyPin() async {
    final success = await ref.read(authProvider.notifier).verifyPin(_pin);

    if (success && mounted) {
      context.go(AppRoutes.constitution);
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _hasError = true;
        _attempts++;
      });

      // Clear after animation
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _pin = '';
            _hasError = false;
          });
        }
      });
    }
  }

  void _onBiometric() {
    // TODO: Implement biometric authentication
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: GoldBackground(
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPaddingLarge,
            child: Column(
              children: [
                const Spacer(flex: 1),

                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.balance_rounded,
                    size: 40,
                    color: AppColors.textOnGold,
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                Text(
                  'Lex.uz AI',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'PIN кодни киритинг',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Error message
                if (_hasError) ...[
                  const SizedBox(height: 8),
                  Text(
                    _attempts >= 3
                        ? 'Жуда кўп уриниш. Қайта киринг.'
                        : 'Нотўғри PIN код',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],

                const SizedBox(height: 40),

                // PIN dots
                PinDots(
                  filledCount: _pin.length,
                  hasError: _hasError,
                ),

                const Spacer(flex: 1),

                // Loading indicator or keypad
                if (authState.status == AuthStatus.loading)
                  const SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation(AppColors.gold),
                    ),
                  )
                else
                  PinKeypad(
                    onKeyPressed: _onKeyPressed,
                    onDelete: _onDelete,
                    onBiometric: _onBiometric,
                    showBiometric: true,
                  ),

                const SizedBox(height: 24),

                // Reset PIN option
                TextButton(
                  onPressed: () async {
                    await ref.read(authProvider.notifier).resetPin();
                    if (mounted) {
                      context.go(AppRoutes.createPin);
                    }
                  },
                  child: Text(
                    'PIN кодни унутдингизми?',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
