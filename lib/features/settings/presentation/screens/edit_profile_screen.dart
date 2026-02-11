import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/localization/app_strings.dart';
import '../../domain/providers/settings_providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    _fullNameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email ?? '');
    _phoneController = TextEditingController(text: profile.phoneNumber);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      // Update profile via provider
      ref.read(userProfileProvider.notifier).updateProfile(
            ref.read(userProfileProvider).copyWith(
                  name: _fullNameController.text.trim(),
                  email: _emailController.text.trim(),
                  phoneNumber: _phoneController.text.trim(),
                ),
          );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
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
                  SpacingTokens.spacing12,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile picture section
                      _buildProfilePictureSection(),
                      SpacingTokens.verticalGap20,
                      // Form fields
                      _buildFormFields(strings),
                    ],
                  ),
                ),
              ),
            ),
            // Save button
            _buildSaveButton(strings),
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
              strings.editProfile,
              style: AppTypography.headline4.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Center(
      child: Column(
        children: [
          Container(
            width: SpacingTokens.spacing88,
            height: SpacingTokens.spacing88,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              PhosphorIconsRegular.user,
              size: SpacingTokens.spacing40,
              color: AppColors.accent,
            ),
          ),
          SpacingTokens.verticalGap12,
          TextButton.icon(
            onPressed: () {
              // Handle avatar upload
            },
            icon: Icon(
              PhosphorIconsRegular.camera,
              size: SpacingTokens.iconSize16,
              color: AppColors.accent,
            ),
            label: Text(
              'Change Photo',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(AppStrings strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: strings.fullName,
          controller: _fullNameController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
        ),
        SpacingTokens.verticalGap16,
        _buildTextField(
          label: strings.email,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        SpacingTokens.verticalGap16,
        _buildTextField(
          label: strings.phone,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        SpacingTokens.verticalGap8,
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.cardBackground,
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
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: SpacingTokens.borderRadius10,
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding: SpacingTokens.padding16,
          ),
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(AppStrings strings) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        SpacingTokens.spacing20,
        SpacingTokens.spacing12,
        SpacingTokens.spacing20,
        SpacingTokens.spacing12 + MediaQuery.of(context).padding.bottom,
      ),
      child: SizedBox(
        width: double.infinity,
        height: SpacingTokens.spacing52,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.textPrimary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.textTertiary.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: SpacingTokens.borderRadius10,
            ),
            elevation: 0,
          ),
          child: _isLoading
              ? SizedBox(
                  height: SpacingTokens.spacing20,
                  width: SpacingTokens.spacing20,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Text(
                  strings.saveChanges,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
