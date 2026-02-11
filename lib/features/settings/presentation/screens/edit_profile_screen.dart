import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/localization/app_strings.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _fullNameController = TextEditingController(text: 'Ali Muhajirin');
  final _emailController = TextEditingController(text: 'helloAli@gmail.com');
  final _phoneController = TextEditingController(text: '+1 (555) 123-4567');
  String? _selectedGender;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _isLoading = true);
    // TODO: Implement save logic
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.m, AppSpacing.xl, AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfilePictureSection(),
                    AppSpacing.gapVerticalS,
                    _buildFormSection(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.m, AppSpacing.xl, AppSpacing.m),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textPrimary,
                    foregroundColor: AppColors.cardBackground,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppSpacing.borderRadiusS,
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: AppSpacing.xl,
                          width: AppSpacing.xl,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(AppColors.cardBackground),
                          ),
                        )
                      : Text(
                          ref.watch(stringsProvider).saveChanges,
                          style: TextStyle(
                            fontFamily: 'Onest',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 1.5,
                            color: AppColors.cardBackground,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
              ref.watch(stringsProvider).editProfile,
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

  Widget _buildProfilePictureSection() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              PhosphorIconsRegular.user,
              size: 50,
              color: AppColors.accent,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.cardBackground, width: 2),
              ),
              child: Icon(
                PhosphorIconsRegular.camera,
                size: AppSpacing.l,
                color: AppColors.cardBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    final strings = ref.watch(stringsProvider);
    return Container(
      padding: AppSpacing.paddingM,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppSpacing.borderRadiusS,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
            label: strings.fullName,
            controller: _fullNameController,
          ),
          AppSpacing.gapVerticalM,
          _buildGenderSelector(),
          AppSpacing.gapVerticalM,
          _buildInputField(
            label: strings.email,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          AppSpacing.gapVerticalM,
          _buildInputField(
            label: strings.phone,
            controller: _phoneController,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    final strings = ref.watch(stringsProvider);
    final isMale = _selectedGender == strings.male;
    final isFemale = _selectedGender == strings.female;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.gender,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.gapVerticalS,
        Row(
          children: [
            Expanded(
              child: _buildGenderButton(strings.male, isMale, () {
                setState(() => _selectedGender = strings.male);
              }),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildGenderButton(strings.female, isFemale, () {
                setState(() => _selectedGender = strings.female);
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.xl),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textPrimary : AppColors.cardBackground,
          borderRadius: AppSpacing.borderRadiusS,
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.cardBackground : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  color: AppColors.error,
                ),
              ),
          ],
        ),
        AppSpacing.gapVerticalS,
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Placeholder',
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            filled: true,
            fillColor: AppColors.cardBackground,
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
              borderSide: BorderSide(color: AppColors.accent, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: AppSpacing.m,
            ),
          ),
        ),
      ],
    );
  }
}
