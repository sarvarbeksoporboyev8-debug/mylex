import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/localization/app_language.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../auth/domain/auth_state.dart';
import '../../domain/models/settings_models.dart';
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
      if (mounted) {
        setState(() => _appVersion = info.version);
      }
    } catch (_) {
      // Ignore errors loading app info
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);
    final currentLanguage = ref.watch(languageProvider);
    final userProfile = ref.watch(userProfileProvider);
    final creditCards = ref.watch(creditCardsProvider);

    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: CustomScrollView(
        slivers: [
          // Pinned profile header
          SliverAppBar(
            pinned: true,
            toolbarHeight: SpacingTokens.spacing88,
            backgroundColor: AppColors.cardBackground,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            flexibleSpace: SafeArea(
              bottom: false,
              child: ProfileHeader(
                profile: userProfile,
                onBackTap: () => context.pop(),
                onEditTap: () => context.push(AppRoutes.editProfile),
                editButtonLabel: strings.edit,
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
          // Content sections
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              SpacingTokens.spacing20,
              SpacingTokens.spacing16,
              SpacingTokens.spacing20,
              0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildPersonalInfoSection(strings, userProfile),
                SpacingTokens.verticalGap12,
                _buildLinkedBanksSection(strings, creditCards),
                SpacingTokens.verticalGap12,
                _buildAppSettingsSection(strings, currentLanguage),
                SpacingTokens.verticalGap12,
                _buildHelpLegalSection(strings),
                SpacingTokens.verticalGap24,
                _buildLogoutSection(strings),
                SpacingTokens.verticalGap16,
                Center(
                  child: Text(
                    'v$_appVersion',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
                SizedBox(height: bottomPadding + SpacingTokens.spacing32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(AppStrings strings, UserProfileModel profile) {
    return SettingsSection(
      title: strings.personalInformation,
      children: [
        _buildInfoRow(strings.fullName, profile.name),
        _buildInfoRow(strings.email, profile.email ?? 'Not set'),
        _buildInfoRow(strings.phone, profile.phoneNumber),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing20,
        vertical: SpacingTokens.spacing12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkedBanksSection(AppStrings strings, List<CreditCardModel> cards) {
    return SettingsSection(
      title: strings.linkedBankAccounts,
      children: [
        ...cards.map((card) => BankCard(
              card: card,
              onTap: () {
                // Navigate to card details
              },
            )),
        SettingsMenuItem(
          icon: PhosphorIconsRegular.plus,
          title: strings.addBankAccount,
          iconColor: AppColors.accent,
          showChevron: false,
          onTap: () => context.push(AppRoutes.addBankAccount),
        ),
      ],
    );
  }

  Widget _buildAppSettingsSection(AppStrings strings, AppLanguage currentLanguage) {
    return SettingsSection(
      title: strings.appSettings,
      children: [
        SettingsMenuItem(
          icon: PhosphorIconsRegular.bell,
          title: strings.notifications,
          onTap: () => context.push(AppRoutes.notifications),
        ),
        SettingsMenuItem(
          icon: PhosphorIconsRegular.lock,
          title: strings.security,
          onTap: () => context.push(AppRoutes.security),
        ),
        SettingsMenuItem(
          icon: PhosphorIconsRegular.globe,
          title: strings.languageLabel,
          trailing: Text(
            currentLanguage.nativeName,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          onTap: () => _showLanguageSelector(context, currentLanguage, strings),
        ),
      ],
    );
  }

  Widget _buildHelpLegalSection(AppStrings strings) {
    return SettingsSection(
      title: strings.helpAndLegal,
      children: [
        SettingsMenuItem(
          icon: PhosphorIconsRegular.question,
          title: strings.faq,
          onTap: () => context.push(AppRoutes.faq),
        ),
        SettingsMenuItem(
          icon: PhosphorIconsRegular.note,
          title: strings.termsAndConditions,
          onTap: () => context.push(AppRoutes.termsConditions),
        ),
        SettingsMenuItem(
          icon: PhosphorIconsRegular.shieldCheckered,
          title: strings.privacyPolicy,
          onTap: () => context.push(AppRoutes.privacyPolicy),
        ),
      ],
    );
  }

  Widget _buildLogoutSection(AppStrings strings) {
    return SettingsSection(
      children: [
        SettingsMenuItem(
          icon: PhosphorIconsRegular.signOut,
          title: strings.logout,
          showChevron: false,
          onTap: () {
            ref.read(authStateProvider.notifier).logout();
            context.go(AppRoutes.login);
          },
        ),
      ],
    );
  }

  void _showLanguageSelector(BuildContext context, AppLanguage currentLanguage, AppStrings strings) {
    LanguageSelectorModal.show(
      context,
      currentLanguage: currentLanguage.code,
      languages: const [
        LanguageOption(
          code: 'en',
          name: 'English',
          nativeName: 'English',
          flag: '🇺🇸',
        ),
        LanguageOption(
          code: 'ru',
          name: 'Russian',
          nativeName: 'Русский',
          flag: '🇷🇺',
        ),
        LanguageOption(
          code: 'uz',
          name: 'Uzbek',
          nativeName: 'O\'zbekcha',
          flag: '🇺🇿',
        ),
        LanguageOption(
          code: 'uz-Cyrl',
          name: 'Uzbek (Cyrillic)',
          nativeName: 'Ўзбекча',
          flag: '🇺🇿',
        ),
      ],
      onLanguageSelected: (code) {
        ref.read(languageProvider.notifier).setLanguage(AppLanguage.fromCode(code));
      },
    );
  }
}
