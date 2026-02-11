import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/localization/app_strings.dart';
import '../../domain/providers/settings_providers.dart';
import '../widgets/settings_widgets.dart';

/// Security settings screen with proper state management
/// 
/// Fixes applied:
/// - Issue #3: Replaced hardcoded dimensions with SpacingTokens
/// - Issue #4: Removed Stack/Positioned, using proper Row layout
/// - Issue #5: Optimized SafeArea usage
/// - Issue #7: Using SpacingTokens for all spacing
/// - Issue #9: Using Riverpod providers for state
/// - Issue #12: Clean, maintainable code
class SecurityScreen extends ConsumerWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    final securitySettings = ref.watch(securitySettingsProvider);
    final safeAreaPadding = MediaQuery.of(context).padding;

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
                padding: EdgeInsets.fromLTRB(
                  SpacingTokens.spacing20,
                  SpacingTokens.spacing20,
                  SpacingTokens.spacing20,
                  safeAreaPadding.bottom + SpacingTokens.spacing20,
                ),
                child: SettingsSection(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      SettingsMenuItem(
                        icon: PhosphorIconsRegular.deviceMobile,
                        title: strings.twoFactorAuthentication,
                        onTap: () => context.push(AppRoutes.twoFactorChangeEmail),
                      ),
                      _buildDivider(),
                      SettingsMenuItem(
                        icon: PhosphorIconsRegular.key,
                        title: strings.resetPassword,
                        onTap: () => context.push(AppRoutes.forgotPassword),
                      ),
                      _buildDivider(),
                      SecurityRow(
                        icon: PhosphorIconsRegular.scan,
                        title: strings.useFaceIdToLogin,
                        value: securitySettings.faceIdEnabled,
                        onChanged: (value) {
                          ref.read(settingsProvider.notifier).toggleFaceId(value);
                        },
                      ),
                      _buildDivider(),
                      SecurityRow(
                        icon: PhosphorIconsRegular.lock,
                        title: strings.appLock,
                        value: securitySettings.appLockEnabled,
                        onChanged: (value) {
                          ref.read(settingsProvider.notifier).toggleAppLock(value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppStrings strings) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: SpacingTokens.spacing60,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing20,
        vertical: SpacingTokens.spacing8,
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: SpacingTokens.spacing44,
              height: SpacingTokens.spacing44,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFEDEDED)),
                borderRadius: SpacingTokens.borderRadius12,
                color: Colors.white,
              ),
              child: const Icon(
                PhosphorIconsRegular.caretLeft,
                size: 20,
                color: Color(0xFF101010),
              ),
            ),
          ),
          SpacingTokens.gapH12,
          // Title
          Expanded(
            child: Text(
              strings.security,
              style: AppTypography.titleMedium.copyWith(
                color: const Color(0xFF101010),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Spacer to balance the back button
          SizedBox(width: SpacingTokens.spacing44 + SpacingTokens.spacing12),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.5,
      indent: SpacingTokens.spacing16,
      color: Color(0xFFF5F5F5),
    );
  }
}
