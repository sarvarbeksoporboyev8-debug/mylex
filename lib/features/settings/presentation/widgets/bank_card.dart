import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../domain/models/settings_models.dart';

/// Bank card display widget
/// 
/// Shows credit card information with dynamic calculations
/// for available credit and utilization percentage.
class BankCard extends StatelessWidget {
  final CreditCardModel card;
  final VoidCallback? onTap;
  final bool showProgressBar;

  const BankCard({
    super.key,
    required this.card,
    this.onTap,
    this.showProgressBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SpacingTokens.spacing20,
          vertical: SpacingTokens.spacing12,
        ),
        child: Row(
          children: [
            // Bank icon
            Container(
              width: SpacingTokens.spacing44,
              height: SpacingTokens.spacing44,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.08),
                borderRadius: SpacingTokens.borderRadius10,
              ),
              child: const Icon(
                PhosphorIconsRegular.bank,
                size: SpacingTokens.iconSize20,
                color: AppColors.accent,
              ),
            ),
            SpacingTokens.horizontalGap12,
            // Card info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    card.bankName,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SpacingTokens.verticalGap4,
                  Text(
                    card.cardNumber,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (showProgressBar) ...[
                    SpacingTokens.verticalGap8,
                    _buildProgressBar(),
                    SpacingTokens.verticalGap4,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${card.availableCredit.toStringAsFixed(2)} available',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          '${card.creditUtilizationPercentage.toStringAsFixed(0)}% used',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SpacingTokens.horizontalGap8,
            Icon(
              PhosphorIconsRegular.caretRight,
              size: SpacingTokens.iconSize20,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SpacingTokens.spacing4),
      child: SizedBox(
        height: SpacingTokens.spacing6,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.backgroundSecondary,
            ),
            FractionallySizedBox(
              widthFactor: card.creditUtilizationRatio,
              child: Container(
                color: _getProgressColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor() {
    final percentage = card.creditUtilizationPercentage;
    if (percentage < 50) {
      return AppColors.success;
    } else if (percentage < 75) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }
}
