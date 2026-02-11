import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/localization/app_strings.dart';

class ForgotPasswordEmailScreen extends ConsumerStatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  ConsumerState<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState
    extends ConsumerState<ForgotPasswordEmailScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFilled = _emailController.text.trim().isNotEmpty;
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
                    _buildEmailField(),
                    const SizedBox(height: 24),
                    _buildPrimaryButton(
                      label: strings.resetPassword,
                      enabled: isFilled,
                      onPressed: isFilled
                          ? () {
                              // In a real app, trigger reset-email API then push new password screen.
                              context.push(AppRoutes.resetPassword);
                            }
                          : null,
                    ),
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
            color: Color(0xFF101010),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            hintText: 'Placeholder',
            hintStyle: const TextStyle(
              fontFamily: 'Onest',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF878787),
            ),
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
              borderSide: const BorderSide(color: Color(0xFF101010)),
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
    final bgColor = enabled ? const Color(0xFF101010) : const Color(0xFFEDEDED);
    final textColor =
        enabled ? Colors.white : const Color(0xFFC2C2C2);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          disabledBackgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
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

