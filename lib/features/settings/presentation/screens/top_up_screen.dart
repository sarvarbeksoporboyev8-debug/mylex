import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/localization/app_strings.dart';

class TopUpScreen extends ConsumerStatefulWidget {
  const TopUpScreen({super.key});

  @override
  ConsumerState<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends ConsumerState<TopUpScreen> {
  int? _selectedAmount;
  String? _selectedPaymentMethod;

  final List<int> _amounts = [10000, 25000, 50000, 100000, 250000, 500000];

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          strings.topUpWallet,
          style: AppTypography.titleMedium.copyWith(
            fontFamily: 'Roboto',
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Amount selection
          Text(
            'Summani tanlang',
            style: AppTypography.titleSmall.copyWith(
              fontFamily: 'Roboto',
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _amounts.map((amount) {
              final isSelected = _selectedAmount == amount;
              return GestureDetector(
                onTap: () => setState(() => _selectedAmount = amount),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accent : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.accent : AppColors.divider,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    '${_formatAmount(amount)} so\'m',
                    style: AppTypography.bodyMedium.copyWith(
                      fontFamily: 'Roboto',
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Payment method selection
          Text(
            'To\'lov usulini tanlang',
            style: AppTypography.titleSmall.copyWith(
              fontFamily: 'Roboto',
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildPaymentMethod(
            id: 'payme',
            name: 'Payme',
            icon: PhosphorIconsRegular.creditCard,
            color: const Color(0xFF00CCCC),
          ),
          const SizedBox(height: 12),
          _buildPaymentMethod(
            id: 'click',
            name: 'Click',
            icon: PhosphorIconsRegular.creditCard,
            color: const Color(0xFF00A8E8),
          ),
          const SizedBox(height: 12),
          _buildPaymentMethod(
            id: 'uzum',
            name: 'Uzum Bank',
            icon: PhosphorIconsRegular.bank,
            color: const Color(0xFF7B2D8E),
          ),

          const SizedBox(height: 40),

          // Pay button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedAmount != null && _selectedPaymentMethod != null
                  ? _handlePayment
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.divider,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                _selectedAmount != null
                    ? 'To\'lash - ${_formatAmount(_selectedAmount!)} so\'m'
                    : 'To\'lash',
                style: AppTypography.labelLarge.copyWith(
                  fontFamily: 'Roboto',
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Info text
          Text(
            'To\'lov xavfsiz amalga oshiriladi. Mablag\' darhol hisobingizga tushadi.',
            style: AppTypography.bodySmall.copyWith(
              fontFamily: 'Roboto',
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod({
    required String id,
    required String name,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedPaymentMethod == id;

    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: AppTypography.bodyLarge.copyWith(
                  fontFamily: 'Roboto',
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              )
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.divider, width: 2),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  void _handlePayment() {
    // TODO: Integrate with actual payment gateway
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('To\'lov tizimi tez orada ulanadi'),
        backgroundColor: AppColors.accent,
      ),
    );
  }
}
