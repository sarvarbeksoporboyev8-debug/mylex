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
import '../../../auth/domain/auth_state.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalInset, vertical: 8),
      child: Row(
        children: [
          // Back arrow
          GestureDetector(
            onTap: () => context.pop(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFEDEDED)),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: const Icon(
                PhosphorIconsRegular.caretLeft,
                size: 20,
                color: Color(0xFF101010),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Icon(
              PhosphorIconsRegular.user,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 8),
          // Name + Phone
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ali Muhajirin',
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF101010),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '+1 (555) 123-4567',
                  style: AppTypography.bodySmall.copyWith(
                    color: const Color(0xFF606060),
                  ),
                ),
              ],
            ),
          ),
          // Edit button
          OutlinedButton.icon(
            onPressed: () => context.push(AppRoutes.editProfile),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              visualDensity: VisualDensity.compact,
              side: const BorderSide(color: Color(0xFFEDEDED)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(
              PhosphorIconsRegular.pencilSimple,
              size: 16,
              color: Color(0xFF101010),
            ),
            label: Text(
              ref.watch(stringsProvider).edit,
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

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: child,
    );
  }

  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_sectionRadius),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: child,
    );
  }


  Widget _buildAvailableToSpendCard() {
    return _buildCard(
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 4),
      child: Text(
        title,
        style: AppTypography.bodySmall.copyWith(
          color: const Color(0xFF606060),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection(AppStrings strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(strings.personalInformation),
        _buildSectionContainer(
          child: Column(
            children: [
              _buildStaticRow(strings.fullName, 'Ali Muhajirin'),
              _buildInsetDivider(),
              _buildStaticRow(strings.email, 'helloali@gmail.com'),
              _buildInsetDivider(),
              _buildStaticRow(strings.phone, '+1 (555) 123-4567'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStaticRow(String label, String value) {
    return SizedBox(
      height: _rowHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: _rowFontSize,
                color: const Color(0xFF101010),
                fontFamily: 'Roboto',
              ),
            ),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: _rowFontSize,
                  color: const Color(0xFF606060),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(strings.linkedBankAccounts),
        _buildSectionContainer(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildBankTile(
                  name: 'Emirates NBD Bank',
                  last4: '4567',
                  isPrimary: true,
                  statusLabel: strings.complete,
                ),
                const SizedBox(height: 10),
                _buildBankTile(
                  name: 'Citi Bank',
                  last4: '4567',
                  isPrimary: false,
                  statusLabel: strings.complete,
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.addBankAccount),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    side:
                        const BorderSide(color: Color(0xFFEDEDED)),
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
        ),
      ],
    );
  }

  Widget _buildBankTile({
    required String name,
    required String last4,
    required bool isPrimary,
    required String statusLabel,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF5F5F5)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFF5F5F5)),
            ),
            child: const Center(
              child: Icon(
                PhosphorIconsRegular.buildings,
                size: 20,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.bodyMedium.copyWith(
                    color: const Color(0xFF101010),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '****$last4',
                  style: AppTypography.bodySmall.copyWith(
                    color: const Color(0xFF606060),
                  ),
                ),
              ],
            ),
          ),
          if (isPrimary)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE7FFF8),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFB5EFD3)),
              ),
              child: Text(
                statusLabel,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF21D07A),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(strings.appSettings),
        _buildSectionContainer(
          child: Column(
            children: [
              _buildRow(
                icon: PhosphorIconsRegular.bell,
                label: strings.notifications,
                trailing: const Icon(
                  PhosphorIconsRegular.caretRight,
                  size: 16,
                  color: Color(0xFF878787),
                ),
                onTap: () => context.push(AppRoutes.notifications),
              ),
              _buildInsetDivider(),
              _buildRow(
                icon: PhosphorIconsRegular.lock,
                label: strings.security,
                trailing: const Icon(
                  PhosphorIconsRegular.caretRight,
                  size: 16,
                  color: Color(0xFF878787),
                ),
                onTap: () => context.push(AppRoutes.security),
              ),
              _buildInsetDivider(),
              _buildRow(
                icon: PhosphorIconsRegular.globe,
                label: strings.languageLabel,
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
                onTap: () => _showLanguageSelector(
                  context,
                  ref,
                  strings,
                  currentLanguage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHelpLegalSection(AppStrings strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(strings.helpAndLegal),
        _buildSectionContainer(
          child: Column(
            children: [
              _buildRow(
                icon: PhosphorIconsRegular.question,
                label: strings.faq,
                trailing: const Icon(
                  PhosphorIconsRegular.caretRight,
                  size: 16,
                  color: Color(0xFF878787),
                ),
                onTap: () => context.push(AppRoutes.faq),
              ),
              _buildInsetDivider(),
              _buildRow(
                icon: PhosphorIconsRegular.note,
                label: strings.termsAndConditions,
                trailing: const Icon(
                  PhosphorIconsRegular.caretRight,
                  size: 16,
                  color: Color(0xFF878787),
                ),
                onTap: () => context.push(AppRoutes.termsConditions),
              ),
              _buildInsetDivider(),
              _buildRow(
                icon: PhosphorIconsRegular.shieldCheckered,
                label: strings.privacyPolicy,
                trailing: const Icon(
                  PhosphorIconsRegular.caretRight,
                  size: 16,
                  color: Color(0xFF878787),
                ),
                onTap: () => context.push(AppRoutes.privacyPolicy),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutRow(AppStrings strings) {
    return _buildSectionContainer(
      child: _buildRow(
        icon: PhosphorIconsRegular.signOut,
        label: strings.logout,
        labelColor: const Color(0xFF101010),
        onTap: () {
          context.go(AppRoutes.login);
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: _horizontalInset,
        right: _horizontalInset,
        top: 28,
        bottom: 8,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: _sectionHeaderFontSize,
          fontWeight: FontWeight.w400,
          color: AppColors.textTertiary,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Widget _buildRow({
    IconData? icon,
    required String label,
    Color labelColor = const Color(0xFF101010),
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      height: _rowHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: _horizontalInset),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: _iconSize,
                    color: const Color(0xFF101010),
                  ),
                  const SizedBox(width: _iconTextGap),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: _rowFontSize,
                      fontWeight: FontWeight.w400,
                      color: labelColor,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInsetDivider() {
    return Container(
      margin: const EdgeInsets.only(
        left: _dividerInset,
        right: _dividerInset,
      ),
      height: 0.5,
      color: AppColors.divider,
    );
  }

  Widget _buildSignOutRow(BuildContext context, AppStrings strings) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          context.go(AppRoutes.login);
        },
        child: SizedBox(
          height: _rowHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: _horizontalInset),
            child: Row(
              children: [
                Icon(
                  PhosphorIconsRegular.signOut,
                  size: _iconSize,
                  color: AppColors.accent,
                ),
                const SizedBox(width: _iconTextGap),
                Text(
                  'Sign out',
                  style: TextStyle(
                    fontSize: _rowFontSize,
                    fontWeight: FontWeight.w400,
                    color: AppColors.accent,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageSelector(
    BuildContext context,
    WidgetRef ref,
    AppStrings strings,
    AppLanguage currentLanguage,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFDFCF8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        behavior: HitTestBehavior.opaque,
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: Center(
                            child: Icon(
                              PhosphorIconsRegular.x,
                              size: 18,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        strings.languageLabel,
                        style: TextStyle(
                          fontSize: _titleFontSize,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 56),
                ],
              ),
            ),
            Container(height: 0.5, color: AppColors.divider),
            const SizedBox(height: 8),
            ...AppLanguage.values.asMap().entries.map((entry) {
              final index = entry.key;
              final language = entry.value;
              final isSelected = language == currentLanguage;
              final isLast = index == AppLanguage.values.length - 1;
              
              return Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        ref.read(languageProvider.notifier).setLanguage(language);
                        Navigator.pop(ctx);
                      },
                      child: SizedBox(
                        height: _rowHeight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: _horizontalInset),
                          child: Row(
                            children: [
                              Text(
                                _getLanguageFlag(language),
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: _iconTextGap),
                              Expanded(
                                child: Text(
                                  language.nativeName,
                                  style: TextStyle(
                                    fontSize: _rowFontSize,
                                    color: isSelected ? AppColors.accent : AppColors.textPrimary,
                                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  PhosphorIconsRegular.check,
                                  size: 20,
                                  color: AppColors.accent,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!isLast) _buildInsetDivider(),
                ],
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _getLanguageFlag(AppLanguage language) {
    switch (language) {
      case AppLanguage.uzbekCyrillic:
      case AppLanguage.uzbekLatin:
        return '🇺🇿';
      case AppLanguage.russian:
        return '🇷🇺';
      case AppLanguage.english:
        return '🇬🇧';
    }
  }

  Future<void> _openTelegram() async {
    final url = Uri.parse('https://t.me/lexuz_ai');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
