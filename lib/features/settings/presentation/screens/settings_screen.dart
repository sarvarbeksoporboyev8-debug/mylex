import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/localization/app_language.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/routing/app_routes.dart';
import '../widgets/settings_widgets.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _appVersion = '1.0.0';

  // Layout constants tuned for BNPL settings design
  static const double _horizontalInset = 20.0;
  static const double _cardRadius = 14.0;
  static const double _sectionRadius = 12.0;
  static const double _rowHeight = 52.0;
  static const double _iconSize = 20.0;
  static const double _iconTextGap = 8.0;
  static const double _titleFontSize = 18.0;
  static const double _rowFontSize = 14.0;
  static const double _sectionHeaderFontSize = 14.0;
  static const double _dividerInset = 16.0;

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

    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // Pinned profile header row
          SliverAppBar(
            pinned: true,
            toolbarHeight: 88,
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            flexibleSpace: SafeArea(
              bottom: false,
              child: _buildPinnedProfileHeader(context),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.5),
              child: Container(
                height: 0.5,
                color: const Color(0xFFEDEDED),
              ),
            ),
          ),
          // Content sections
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              _horizontalInset,
              16,
              _horizontalInset,
              0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildPersonalInfoSection(strings),
                const SizedBox(height: 12),
                _buildLinkedBanksSection(strings),
                const SizedBox(height: 12),
                _buildAppSettingsSection(strings, currentLanguage),
                const SizedBox(height: 12),
                _buildHelpLegalSection(strings),
                const SizedBox(height: 24),
                _buildLogoutRow(strings),
                const SizedBox(height: 16),
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
    );
  }

  Widget _buildPinnedProfileHeader(BuildContext context) {
    return SettingsProfileHeader(
      name: 'Ali Muhajirin',
      phone: '+1 (555) 123-4567',
      editLabel: ref.watch(stringsProvider).edit,
      editRoute: AppRoutes.editProfile,
      horizontalPadding: _horizontalInset,
    );
  }


  Widget _buildAvailableToSpendCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available to Spent',
              style: AppTypography.bodyMedium.copyWith(
                color: const Color(0xFF101010),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$512.23 used',
                  style: AppTypography.bodySmall.copyWith(
                    color: const Color(0xFF606060),
                  ),
                ),
                Text(
                  '\$5.000 available',
                  style: AppTypography.bodySmall.copyWith(
                    color: const Color(0xFF606060),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 7,
                color: const Color(0xFFEDEDED),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.6,
                  child: Container(
                    color: AppColors.accent,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Repay before 1 Jul 2025',
                      style: AppTypography.bodySmall.copyWith(
                        color: const Color(0xFF606060),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$678.33',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF101010),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF101010),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Repay',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection(AppStrings strings) {
    return SettingsSection(
      title: strings.personalInformation,
      borderRadius: _sectionRadius,
      titleFontSize: _sectionHeaderFontSize,
      horizontalPadding: _horizontalInset,
      child: Column(
        children: [
          SettingsMenuItem.withValue(
            label: strings.fullName,
            value: 'Ali Muhajirin',
            fontSize: _rowFontSize,
            height: _rowHeight,
            horizontalPadding: 12,
          ),
          const SettingsMenuDivider(leftInset: 16, rightInset: 16),
          SettingsMenuItem.withValue(
            label: strings.email,
            value: 'helloali@gmail.com',
            fontSize: _rowFontSize,
            height: _rowHeight,
            horizontalPadding: 12,
          ),
          const SettingsMenuDivider(leftInset: 16, rightInset: 16),
          SettingsMenuItem.withValue(
            label: strings.phone,
            value: '+1 (555) 123-4567',
            fontSize: _rowFontSize,
            height: _rowHeight,
            horizontalPadding: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildLinkedBanksSection(AppStrings strings) {
    return SettingsSection(
      title: strings.linkedBankAccounts,
      borderRadius: _sectionRadius,
      titleFontSize: _sectionHeaderFontSize,
      horizontalPadding: _horizontalInset,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SettingsPaymentCard(
              name: 'Emirates NBD Bank',
              last4: '4567',
              isPrimary: true,
              statusLabel: strings.complete,
              borderRadius: 12,
            ),
            const SizedBox(height: 10),
            SettingsPaymentCard(
              name: 'Citi Bank',
              last4: '4567',
              isPrimary: false,
              borderRadius: 12,
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.addBankAccount),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                side: const BorderSide(color: Color(0xFFEDEDED)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(
                PhosphorIconsRegular.plus,
                size: 16,
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
      ),
    );
  }

  Widget _buildAppSettingsSection(
    AppStrings strings,
    AppLanguage currentLanguage,
  ) {
    return SettingsSection(
      title: strings.appSettings,
      borderRadius: _sectionRadius,
      titleFontSize: _sectionHeaderFontSize,
      horizontalPadding: _horizontalInset,
      child: Column(
        children: [
          SettingsMenuItem.withChevron(
            icon: PhosphorIconsRegular.bell,
            iconSize: _iconSize,
            label: strings.notifications,
            fontSize: _rowFontSize,
            height: _rowHeight,
            horizontalPadding: _horizontalInset,
            iconTextGap: _iconTextGap,
            onTap: () => context.push(AppRoutes.notifications),
          ),
          const SettingsMenuDivider(),
          SettingsMenuItem.withChevron(
            icon: PhosphorIconsRegular.lock,
            iconSize: _iconSize,
            label: strings.security,
            fontSize: _rowFontSize,
            height: _rowHeight,
            horizontalPadding: _horizontalInset,
            iconTextGap: _iconTextGap,
            onTap: () => context.push(AppRoutes.security),
          ),
          const SettingsMenuDivider(),
          SettingsMenuItem(
            icon: PhosphorIconsRegular.globe,
            iconSize: _iconSize,
            label: strings.languageLabel,
            fontSize: _rowFontSize,
            height: _rowHeight,
            horizontalPadding: _horizontalInset,
            iconTextGap: _iconTextGap,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentLanguage.nativeName,
                  style: const TextStyle(
                    fontSize: _rowFontSize,
                    color: Color(0xFF606060),
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  PhosphorIconsRegular.caretRight,
                  size: 16,
                  color: Color(0xFF878787),
                ),
              ],
            ),
            onTap: () => LanguageSelectorModal.show(
              context: context,
              ref: ref,
              strings: strings,
              currentLanguage: currentLanguage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpLegalSection(AppStrings strings) {
    return SettingsSection(
      title: strings.helpAndLegal,
      borderRadius: _sectionRadius,
      titleFontSize: _sectionHeaderFontSize,
      horizontalPadding: _horizontalInset,
      child: Column(
        children: [
          SettingsMenuItem.withChevron(
            icon: PhosphorIconsRegular.question,
            iconSize: _iconSize,
            label: strings.faq,
            fontSize: _rowFontSize,
            height: _rowHeight,
            horizontalPadding: _horizontalInset,
            iconTextGap: _iconTextGap,
            onTap: () => context.push(AppRoutes.faq),
          ),
          const SettingsMenuDivider(),
          SettingsMenuItem.withChevron(
            icon: PhosphorIconsRegular.note,
            iconSize: _iconSize,
            label: strings.termsAndConditions,
            fontSize: _rowFontSize,
            height: _rowHeight,
            horizontalPadding: _horizontalInset,
            iconTextGap: _iconTextGap,
            onTap: () => context.push(AppRoutes.termsConditions),
          ),
          const SettingsMenuDivider(),
          SettingsMenuItem.withChevron(
            icon: PhosphorIconsRegular.shieldCheckered,
            iconSize: _iconSize,
            label: strings.privacyPolicy,
            fontSize: _rowFontSize,
            height: _rowHeight,
            horizontalPadding: _horizontalInset,
            iconTextGap: _iconTextGap,
            onTap: () => context.push(AppRoutes.privacyPolicy),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutRow(AppStrings strings) {
    return SettingsSection(
      borderRadius: _sectionRadius,
      child: SettingsMenuItem(
        icon: PhosphorIconsRegular.signOut,
        iconSize: _iconSize,
        label: strings.logout,
        fontSize: _rowFontSize,
        height: _rowHeight,
        horizontalPadding: _horizontalInset,
        iconTextGap: _iconTextGap,
        onTap: () => context.go(AppRoutes.login),
      ),
    );
  }

  Future<void> _openTelegram() async {
    final url = Uri.parse('https://t.me/lexuz_ai');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
