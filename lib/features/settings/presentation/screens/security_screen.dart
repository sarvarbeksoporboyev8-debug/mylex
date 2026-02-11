import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_strings.dart';
import '../widgets/settings_widgets.dart';

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  bool _faceIdEnabled = false;
  bool _appLockEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            SettingsScreenHeader(
              title: ref.watch(stringsProvider).security,
            ),
            // Content - single scroll area on app background
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
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

  Widget _buildSecurityCard() {
    final strings = ref.watch(stringsProvider);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF5F5F5)),
      ),
      child: Column(
        children: [
          SettingsMenuItem(
            icon: PhosphorIconsRegular.deviceMobile,
            label: strings.twoFactorAuthentication,
            fontSize: 14,
            height: 52,
            horizontalPadding: 16,
            iconTextGap: 12,
            trailing: const Icon(
              PhosphorIconsRegular.caretRight,
              size: 20,
              color: Color(0xFF878787),
            ),
            onTap: () => context.push(AppRoutes.twoFactorChangeEmail),
          ),
          _buildDivider(),
          SettingsMenuItem(
            icon: PhosphorIconsRegular.key,
            label: strings.resetPassword,
            fontSize: 14,
            height: 52,
            horizontalPadding: 16,
            iconTextGap: 12,
            trailing: const Icon(
              PhosphorIconsRegular.caretRight,
              size: 20,
              color: Color(0xFF878787),
            ),
            onTap: () => context.push(AppRoutes.forgotPassword),
          ),
          _buildDivider(),
          SettingsMenuItem(
            icon: PhosphorIconsRegular.scan,
            label: strings.useFaceIdToLogin,
            fontSize: 14,
            height: 52,
            horizontalPadding: 16,
            iconTextGap: 12,
            trailing: _buildToggle(_faceIdEnabled, (value) {
              setState(() => _faceIdEnabled = value);
            }),
          ),
          _buildDivider(),
          SettingsMenuItem(
            icon: PhosphorIconsRegular.lock,
            label: strings.appLock,
            fontSize: 14,
            height: 52,
            horizontalPadding: 16,
            iconTextGap: 12,
            trailing: _buildToggle(_appLockEnabled, (value) {
              setState(() => _appLockEnabled = value);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color(0xFFF5F5F5),
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
