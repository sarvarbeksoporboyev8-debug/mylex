import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/settings_models.dart';

/// Bank card widget displaying credit card information with real calculations
class BankCard extends StatelessWidget {
  final CreditCardModel card;
  final VoidCallback? onTap;
  final bool showDetails;

  const BankCard({
    super.key,
    required this.card,
    this.onTap,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    
    return InkWell(
      onTap: onTap,
      borderRadius: SpacingTokens.borderRadius12,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: SpacingTokens.borderRadius12,
          border: Border.all(color: const Color(0xFFF5F5F5)),
        ),
        padding: SpacingTokens.padding12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Card header
            Row(
              children: [
                // Card icon
                Container(
                  width: SpacingTokens.spacing43,
                  height: SpacingTokens.spacing43,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: SpacingTokens.borderRadius8,
                    border: Border.all(color: const Color(0xFFF5F5F5)),
                  ),
                  child: const Icon(
                    PhosphorIconsRegular.buildings,
                    size: 20,
                    color: AppColors.accent,
                  ),
                ),
                SpacingTokens.gapH12,
                // Card name and number
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        card.name,
                        style: AppTypography.bodyMedium.copyWith(
                          color: const Color(0xFF101010),
                        ),
                      ),
                      SpacingTokens.gapV2,
                      Text(
                        '****${card.last4Digits}',
                        style: AppTypography.bodySmall.copyWith(
                          color: const Color(0xFF606060),
                        ),
                      ),
                    ],
                  ),
                ),
                // Primary badge
                if (card.isPrimary)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SpacingTokens.spacing8,
                      vertical: SpacingTokens.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7FFF8),
                      borderRadius: SpacingTokens.borderRadius8,
                      border: Border.all(color: const Color(0xFFB5EFD3)),
                    ),
                    child: const Text(
                      'Primary',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF21D07A),
                      ),
                    ),
                  ),
              ],
            ),
            
            if (showDetails) ...[
              SpacingTokens.gapV12,
              // Credit usage information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${currencyFormat.format(card.usedAmount)} used',
                    style: AppTypography.bodySmall.copyWith(
                      color: const Color(0xFF606060),
                    ),
                  ),
                  Text(
                    '${currencyFormat.format(card.availableCredit)} available',
                    style: AppTypography.bodySmall.copyWith(
                      color: const Color(0xFF606060),
                    ),
                  ),
                ],
              ),
              
              SpacingTokens.gapV6,
              // Progress bar
              ClipRRect(
                borderRadius: SpacingTokens.borderRadius12,
                child: SizedBox(
                  height: SpacingTokens.spacing7,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          Container(color: const Color(0xFFEDEDED)),
                          FractionallySizedBox(
                            widthFactor: card.utilizationRatio.clamp(0.0, 1.0),
                            alignment: Alignment.centerLeft,
                            child: Container(
                              color: card.isNearLimit 
                                  ? Colors.orange 
                                  : AppColors.accent,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              
              SpacingTokens.gapV12,
              // Payment information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Repay before ${DateFormat('d MMM yyyy').format(card.repaymentDate)}',
                        style: AppTypography.bodySmall.copyWith(
                          color: const Color(0xFF606060),
                        ),
                      ),
                      SpacingTokens.gapV2,
                      Text(
                        currencyFormat.format(card.nextPaymentAmount),
                        style: AppTypography.bodyLarge.copyWith(
                          color: const Color(0xFF101010),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // Handle top-up action
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SpacingTokens.spacing16,
                        vertical: SpacingTokens.spacing8,
                      ),
                      side: const BorderSide(color: Color(0xFFEDEDED)),
                      shape: RoundedRectangleBorder(
                        borderRadius: SpacingTokens.borderRadius8,
                      ),
                    ),
                    child: const Text(
                      'Top Up',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF101010),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Compact bank card for list views
class CompactBankCard extends StatelessWidget {
  final CreditCardModel card;
  final VoidCallback? onTap;

  const CompactBankCard({
    super.key,
    required this.card,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BankCard(
      card: card,
      onTap: onTap,
      showDetails: false,
    );
  }
}
