import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/localization/app_strings.dart';

class ForgotPasswordNewPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordNewPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordNewPasswordScreen> createState() =>
      _ForgotPasswordNewPasswordScreenState();
}

class _ForgotPasswordNewPasswordScreenState
    extends ConsumerState<ForgotPasswordNewPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isValid {
    final p1 = _newPasswordController.text;
    final p2 = _confirmPasswordController.text;
    if (p1.length < 8 || p1 != p2) return false;
    final hasUpper = p1.contains(RegExp(r'[A-Z]'));
    final hasLower = p1.contains(RegExp(r'[a-z]'));
    final hasDigit = p1.contains(RegExp(r'[0-9]'));
    final hasSpecial = p1.contains(RegExp(r'[!@#\$%^&*_\?>/~]'));
    return hasUpper && hasLower && hasDigit && hasSpecial;
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _isValid;
    final strings = ref.watch(stringsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // New password
                    Text(
                      'New Password',
                      style: AppTypography.labelMedium.copyWith(
                        color: const Color(0xFF101010),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _newPasswordController,
                      obscureText: true,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Enter new password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFFEDEDED)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFFEDEDED)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppColors.accent,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        suffixIcon: const Icon(
                          Icons.visibility_outlined,
                          color: Color(0xFF606060),
                        ),
                      ),
                      style: AppTypography.bodyMedium.copyWith(
                        color: const Color(0xFF101010),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Confirm password
                    Text(
                      'Confirm Password',
                      style: AppTypography.labelMedium.copyWith(
                        color: const Color(0xFF101010),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Confirm new password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFFEDEDED)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFFEDEDED)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppColors.accent,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        suffixIcon: const Icon(
                          Icons.visibility_outlined,
                          color: Color(0xFF606060),
                        ),
                      ),
                      style: AppTypography.bodyMedium.copyWith(
                        color: const Color(0xFF101010),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Change Password button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isValid
                            ? () {
                                // In a real app, call change-password API then go back to login.
                                context.go(AppRoutes.login);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isValid
                              ? const Color(0xFF101010)
                              : const Color(0xFFEDEDED),
                          foregroundColor: isValid
                              ? Colors.white
                              : const Color(0xFFC2C2C2),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          ref.watch(stringsProvider).changePassword,
                          style: TextStyle(
                            fontFamily: 'Onest',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 1.5,
                            color: isValid
                                ? Colors.white
                                : const Color(0xFFC2C2C2),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Requirements copy
                    Text(
                      'Password must be at least 8 character and should include:',
                      style: AppTypography.bodySmall.copyWith(
                        color: const Color(0xFF606060),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _RequirementBullet('1 uppercase Letter (A–Z)'),
                    _RequirementBullet('1 lowercase letter (a–z)'),
                    _RequirementBullet('1 number (1–9)'),
                    _RequirementBullet(
                        '1 special character (!@#\$%^&*_>?/~)'),
                  ],
                ),
              ),
            ),

            // Terms & Privacy at bottom
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                0,
                20,
                16 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    strings.byContinuingAgree,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Onest',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF606060),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    strings.termsAndPrivacyPolicy,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Onest',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF606060),
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
            ),
            Text(
              ref.watch(stringsProvider).resetPassword,
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
}

class _RequirementBullet extends StatelessWidget {
  final String text;

  const _RequirementBullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Icon(
              Icons.circle,
              size: 6,
              color: Color(0xFFD6D6D6),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(
                color: const Color(0xFF606060),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

