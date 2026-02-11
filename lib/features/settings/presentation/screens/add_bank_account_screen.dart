import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/localization/app_strings.dart';

class AddBankAccountScreen extends ConsumerStatefulWidget {
  const AddBankAccountScreen({super.key});

  @override
  ConsumerState<AddBankAccountScreen> createState() =>
      _AddBankAccountScreenState();
}

class _AddBankAccountScreenState
    extends ConsumerState<AddBankAccountScreen> {
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  String? _selectedBank;
  bool _isDropdownOpen = false;
  bool _setAsPrimary = false;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  final List<BankOption> _banks = [
    BankOption(
      name: 'Dubai Islamic Bank',
      icon: PhosphorIconsRegular.buildings,
    ),
    BankOption(
      name: 'Emirates NBD Bank',
      icon: PhosphorIconsRegular.buildings,
    ),
    BankOption(
      name: 'Citi Bank',
      icon: PhosphorIconsRegular.buildings,
    ),
  ];

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _selectedBank != null &&
        _accountNameController.text.trim().isNotEmpty &&
        _accountNumberController.text.trim().isNotEmpty &&
        _agreeToTerms;
  }

  Future<void> _handleAddBank() async {
    if (!_isFormValid) return;

    setState(() => _isLoading = true);
    // TODO: Implement add bank logic
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
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormSection(),
                    AppSpacing.gapVerticalM,
                    _buildTermsSection(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.m, AppSpacing.xl, AppSpacing.m),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isFormValid && !_isLoading ? _handleAddBank : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid
                        ? AppColors.textPrimary
                        : AppColors.border,
                    foregroundColor: _isFormValid
                        ? AppColors.cardBackground
                        : AppColors.textTertiary,
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
                          ref.watch(stringsProvider).addBankAccount,
                          style: TextStyle(
                            fontFamily: 'Onest',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 1.5,
                            color: _isFormValid
                                ? AppColors.cardBackground
                                : AppColors.textTertiary,
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
              ref.watch(stringsProvider).addBankAccount,
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
          _buildBankNameField(),
          AppSpacing.gapVerticalM,
          _buildInputField(
            label: strings.accountName,
            controller: _accountNameController,
            isRequired: true,
          ),
          AppSpacing.gapVerticalM,
          _buildInputField(
            label: strings.accountNumber,
            controller: _accountNumberController,
            keyboardType: TextInputType.number,
            isRequired: true,
          ),
          AppSpacing.gapVerticalM,
          _buildPrimaryCheckbox(),
        ],
      ),
    );
  }

  Widget _buildBankNameField() {
    final strings = ref.watch(stringsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              strings.bankName,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              ' *',
              style: TextStyle(color: AppColors.error),
            ),
          ],
        ),
        AppSpacing.gapVerticalS,
        GestureDetector(
          onTap: () {
            setState(() => _isDropdownOpen = !_isDropdownOpen);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: AppSpacing.m),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: AppSpacing.borderRadiusS,
              border: Border.all(color: AppColors.border),
            ),
            child: _selectedBank == null
                ? Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Placeholder',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                      Icon(
                        _isDropdownOpen
                            ? PhosphorIconsRegular.caretUp
                            : PhosphorIconsRegular.caretDown,
                        size: AppSpacing.xl,
                        color: AppColors.textTertiary,
                      ),
                    ],
                  )
                : _buildSelectedBankOption(_selectedBank!),
          ),
        ),
        if (_isDropdownOpen) ...[
          const SizedBox(height: 6),
          _buildBankDropdown(),
        ],
      ],
    );
  }

  Widget _buildSelectedBankOption(String bankName) {
    final bank = _banks.firstWhere((b) => b.name == bankName);
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: AppSpacing.borderRadiusS,
            border: Border.all(color: AppColors.backgroundSecondary),
          ),
          child: Icon(
            bank.icon,
            size: AppSpacing.xl,
            color: AppColors.accent,
          ),
        ),
        AppSpacing.gapHorizontalM,
        Expanded(
          child: Text(
            bankName,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Icon(
          PhosphorIconsRegular.checkCircle,
          size: 32,
          color: AppColors.success,
        ),
      ],
    );
  }

  Widget _buildBankDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppSpacing.borderRadiusS,
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: AppSpacing.sm,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _banks.map((bank) {
          final isSelected = _selectedBank == bank.name;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedBank = bank.name;
                _isDropdownOpen = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: AppSpacing.borderRadiusS,
              ),
              child: Row(
                children: [
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: AppSpacing.borderRadiusS,
                      border: Border.all(color: AppColors.backgroundSecondary),
                    ),
                    child: Icon(
                      bank.icon,
                      size: AppSpacing.xl,
                      color: AppColors.accent,
                    ),
                  ),
                  AppSpacing.gapHorizontalM,
                  Expanded(
                    child: Text(
                      bank.name,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    width: AppSpacing.xl,
                    height: AppSpacing.xl,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.success
                            : AppColors.border,
                        width: isSelected ? 1.667 : 1,
                      ),
                      color: isSelected
                          ? AppColors.success
                          : AppColors.cardBackground,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            size: AppSpacing.m,
                            color: AppColors.cardBackground,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
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
                style: TextStyle(color: AppColors.error),
              ),
          ],
        ),
        AppSpacing.gapVerticalS,
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: (_) => setState(() {}),
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

  Widget _buildPrimaryCheckbox() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => setState(() => _setAsPrimary = !_setAsPrimary),
          child: Container(
            width: AppSpacing.xl,
            height: AppSpacing.xl,
            decoration: BoxDecoration(
              color: _setAsPrimary
                  ? AppColors.textPrimary
                  : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _setAsPrimary
                    ? AppColors.textSecondary
                    : AppColors.divider,
              ),
            ),
            child: _setAsPrimary
                ? Icon(
                    Icons.check,
                    size: AppSpacing.m,
                    color: AppColors.cardBackground,
                  )
                : null,
          ),
        ),
        AppSpacing.gapHorizontalM,
        Text(
          ref.watch(stringsProvider).setAsPrimaryAccount,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTermsSection() {
    final strings = ref.watch(stringsProvider);
    return Container(
      padding: AppSpacing.paddingM,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppSpacing.borderRadiusS,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
            child: Container(
              width: AppSpacing.xl,
              height: AppSpacing.xl,
              decoration: BoxDecoration(
                color: _agreeToTerms
                    ? AppColors.textPrimary
                    : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: _agreeToTerms
                      ? AppColors.textSecondary
                      : AppColors.divider,
                ),
              ),
              child: _agreeToTerms
                  ? Icon(
                      Icons.check,
                      size: AppSpacing.m,
                      color: AppColors.cardBackground,
                    )
                  : null,
            ),
          ),
          AppSpacing.gapHorizontalM,
          Expanded(
            child: Text(
              strings.byAddingBankAccountAgree,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BankOption {
  final String name;
  final IconData icon;

  BankOption({required this.name, required this.icon});
}
