import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// A reusable payment card widget for displaying bank account information.
/// 
/// This widget displays bank name, last 4 digits, and optional status badge.
class SettingsPaymentCard extends StatelessWidget {
  /// Bank name
  final String name;
  
  /// Last 4 digits of the account
  final String last4;
  
  /// Whether this is the primary account
  final bool isPrimary;
  
  /// Status label to display if isPrimary is true
  final String? statusLabel;
  
  /// Border radius for the card
  final double borderRadius;

  const SettingsPaymentCard({
    super.key,
    required this.name,
    required this.last4,
    this.isPrimary = false,
    this.statusLabel,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: const Color(0xFFF5F5F5)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Bank icon
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFF5F5F5)),
            ),
            child: const Center(
              child: Icon(
                PhosphorIconsRegular.buildings,
                size: 20,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Bank info
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
                const SizedBox(height: 2),
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
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE7FFF8),
                borderRadius: BorderRadius.circular(6),
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
    );
  }
}
