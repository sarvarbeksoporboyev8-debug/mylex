import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/theme.dart';
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile picture section
                    _buildProfilePictureSection(),
                    const SizedBox(height: 8),
                    // Form section
                    _buildFormSection(),
                  ],
                ),
              ),
            ),
            // Save button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF101010),
                    foregroundColor: Colors.white,
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
                      : Text(
                          ref.watch(stringsProvider).saveChanges,
                          style: const TextStyle(
                            fontFamily: 'Onest',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.white,
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
              ref.watch(stringsProvider).editProfile,
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
              border: Border.all(color: const Color(0xFFEDEDED)),
            ),
            child: const Icon(
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
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                PhosphorIconsRegular.camera,
                size: 16,
                color: Colors.white,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full name
          _buildInputField(
            label: strings.fullName,
            controller: _fullNameController,
          ),
          const SizedBox(height: 12),
          // Gender
          _buildGenderSelector(),
          const SizedBox(height: 12),
          // Email
          _buildInputField(
            label: strings.email,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          // Phone
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
            color: const Color(0xFF101010),
          ),
        ),
        const SizedBox(height: 8),
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF101010) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFEDEDED),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF101010),
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
                color: const Color(0xFF101010),
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Color(0xFFE63946),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: AppTypography.bodyMedium.copyWith(
            color: const Color(0xFF101010),
          ),
          decoration: InputDecoration(
            hintText: 'Placeholder',
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: const Color(0xFF878787),
            ),
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
