import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/theme.dart';

/// A reusable bank card/account widget for displaying linked banks.
/// Shows bank icon, name, last 4 digits, and optional status badge.
class BankCard extends StatelessWidget {
  final String name;
  final String last4;
  final bool isPrimary;
  final String? statusLabel;
  final VoidCallback? onTap;
  final IconData? icon;

  const BankCard({
    super.key,
    required this.name,
    required this.last4,
    this.isPrimary = false,
    this.statusLabel,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: SpacingTokens.borderRadiusXLarge,
          border: Border.all(color: const Color(0xFFF5F5F5)),
        ),
        padding: SpacingTokens.padding12,
        child: Row(
          children: [
            // Bank icon container
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: SpacingTokens.borderRadiusMedium,
                border: Border.all(color: const Color(0xFFF5F5F5)),
              ),
              child: Center(
                child: Icon(
                  icon ?? PhosphorIconsRegular.buildings,
                  size: SpacingTokens.iconSize,
                  color: AppColors.accent,
                ),
              ),
            ),
            SpacingTokens.gapH12,
            // Bank details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.bodyMedium.copyWith(
                      color: const Color(0xFF101010),
                    ),
                  ),
                  SpacingTokens.gapV2,
                  Text(
                    '****$last4',
                    style: AppTypography.bodySmall.copyWith(
                      color: const Color(0xFF606060),
                    ),
                  ),
                ],
              ),
            ),
            // Status badge
            if (isPrimary && statusLabel != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.spacing8,
                  vertical: SpacingTokens.spacing4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7FFF8),
                  borderRadius: SpacingTokens.borderRadiusSmall,
                  border: Border.all(color: const Color(0xFFB5EFD3)),
                ),
                child: Text(
                  statusLabel!,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF21D07A),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
