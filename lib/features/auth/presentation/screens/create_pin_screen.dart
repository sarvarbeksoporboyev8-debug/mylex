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

class CreatePinScreen extends ConsumerStatefulWidget {
  const CreatePinScreen({super.key});

  @override
  ConsumerState<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends ConsumerState<CreatePinScreen> {
  String _pin = '';

  void _onKeyPressed(String key) {
    if (_pin.length < AppConstants.pinLength) {
      setState(() {
        _pin += key;
      });

      HapticFeedback.lightImpact();

      if (_pin.length == AppConstants.pinLength) {
        // Navigate to confirm PIN
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            ref.read(authProvider.notifier).setPin(_pin);
            context.go(AppRoutes.confirmPin, extra: _pin);
          }
        });
      }
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoldBackground(
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPaddingLarge,
            child: Column(
              children: [
                const Spacer(flex: 1),

                // Icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.glassFill,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    size: 32,
                    color: AppColors.gold,
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                Text(
                  'PIN код яратинг',
                  style: AppTypography.headlineSmall,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  '${AppConstants.pinLength} рақамли PIN код киритинг',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // PIN dots
                PinDots(filledCount: _pin.length),

                const Spacer(flex: 1),

                // Keypad
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
