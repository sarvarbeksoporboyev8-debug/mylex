import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Glass-styled text field with blur effect
class GlassTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? minLines;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool enabled;
  final bool readOnly;

  const GlassTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppSpacing.borderRadiusM,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          onTap: onTap,
          validator: validator,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          minLines: minLines,
          autofocus: autofocus,
          focusNode: focusNode,
          enabled: enabled,
          readOnly: readOnly,
          style: AppTypography.bodyLarge,
          cursorColor: AppColors.gold,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.textSecondary)
                : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.glassFill,
            border: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusM,
              borderSide: const BorderSide(color: AppColors.glassBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusM,
              borderSide: const BorderSide(color: AppColors.glassBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusM,
              borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusM,
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusM,
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusM,
              borderSide: BorderSide(color: AppColors.glassBorder.withOpacity(0.5)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
            labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            errorStyle: AppTypography.caption.copyWith(color: AppColors.error),
          ),
        ),
      ),
    );
  }
}

/// Search field with glass styling
class GlassSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final FocusNode? focusNode;

  const GlassSearchField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppSpacing.borderRadiusFull,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.glassFill,
            borderRadius: AppSpacing.borderRadiusFull,
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            autofocus: autofocus,
            focusNode: focusNode,
            style: AppTypography.bodyMedium,
            cursorColor: AppColors.gold,
            decoration: InputDecoration(
              hintText: hintText ?? 'Qidirish...',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.textSecondary,
                size: 22,
              ),
              suffixIcon: controller?.text.isNotEmpty == true
                  ? IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () {
                        controller?.clear();
                        onClear?.call();
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
