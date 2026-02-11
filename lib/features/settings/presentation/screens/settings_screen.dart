import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/localization/app_language.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/routing/app_routes.dart';
import '../../domain/providers/settings_providers.dart';
import '../../domain/models/settings_models.dart';
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
    final settingsState = ref.watch(settingsProvider);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: settingsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : settingsState.isError
              ? _buildErrorState(strings, settingsState.errorMessage)
              : CustomScrollView(
                  slivers: [
                    _buildAppBar(context, strings, settingsState.profile),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        SpacingTokens.spacing20,
                        SpacingTokens.spacing16,
                        SpacingTokens.spacing20,
                        bottomPadding + SpacingTokens.spacing32,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildCreditOverview(strings),
                          SpacingTokens.gapV12,
                          _buildPersonalInfoSection(strings, settingsState.profile),
                          SpacingTokens.gapV12,
                          _buildLinkedBanksSection(strings),
                          SpacingTokens.gapV12,
                          _buildAppSettingsSection(strings, currentLanguage),
                          SpacingTokens.gapV12,
                          _buildHelpLegalSection(strings),
                          SpacingTokens.gapV24,
                          _buildLogoutButton(strings),
                          SpacingTokens.gapV16,
                          _buildVersionText(),
                        ]),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildErrorState(AppStrings strings, String? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            PhosphorIconsRegular.warningCircle,
            size: SpacingTokens.spacing60,
            color: Color(0xFF606060),
          ),
          SpacingTokens.gapV16,
          Text(
            error ?? strings.errorOccurred,
            style: AppTypography.bodyMedium.copyWith(
              color: const Color(0xFF606060),
            ),
            textAlign: TextAlign.center,
          ),
          SpacingTokens.gapV24,
          ElevatedButton(
            onPressed: () => ref.read(settingsProvider.notifier).refresh(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, AppStrings strings, UserProfile? profile) {
    return SliverAppBar(
      pinned: true,
      toolbarHeight: SpacingTokens.spacing88,
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        bottom: false,
        child: _buildPinnedHeader(context, strings, profile),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(0.5),
        child: Divider(height: 0.5, thickness: 0.5, color: Color(0xFFEDEDED)),
      ),
    );
  }

  Widget _buildPinnedHeader(BuildContext context, AppStrings strings, UserProfile? profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing20,
        vertical: SpacingTokens.spacing8,
      ),
      child: Row(
        children: [
          _buildBackButton(context),
          SpacingTokens.gapH8,
          _buildAvatar(),
          SpacingTokens.gapH8,
          Expanded(
            child: _buildProfileInfo(profile),
          ),
          _buildEditButton(strings),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
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
          size: SpacingTokens.spacing20,
          color: Color(0xFF101010),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: SpacingTokens.spacing44,
      height: SpacingTokens.spacing44,
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.08),
        borderRadius: SpacingTokens.borderRadius32,
      ),
      child: const Icon(
        PhosphorIconsRegular.user,
        color: AppColors.accent,
      ),
    );
  }

  Widget _buildProfileInfo(UserProfile? profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          profile?.name ?? 'User',
          style: AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF101010),
          ),
        ),
        SpacingTokens.gapV2,
        Text(
          profile?.phone ?? profile?.email ?? '',
          style: AppTypography.bodySmall.copyWith(
            color: const Color(0xFF606060),
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton(AppStrings strings) {
    return OutlinedButton.icon(
      onPressed: () => context.push(AppRoutes.editProfile),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, SpacingTokens.spacing32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.spacing12,
          vertical: SpacingTokens.spacing6,
        ),
        visualDensity: VisualDensity.compact,
        side: const BorderSide(color: Color(0xFFEDEDED)),
        shape: RoundedRectangleBorder(
          borderRadius: SpacingTokens.borderRadius8,
        ),
      ),
      icon: const Icon(
        PhosphorIconsRegular.pencilSimple,
        size: SpacingTokens.spacing16,
        color: Color(0xFF101010),
      ),
      label: Text(
        strings.edit,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF101010),
        ),
      ),
    );
  }

  Widget _buildCreditOverview(AppStrings strings) {
    final primaryCard = ref.watch(primaryCardProvider);
    final utilization = ref.watch(creditUtilizationRatioProvider);
    
    if (primaryCard == null) return const SizedBox.shrink();

    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    
    return Container(
      padding: SpacingTokens.padding12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: SpacingTokens.borderRadius14,
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Available to Spend',
            style: AppTypography.bodyMedium.copyWith(
              color: const Color(0xFF101010),
            ),
          ),
          SpacingTokens.gapV12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${currencyFormat.format(primaryCard.usedAmount)} used',
                style: AppTypography.bodySmall.copyWith(
                  color: const Color(0xFF606060),
                ),
              ),
              Text(
                '${currencyFormat.format(primaryCard.availableCredit)} available',
                style: AppTypography.bodySmall.copyWith(
                  color: const Color(0xFF606060),
                ),
              ),
            ],
          ),
          SpacingTokens.gapV6,
          ClipRRect(
            borderRadius: SpacingTokens.borderRadius12,
            child: SizedBox(
              height: SpacingTokens.spacing7,
              child: Stack(
                children: [
                  Container(color: const Color(0xFFEDEDED)),
                  FractionallySizedBox(
                    widthFactor: utilization.clamp(0.0, 1.0),
                    alignment: Alignment.centerLeft,
                    child: Container(color: AppColors.accent),
                  ),
                ],
              ),
            ),
          ),
          SpacingTokens.gapV12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Repay before ${DateFormat('d MMM yyyy').format(primaryCard.repaymentDate)}',
                      style: AppTypography.bodySmall.copyWith(
                        color: const Color(0xFF606060),
                      ),
                    ),
                    SpacingTokens.gapV2,
                    Text(
                      currencyFormat.format(primaryCard.nextPaymentAmount),
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF101010),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF101010),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpacingTokens.spacing16,
                    vertical: SpacingTokens.spacing6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: SpacingTokens.borderRadius8,
                  ),
                  elevation: 0,
                ),
                child: const Text('Repay', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(AppStrings strings, UserProfile? profile) {
    if (profile == null) return const SizedBox.shrink();
    
    return SettingsSection(
      title: strings.personalInformation,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildInfoRow(strings.fullName, profile.name),
          _buildDivider(),
          _buildInfoRow(strings.email, profile.email),
          if (profile.phone != null) ...[
            _buildDivider(),
            _buildInfoRow(strings.phone, profile.phone!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return SizedBox(
      height: SpacingTokens.spacing52,
      child: Padding(
        padding: SpacingTokens.paddingHorizontal12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF101010),
                fontFamily: 'Roboto',
              ),
            ),
            Flexible(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
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
    final cards = ref.watch(settingsProvider.select((s) => s.cards));
    
    return SettingsSection(
      title: strings.linkedBankAccounts,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...cards.map((card) => Padding(
            padding: const EdgeInsets.only(bottom: SpacingTokens.spacing10),
            child: CompactBankCard(card: card),
          )),
          if (cards.isNotEmpty) SpacingTokens.gapV4,
          OutlinedButton.icon(
            onPressed: () => context.push(AppRoutes.addBankAccount),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.spacing16,
                vertical: SpacingTokens.spacing6,
              ),
              side: const BorderSide(color: Color(0xFFEDEDED)),
              shape: RoundedRectangleBorder(
                borderRadius: SpacingTokens.borderRadius8,
              ),
            ),
            icon: const Icon(
              PhosphorIconsRegular.plus,
              size: SpacingTokens.spacing16,
              color: Color(0xFF101010),
            ),
            label: Text(
              strings.addBankAccount,
              style: const TextStyle(fontSize: 12, color: Color(0xFF101010)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsSection(AppStrings strings, AppLanguage currentLanguage) {
    return SettingsSection(
      title: strings.appSettings,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuItem(
            icon: PhosphorIconsRegular.bell,
            label: strings.notifications,
            onTap: () => context.push(AppRoutes.notifications),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: PhosphorIconsRegular.lock,
            label: strings.security,
            onTap: () => context.push(AppRoutes.security),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: PhosphorIconsRegular.globe,
            label: strings.languageLabel,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentLanguage.nativeName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF606060),
                    fontFamily: 'Roboto',
                  ),
                ),
                SpacingTokens.gapH4,
                const Icon(
                  PhosphorIconsRegular.caretRight,
                  size: SpacingTokens.spacing16,
                  color: Color(0xFF878787),
                ),
              ],
            ),
            onTap: () => LanguageSelectorModal.show(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpLegalSection(AppStrings strings) {
    return SettingsSection(
      title: strings.helpAndLegal,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuItem(
            icon: PhosphorIconsRegular.question,
            label: strings.faq,
            onTap: () => context.push(AppRoutes.faq),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: PhosphorIconsRegular.note,
            label: strings.termsAndConditions,
            onTap: () => context.push(AppRoutes.termsConditions),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: PhosphorIconsRegular.shieldCheckered,
            label: strings.privacyPolicy,
            onTap: () => context.push(AppRoutes.privacyPolicy),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      height: SpacingTokens.spacing52,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: SpacingTokens.paddingHorizontal20,
            child: Row(
              children: [
                Icon(
                  icon,
                  size: SpacingTokens.spacing20,
                  color: const Color(0xFF101010),
                ),
                SpacingTokens.gapH8,
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF101010),
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                if (trailing != null)
                  trailing
                else
                  const Icon(
                    PhosphorIconsRegular.caretRight,
                    size: SpacingTokens.spacing16,
                    color: Color(0xFF878787),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(AppStrings strings) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: SpacingTokens.borderRadius12,
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: _buildMenuItem(
        icon: PhosphorIconsRegular.signOut,
        label: strings.logout,
        trailing: null,
        onTap: () => context.go(AppRoutes.login),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: SpacingTokens.spacing16),
      height: 0.5,
      color: AppColors.divider,
    );
  }

  Widget _buildVersionText() {
    return Center(
      child: Text(
        'v$_appVersion',
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
