import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/theme.dart';
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form section
                    _buildFormSection(),
                    const SizedBox(height: 12),
                    // Terms section
                    _buildTermsSection(),
                  ],
                ),
              ),
            ),
            // Add button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isFormValid && !_isLoading ? _handleAddBank : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid
                        ? const Color(0xFF101010)
                        : const Color(0xFFEDEDED),
                    foregroundColor: _isFormValid
                        ? Colors.white
                        : const Color(0xFFC2C2C2),
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
                          ref.watch(stringsProvider).addBankAccount,
                          style: TextStyle(
                            fontFamily: 'Onest',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 1.5,
                            color: _isFormValid
                                ? Colors.white
                                : const Color(0xFFC2C2C2),
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
              ref.watch(stringsProvider).addBankAccount,
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
          // Bank Name dropdown
          _buildBankNameField(),
          const SizedBox(height: 12),
          // Account Name
          _buildInputField(
            label: strings.accountName,
            controller: _accountNameController,
            isRequired: true,
          ),
          const SizedBox(height: 12),
          // Account Number
          _buildInputField(
            label: strings.accountNumber,
            controller: _accountNumberController,
            keyboardType: TextInputType.number,
            isRequired: true,
          ),
          const SizedBox(height: 12),
          // Set as primary checkbox
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
                color: const Color(0xFF101010),
              ),
            ),
            const Text(
              ' *',
              style: TextStyle(color: Color(0xFFE63946)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() => _isDropdownOpen = !_isDropdownOpen);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFEDEDED)),
            ),
            child: _selectedBank == null
                ? Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Placeholder',
                          style: AppTypography.bodyMedium.copyWith(
                            color: const Color(0xFF878787),
                          ),
                        ),
                      ),
                      Icon(
                        _isDropdownOpen
                            ? PhosphorIconsRegular.caretUp
                            : PhosphorIconsRegular.caretDown,
                        size: 20,
                        color: const Color(0xFF878787),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFF5F5F5)),
          ),
          child: Icon(
            bank.icon,
            size: 20,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            bankName,
            style: AppTypography.bodyMedium.copyWith(
              color: const Color(0xFF101010),
            ),
          ),
        ),
        const Icon(
          PhosphorIconsRegular.checkCircle,
          size: 32,
          color: Color(0xFF21D07A),
        ),
      ],
    );
  }

  Widget _buildBankDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDEDED)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFF5F5F5)),
                    ),
                    child: Icon(
                      bank.icon,
                      size: 20,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      bank.name,
                      style: AppTypography.bodyMedium.copyWith(
                        color: const Color(0xFF101010),
                      ),
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF21D07A)
                            : const Color(0xFFEDEDED),
                        width: isSelected ? 1.667 : 1,
                      ),
                      color: isSelected
                          ? const Color(0xFF21D07A)
                          : Colors.white,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
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
                color: const Color(0xFF101010),
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Color(0xFFE63946)),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: (_) => setState(() {}),
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

  Widget _buildPrimaryCheckbox() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => setState(() => _setAsPrimary = !_setAsPrimary),
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: _setAsPrimary
                  ? const Color(0xFF101010)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _setAsPrimary
                    ? const Color(0xFF383838)
                    : const Color(0xFFD6D6D6),
              ),
            ),
            child: _setAsPrimary
                ? const Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          ref.watch(stringsProvider).setAsPrimaryAccount,
          style: AppTypography.bodyMedium.copyWith(
            color: const Color(0xFF101010),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsSection() {
    final strings = ref.watch(stringsProvider);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: _agreeToTerms
                    ? const Color(0xFF101010)
                    : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: _agreeToTerms
                      ? const Color(0xFF383838)
                      : const Color(0xFFD6D6D6),
                ),
              ),
              child: _agreeToTerms
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              strings.byAddingBankAccountAgree,
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

class BankOption {
  final String name;
  final IconData icon;

  BankOption({required this.name, required this.icon});
}
