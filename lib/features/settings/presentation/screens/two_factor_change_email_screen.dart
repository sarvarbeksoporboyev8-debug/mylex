import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_strings.dart';

class TwoFactorChangeEmailScreen extends ConsumerStatefulWidget {
  const TwoFactorChangeEmailScreen({super.key});

  @override
  ConsumerState<TwoFactorChangeEmailScreen> createState() =>
      _TwoFactorChangeEmailScreenState();
}

class _TwoFactorChangeEmailScreenState
    extends ConsumerState<TwoFactorChangeEmailScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFilled = _emailController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.m, AppSpacing.xl, AppSpacing.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.gapVerticalM,
                    _buildEmailField(),
                    AppSpacing.gapVerticalXl,
                    _buildPrimaryButton(
                      label: ref.watch(stringsProvider).changeEmail,
                      enabled: isFilled,
                      onPressed: isFilled ? () {} : null,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.xl,
                0,
                AppSpacing.xl,
                AppSpacing.l + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ref.watch(stringsProvider).byContinuingAgree,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Onest',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ref.watch(stringsProvider).termsAndPrivacyPolicy,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Onest',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
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
        padding: AppSpacing.screenPaddingHorizontal,
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
                    border: Border.all(color: AppColors.border),
                    borderRadius: AppSpacing.borderRadiusS,
                    color: AppColors.cardBackground,
                  ),
                  child: Icon(
                    PhosphorIconsRegular.caretLeft,
                    size: AppSpacing.xl,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            Text(
              ref.watch(stringsProvider).changeEmail,
              style: const TextStyle(
                fontFamily: 'Onest',
                fontWeight: FontWeight.w500,
                fontSize: 18,
                height: 1.5,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ref.watch(stringsProvider).email,
          style: const TextStyle(
            fontFamily: 'Onest',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.5,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.gapVerticalS,
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: AppSpacing.m),
            hintText: 'Placeholder',
            hintStyle: const TextStyle(
              fontFamily: 'Onest',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              height: 1.5,
              color: AppColors.textTertiary,
            ),
            border: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusS,
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusS,
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusS,
              borderSide: BorderSide(color: AppColors.textPrimary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required bool enabled,
    VoidCallback? onPressed,
  }) {
    final bgColor = enabled ? AppColors.textPrimary : AppColors.border;
    final textColor = enabled ? AppColors.cardBackground : AppColors.textTertiary;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          disabledBackgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusS,
          ),
          elevation: enabled ? 0 : 0,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Onest',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            height: 1.5,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

