import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/app_background.dart';
import '../../domain/auth_state.dart';
import '../widgets/pin_keypad.dart';

class ConfirmPinScreen extends ConsumerStatefulWidget {
  final String pin;

  const ConfirmPinScreen({
    super.key,
    required this.pin,
  });

  @override
  ConsumerState<ConfirmPinScreen> createState() => _ConfirmPinScreenState();
}

class _ConfirmPinScreenState extends ConsumerState<ConfirmPinScreen> {
  String _confirmPin = '';
  bool _hasError = false;

  void _onKeyPressed(String key) {
    if (_confirmPin.length < AppConstants.pinLength) {
      setState(() {
        _confirmPin += key;
        _hasError = false;
      });

      HapticFeedback.lightImpact();

      if (_confirmPin.length == AppConstants.pinLength) {
        _verifyPin();
      }
    }
  }

  void _onDelete() {
    if (_confirmPin.isNotEmpty) {
      setState(() {
        _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        _hasError = false;
      });
      HapticFeedback.selectionClick();
    }
  }

  Future<void> _verifyPin() async {
    if (_confirmPin == widget.pin) {
      // PINs match - save and proceed
      final success = await ref.read(authProvider.notifier).confirmPin(_confirmPin);

      if (mounted && success) {
        context.go(AppRoutes.constitution);
      }
    } else {
      // PINs don't match
      HapticFeedback.heavyImpact();
      setState(() {
        _hasError = true;
      });

      // Clear after animation
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _confirmPin = '';
            _hasError = false;
          });
        }
      });
    }
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
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: GlassIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => context.go(AppRoutes.createPin),
                  ),
                ),

                const Spacer(flex: 1),

                // Icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: _hasError
                        ? AppColors.error.withOpacity(0.1)
                        : AppColors.glassFill,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _hasError
                          ? AppColors.error.withOpacity(0.5)
                          : AppColors.glassBorder,
                    ),
                  ),
                  child: Icon(
                    _hasError ? Icons.close_rounded : Icons.lock_outline_rounded,
                    size: 32,
                    color: _hasError ? AppColors.error : AppColors.gold,
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                Text(
                  'PIN кодни тасдиқланг',
                  style: AppTypography.headlineSmall,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  _hasError
                      ? 'PIN кодлар мос келмади'
                      : 'PIN кодни қайта киритинг',
                  style: AppTypography.bodyMedium.copyWith(
                    color: _hasError ? AppColors.error : AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // PIN dots
                PinDots(
                  filledCount: _confirmPin.length,
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
                  ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
