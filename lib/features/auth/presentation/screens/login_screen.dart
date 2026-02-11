import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/localization/app_strings.dart';
import '../../domain/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController(text: '+998901234567');
  final _passwordController = TextEditingController(text: 'demo123');
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    
    final success = await ref.read(authProvider.notifier).login(
      _phoneController.text.trim(),
      _passwordController.text,
    );
    
    setState(() => _isLoading = false);
    
    if (success && mounted) {
      context.go(AppRoutes.constitution);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final strings = ref.watch(stringsProvider);

    final isFormFilled =
        _phoneController.text.trim().isNotEmpty && _passwordController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Header
              Text(
                strings.login,
                style: AppTypography.headlineMedium.copyWith(
                  color: const Color(0xFF101010),
                ),
              ),
              const SizedBox(height: 4),
              // Keeping subtitle in English for now; main labels/buttons are localized.
              const SizedBox(height: 28),

              // Email / phone field
              Text(
                'Email',
                style: AppTypography.labelMedium.copyWith(
                  color: const Color(0xFF101010),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter email address',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFEDEDED)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFEDEDED)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.accent, width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
                style: AppTypography.bodyMedium.copyWith(
                  color: const Color(0xFF101010),
                ),
              ),

              const SizedBox(height: 20),

              // Password label row with "Forgot password?"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    strings.password,
                    style: AppTypography.labelMedium.copyWith(
                      color: const Color(0xFF101010),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push(AppRoutes.forgotPassword);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      strings.forgotPassword,
                      style: AppTypography.bodySmall.copyWith(
                        color: const Color(0xFF606060),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: strings.enterPassword,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFEDEDED)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFEDEDED)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.accent, width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFF606060),
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                style: AppTypography.bodyMedium.copyWith(
                  color: const Color(0xFF101010),
                ),
              ),

              const SizedBox(height: 16),

              // Error message (single general line below fields)
              if (authState.errorMessage != null) ...[
                Text(
                  authState.errorMessage!,
                  style: AppTypography.bodySmall.copyWith(
                    color: const Color(0xFFE63946),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _isLoading || !isFormFilled ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFormFilled ? const Color(0xFF101010) : const Color(0xFFEDEDED),
                    foregroundColor:
                        isFormFilled ? Colors.white : const Color(0xFFC2C2C2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(strings.continueLabel),
                ),
              ),

              const SizedBox(height: 16),

              // Divider with "Or"
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: const Color(0xFFEDEDED),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    strings.orLabel,
                    style: AppTypography.bodyMedium.copyWith(
                      color: const Color(0xFF606060),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: const Color(0xFFEDEDED),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Social buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(color: Color(0xFFEDEDED)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.g_mobiledata, size: 20),
                          const SizedBox(width: 8),
                  Text(
                    'Google',
                            style: AppTypography.bodyMedium.copyWith(
                              color: const Color(0xFF101010),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(color: Color(0xFFEDEDED)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.apple, size: 20),
                          const SizedBox(width: 8),
                  Text(
                    'Apple',
                            style: AppTypography.bodyMedium.copyWith(
                              color: const Color(0xFF101010),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

                    // Sign up prompt
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${strings.noAccount} ',
                          style: AppTypography.bodySmall.copyWith(
                            color: const Color(0xFF101010),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.signup),
                          child: Text(
                            strings.signup,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Terms & Privacy pinned near bottom
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTypography.labelMedium.copyWith(
        fontFamily: 'Roboto',
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: AppTypography.bodyMedium.copyWith(fontFamily: 'Roboto'),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodyMedium.copyWith(
          fontFamily: 'Roboto',
          color: AppColors.textTertiary,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.textTertiary)
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.accent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
