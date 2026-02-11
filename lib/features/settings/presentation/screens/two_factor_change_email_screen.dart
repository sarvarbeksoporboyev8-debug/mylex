import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/theme/spacing_tokens.dart';

class TwoFactorChangeEmailScreen extends ConsumerStatefulWidget {
  const TwoFactorChangeEmailScreen({super.key});

  @override
  ConsumerState<TwoFactorChangeEmailScreen> createState() =>
      _TwoFactorChangeEmailScreenState();
}

class _TwoFactorChangeEmailScreenState
    extends ConsumerState<TwoFactorChangeEmailScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);
    final isFilled = _emailController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.cardBackground,
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
                  SpacingTokens.spacing12,
                  SpacingTokens.spacing20,
                  SpacingTokens.spacing24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpacingTokens.verticalGap12,
                      _buildEmailField(strings),
                      SpacingTokens.verticalGap24,
                      _buildSubmitButton(strings, isFilled),
                    ],
                  ),
                ),
              ),
            ),
            // Terms text at bottom
            _buildTermsText(context, strings),
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
              strings.changeEmail,
              style: AppTypography.headline4.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(AppStrings strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.email,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        SpacingTokens.verticalGap8,
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter your new email',
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            filled: true,
            fillColor: AppColors.backgroundSecondary,
            border: OutlineInputBorder(
              borderRadius: SpacingTokens.borderRadius10,
              borderSide: const BorderSide(color: Color(0xFFEDEDED)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: SpacingTokens.borderRadius10,
              borderSide: const BorderSide(color: Color(0xFFEDEDED)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: SpacingTokens.borderRadius10,
              borderSide: BorderSide(color: AppColors.accent, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: SpacingTokens.borderRadius10,
              borderSide: BorderSide(color: AppColors.error),
            ),
            contentPadding: SpacingTokens.padding16,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter an email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(AppStrings strings, bool enabled) {
    return SizedBox(
      width: double.infinity,
      height: SpacingTokens.spacing52,
      child: ElevatedButton(
        onPressed: enabled && !_isLoading
            ? () async {
                if (_formKey.currentState?.validate() ?? false) {
                  setState(() => _isLoading = true);
                  // Simulate API call
                  await Future.delayed(const Duration(seconds: 2));
                  if (mounted) {
                    setState(() => _isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Email changed successfully'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    context.pop();
                  }
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.textTertiary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: SpacingTokens.borderRadius10,
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? SizedBox(
                width: SpacingTokens.spacing20,
                height: SpacingTokens.spacing20,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                strings.changeEmail,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildTermsText(BuildContext context, AppStrings strings) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        SpacingTokens.spacing20,
        0,
        SpacingTokens.spacing20,
        SpacingTokens.spacing16 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            strings.byContinuingAgree,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SpacingTokens.verticalGap2,
          GestureDetector(
            onTap: () {
              // Navigate to terms and privacy
            },
            child: Text(
              strings.termsAndPrivacyPolicy,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
