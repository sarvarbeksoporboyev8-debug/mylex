import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/localization/app_strings.dart';
import '../../domain/providers/settings_providers.dart';
import '../widgets/settings_widgets.dart';

class SecurityScreen extends ConsumerWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    final securitySettings = ref.watch(securitySettingsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, strings),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: SpacingTokens.padding20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SettingsSection(
                      children: [
                        SecurityRow(
                          title: strings.twoFactorAuthentication,
                          description: 'Secure your account with 2FA',
                          icon: PhosphorIconsRegular.shieldCheck,
                          value: securitySettings.twoFactorEnabled,
                          onChanged: (value) {
                            ref.read(securitySettingsProvider.notifier).toggleTwoFactor();
                          },
                        ),
                        SecurityRow(
                          title: strings.biometricAuthentication,
                          description: 'Use Face ID or Touch ID',
                          icon: PhosphorIconsRegular.fingerprint,
                          value: securitySettings.biometricEnabled,
                          onChanged: (value) {
                            ref.read(securitySettingsProvider.notifier).toggleBiometric();
                          },
                        ),
                        SecurityRow(
                          title: strings.appLock,
                          description: 'Lock app with PIN',
                          icon: PhosphorIconsRegular.lockKey,
                          value: securitySettings.pinLockEnabled,
                          onChanged: (value) {
                            ref.read(securitySettingsProvider.notifier).togglePinLock();
                          },
                        ),
                      ],
                    ),
                    SpacingTokens.verticalGap12,
                    SettingsSection(
                      children: [
                        SettingsMenuItem(
                          icon: PhosphorIconsRegular.envelope,
                          title: strings.changeEmail,
                          onTap: () => context.push(AppRoutes.twoFactorChangeEmail),
                        ),
                        SettingsMenuItem(
                          icon: PhosphorIconsRegular.lockSimple,
                          title: strings.changePassword,
                          onTap: () {
                            // Navigate to change password
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: SpacingTokens.spacing80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppStrings strings) {
    return SizedBox(
      height: SpacingTokens.spacing60,
      child: Padding(
        padding: SpacingTokens.horizontalPadding20,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: SpacingTokens.spacing44,
                  height: SpacingTokens.spacing44,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEDEDED)),
                    borderRadius: SpacingTokens.borderRadius10,
                    color: AppColors.cardBackground,
                  ),
                  child: const Icon(
                    PhosphorIconsRegular.caretLeft,
                    size: SpacingTokens.iconSize20,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            Text(
              strings.security,
              style: AppTypography.headline4.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
