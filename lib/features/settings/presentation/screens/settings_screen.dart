import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/localization/app_language.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/routing/app_routes.dart';
import '../../domain/providers/settings_providers.dart';
import '../widgets/settings_widgets.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _appVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() => _appVersion = info.version);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);
    final currentLanguage = ref.watch(languageProvider);

    // Use MediaQuery for responsive design instead of hardcoded values
    final screenSize = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Pinned profile header
            SliverAppBar(
              pinned: true,
              toolbarHeight: isTablet ? 100 : 88,
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              flexibleSpace: SafeArea(
                bottom: false,
                child: ProfileHeader(
                  name: 'Ali Muhajirin',
                  phone: '+1 (555) 123-4567',
                  onBackPressed: () => context.pop(),
                  onEditPressed: () => context.push(AppRoutes.editProfile),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0.5),
                child: Container(
                  height: 0.5,
                  color: const Color(0xFFEDEDED),
                ),
              ),
            ),
            // Content sections with responsive padding
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                isTablet ? SpacingTokens.spacing32 : SpacingTokens.spacing20,
                SpacingTokens.spacing16,
                isTablet ? SpacingTokens.spacing32 : SpacingTokens.spacing20,
                0,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildPersonalInfoSection(strings),
                  SpacingTokens.gapV12,
                  _buildLinkedBanksSection(strings),
                  SpacingTokens.gapV12,
                  _buildAppSettingsSection(strings, currentLanguage),
                  SpacingTokens.gapV12,
                  _buildHelpLegalSection(strings),
                  SpacingTokens.gapV24,
                  _buildLogoutRow(strings),
                  SpacingTokens.gapV16,
                  Center(
                    child: Text(
                      'v$_appVersion',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                  SizedBox(height: bottomPadding + 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection(AppStrings strings) {
    return SettingsSection(
      title: strings.personalInformation,
      child: Column(
        children: [
          _buildStaticRow(strings.fullName, 'Ali Muhajirin'),
          const SettingsMenuDivider(),
          _buildStaticRow(strings.email, 'helloali@gmail.com'),
          const SettingsMenuDivider(),
          _buildStaticRow(strings.phone, '+1 (555) 123-4567'),
        ],
      ),
    );
  }

  Widget _buildStaticRow(String label, String value) {
    return SizedBox(
      height: 52.0,
      child: Padding(
        padding: SpacingTokens.paddingHorizontal12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14.0,
                color: Color(0xFF101010),
                fontFamily: 'Roboto',
              ),
            ),
            Flexible(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Color(0xFF606060),
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkedBanksSection(AppStrings strings) {
    return SettingsSection(
      title: strings.linkedBankAccounts,
      padding: SpacingTokens.padding12,
      child: Column(
        children: [
          BankCard(
            name: 'Emirates NBD Bank',
            last4: '4567',
            isPrimary: true,
            statusLabel: strings.complete,
          ),
          SpacingTokens.gapV10,
          BankCard(
            name: 'Citi Bank',
            last4: '4567',
            isPrimary: false,
            statusLabel: strings.complete,
          ),
          SpacingTokens.gapV10,
          OutlinedButton.icon(
            onPressed: () => context.push(AppRoutes.addBankAccount),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.spacing16,
                vertical: SpacingTokens.spacing6,
              ),
              side: const BorderSide(color: Color(0xFFEDEDED)),
              shape: RoundedRectangleBorder(
                borderRadius: SpacingTokens.borderRadiusMedium,
              ),
            ),
            icon: const Icon(
              PhosphorIconsRegular.plus,
              size: SpacingTokens.iconSizeSmall,
              color: Color(0xFF101010),
            ),
            label: Text(
              strings.addBankAccount,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF101010),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsSection(
    AppStrings strings,
    AppLanguage currentLanguage,
  ) {
    return SettingsSection(
      title: strings.appSettings,
      child: Column(
        children: [
          SettingsMenuItem(
            icon: PhosphorIconsRegular.bell,
            label: strings.notifications,
            trailing: const Icon(
              PhosphorIconsRegular.caretRight,
              size: SpacingTokens.iconSizeSmall,
              color: Color(0xFF878787),
            ),
            onTap: () => context.push(AppRoutes.notifications),
          ),
          const SettingsMenuDivider(),
          SettingsMenuItem(
            icon: PhosphorIconsRegular.lock,
            label: strings.security,
            trailing: const Icon(
              PhosphorIconsRegular.caretRight,
              size: SpacingTokens.iconSizeSmall,
              color: Color(0xFF878787),
            ),
            onTap: () => context.push(AppRoutes.security),
          ),
          const SettingsMenuDivider(),
          SettingsMenuItem(
            icon: PhosphorIconsRegular.globe,
            label: strings.languageLabel,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentLanguage.nativeName,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF606060),
                    fontFamily: 'Roboto',
                  ),
                ),
                SpacingTokens.gapH4,
                const Icon(
                  PhosphorIconsRegular.caretRight,
                  size: SpacingTokens.iconSizeSmall,
                  color: Color(0xFF878787),
                ),
              ],
            ),
            onTap: () => LanguageSelectorModal.show(
              context,
              ref,
              currentLanguage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpLegalSection(AppStrings strings) {
    return SettingsSection(
      title: strings.helpAndLegal,
      child: Column(
        children: [
          SettingsMenuItem(
            icon: PhosphorIconsRegular.question,
            label: strings.faq,
            trailing: const Icon(
              PhosphorIconsRegular.caretRight,
              size: SpacingTokens.iconSizeSmall,
              color: Color(0xFF878787),
            ),
            onTap: () => context.push(AppRoutes.faq),
          ),
          const SettingsMenuDivider(),
          SettingsMenuItem(
            icon: PhosphorIconsRegular.note,
            label: strings.termsAndConditions,
            trailing: const Icon(
              PhosphorIconsRegular.caretRight,
              size: SpacingTokens.iconSizeSmall,
              color: Color(0xFF878787),
            ),
            onTap: () => context.push(AppRoutes.termsConditions),
          ),
          const SettingsMenuDivider(),
          SettingsMenuItem(
            icon: PhosphorIconsRegular.shieldCheckered,
            label: strings.privacyPolicy,
            trailing: const Icon(
              PhosphorIconsRegular.caretRight,
              size: SpacingTokens.iconSizeSmall,
              color: Color(0xFF878787),
            ),
            onTap: () => context.push(AppRoutes.privacyPolicy),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutRow(AppStrings strings) {
    return SettingsSection(
      child: SettingsMenuItem(
        icon: PhosphorIconsRegular.signOut,
        label: strings.logout,
        onTap: () => context.go(AppRoutes.login),
      ),
    );
  }
}
