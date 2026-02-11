import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/code_model.dart';

/// List item widget for code documents (Lex.uz style)
class CodeListItem extends StatelessWidget {
  final CodeDocument code;
  final VoidCallback onTap;
  final VoidCallback? onShare;
  final VoidCallback? onDownloadDoc;
  final VoidCallback? onDownloadPdf;
  final VoidCallback? onDownload;
  final int animationIndex;

  const CodeListItem({
    super.key,
    required this.code,
    required this.onTap,
    this.onShare,
    this.onDownloadDoc,
    this.onDownloadPdf,
    this.onDownload,
    this.animationIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      padding: AppSpacing.paddingM,
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Index number
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: AppSpacing.borderRadiusS,
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${code.index}',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textOnGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          AppSpacing.gapHorizontalM,

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  code.title,
                  style: AppTypography.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                AppSpacing.gapVerticalXs,

                // Issuer
                Text(
                  code.issuer,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                AppSpacing.gapVerticalS,

                // Action icons row
                Row(
                  children: [
                    _ActionIcon(
                      icon: PhosphorIconsRegular.shareFat,
                      onTap: onShare,
                      tooltip: 'Ulashish',
                    ),
                    AppSpacing.gapHorizontalS,
                    _ActionIcon(
                      icon: PhosphorIconsRegular.fileDoc,
                      onTap: onDownloadDoc,
                      tooltip: 'DOC',
                    ),
                    AppSpacing.gapHorizontalS,
                    _ActionIcon(
                      icon: PhosphorIconsRegular.filePdf,
                      onTap: onDownloadPdf,
                      tooltip: 'PDF',
                    ),
                    AppSpacing.gapHorizontalS,
                    _ActionIcon(
                      icon: code.isDownloaded
                          ? PhosphorIconsFill.checkCircle
                          : PhosphorIconsRegular.downloadSimple,
                      onTap: code.isDownloaded ? null : onDownload,
                      tooltip: code.isDownloaded ? 'Yuklangan' : 'Yuklab olish',
                      isActive: code.isDownloaded,
                    ),
                  ],
                ),
              ],
            ),
          ),

          AppSpacing.gapHorizontalS,

          // Right side: doc number and date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Favorite indicator
              if (code.isFavorite)
                Icon(
                  PhosphorIconsFill.heart,
                  size: 16,
                  color: AppColors.error,
                ),

              AppSpacing.gapVerticalS,

              // Doc number
              Text(
                code.docNumber,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Date (only if available)
              if (code.formattedDate != null) ...[
                AppSpacing.gapVerticalXs,
                Text(
                  code.formattedDate!,
                  style: AppTypography.caption,
                ),
              ],
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 50 * animationIndex),
          duration: 300.ms,
        )
        .slideX(
          begin: 0.1,
          end: 0,
          delay: Duration(milliseconds: 50 * animationIndex),
          duration: 300.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

/// Small action icon button
class _ActionIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String tooltip;
  final bool isActive;

  const _ActionIcon({
    required this.icon,
    this.onTap,
    required this.tooltip,
    this.isActive = false,
  });

  @override
  State<_ActionIcon> createState() => _ActionIconState();
}

class _ActionIconState extends State<_ActionIcon> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: GestureDetector(
        onTapDown: widget.onTap != null
            ? (_) => setState(() => _isPressed = true)
            : null,
        onTapUp: widget.onTap != null
            ? (_) {
                setState(() => _isPressed = false);
                HapticFeedback.lightImpact();
                widget.onTap?.call();
              }
            : null,
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _isPressed
                ? AppColors.gold.withOpacity(0.2)
                : widget.isActive
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.glassFill,
            borderRadius: AppSpacing.borderRadiusS,
            border: Border.all(
              color: widget.isActive
                  ? AppColors.success.withOpacity(0.3)
                  : AppColors.glassBorder,
              width: 0.5,
            ),
          ),
          child: Center(
            child: Icon(
              widget.icon,
              size: 16,
              color: widget.isActive
                  ? AppColors.success
                  : widget.onTap != null
                      ? AppColors.textSecondary
                      : AppColors.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}
