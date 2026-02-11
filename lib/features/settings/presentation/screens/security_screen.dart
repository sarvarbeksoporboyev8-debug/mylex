import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/localization/app_strings.dart';
import '../../domain/providers/settings_providers.dart';
import '../widgets/settings_widgets.dart';

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(
                  isTablet ? SpacingTokens.spacing32 : SpacingTokens.spacing20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSecurityCard(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: SpacingTokens.paddingHorizontal20,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEDEDED)),
                    borderRadius: SpacingTokens.borderRadiusLarge,
                    color: Colors.white,
                  ),
                  child: const Icon(
                    PhosphorIconsRegular.caretLeft,
                    size: SpacingTokens.iconSize,
                    color: Color(0xFF101010),
                  ),
                ),
              ),
            ),
            Text(
              ref.watch(stringsProvider).security,
              style: const TextStyle(
                fontFamily: 'Onest',
                fontWeight: FontWeight.w500,
                fontSize: 18,
                height: 1.5,
                color: Color(0xFF101010),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityCard() {
    final strings = ref.watch(stringsProvider);
    final settingsState = ref.watch(settingsStateProvider);

    return SettingsSection(
      child: Column(
        children: [
          SettingsMenuItem(
            icon: PhosphorIconsRegular.deviceMobile,
            label: strings.twoFactorAuthentication,
            trailing: const Icon(
              PhosphorIconsRegular.caretRight,
              size: SpacingTokens.iconSize,
              color: Color(0xFF878787),
            ),
            onTap: () => context.push(AppRoutes.twoFactorChangeEmail),
          ),
          const SettingsMenuDivider(),
          SettingsMenuItem(
            icon: PhosphorIconsRegular.key,
            label: strings.resetPassword,
            trailing: const Icon(
              PhosphorIconsRegular.caretRight,
              size: SpacingTokens.iconSize,
              color: Color(0xFF878787),
            ),
            onTap: () => context.push(AppRoutes.forgotPassword),
          ),
          const SettingsMenuDivider(),
          SettingsMenuItem(
            icon: PhosphorIconsRegular.scan,
            label: strings.useFaceIdToLogin,
            trailing: _buildToggle(
              settingsState.faceIdEnabled,
              (value) => ref.read(settingsStateProvider.notifier).toggleFaceId(value),
            ),
          ),
          const SettingsMenuDivider(),
          SettingsMenuItem(
            icon: PhosphorIconsRegular.lock,
            label: strings.appLock,
            trailing: _buildToggle(
              settingsState.appLockEnabled,
              (value) => ref.read(settingsStateProvider.notifier).toggleAppLock(value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 40,
        height: 24,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: value ? AppColors.accent.withOpacity(0.12) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: value ? 16 : 0,
              right: value ? 0 : 16,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: value ? AppColors.accent : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10.5,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
