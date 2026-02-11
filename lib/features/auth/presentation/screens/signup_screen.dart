import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/localization/app_strings.dart';
import '../../domain/auth_state.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parollar mos kelmadi')),
      );
      return;
    }
    
    if (!_agreeToTerms) {
      return;
    }
    
    setState(() => _isLoading = true);
    
    final success = await ref.read(authProvider.notifier).signup(
      _usernameController.text.trim(),
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
        _usernameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _agreeToTerms;
    
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
                      strings.signup,
                      style: AppTypography.headlineMedium.copyWith(
                        color: const Color(0xFF101010),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      strings.joinUsFillDetails,
                      style: AppTypography.bodyMedium.copyWith(
                        color: const Color(0xFF606060),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Username
                    _buildRequiredLabel(strings.yourName),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _usernameController,
                      hint: strings.enterName,
                    ),

                    const SizedBox(height: 16),

                    // Email
                    _buildRequiredLabel(strings.email),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _emailController,
                      hint: strings.enterEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 16),

                    // Phone number
                    _buildRequiredLabel(strings.phoneNumber),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _phoneController,
                      hint: strings.enterPhoneNumber,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 16),

                    // Password
                    _buildRequiredLabel(strings.password),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _passwordController,
                      hint: strings.createPassword,
                      obscureText: _obscurePassword,
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

                    const SizedBox(height: 16),

                    // Confirm password
                    _buildRequiredLabel(strings.confirmPassword),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _confirmPasswordController,
                      hint: strings.reenterPassword,
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF606060),
                        ),
                        onPressed: () => setState(
                          () => _obscureConfirmPassword = !_obscureConfirmPassword,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Terms checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreeToTerms = value ?? false;
                            });
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: const BorderSide(color: Color(0xFFD6D6D6)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            strings.agreeTermsAndPrivacy,
                            style: AppTypography.bodySmall.copyWith(
                              color: const Color(0xFF878787),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Error message (single line)
                    if (authState.errorMessage != null) ...[
                      Text(
                        authState.errorMessage!,
                        style: AppTypography.bodySmall.copyWith(
                          color: const Color(0xFFE63946),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Create account button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading || !isFormFilled
                            ? null
                            : _handleSignup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFormFilled
                              ? const Color(0xFF101010)
                              : const Color(0xFFEDEDED),
                          foregroundColor: isFormFilled
                              ? Colors.white
                              : const Color(0xFFC2C2C2),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
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
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                            : Text(strings.createNewAccount),
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: const BorderSide(
                                  color: Color(0xFFEDEDED)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.g_mobiledata, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Google',
                                  style:
                                      AppTypography.bodyMedium.copyWith(
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: const BorderSide(
                                  color: Color(0xFFEDEDED)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.apple, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Apple',
                                  style:
                                      AppTypography.bodyMedium.copyWith(
                                    color: const Color(0xFF101010),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Login prompt
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          strings.haveAccount + ' ',
                          style: AppTypography.bodySmall.copyWith(
                            color: const Color(0xFF101010),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.login),
                          child: Text(
                            strings.login,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildRequiredLabel(String text) {
    return RichText(
      text: TextSpan(
        text: text,
        style: AppTypography.labelMedium.copyWith(
          color: const Color(0xFF101010),
        ),
        children: [
          TextSpan(
            text: ' *',
            style: AppTypography.labelMedium.copyWith(
              color: const Color(0xFFE63946),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: AppTypography.bodyMedium.copyWith(
        color: const Color(0xFF101010),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: const Color(0xFF878787),
        ),
        suffixIcon: suffixIcon,
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
    );
  }
}
