import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Shimmer loading placeholder for lists
class ShimmerListItem extends StatelessWidget {
  final double height;
  final bool showActions;

  const ShimmerListItem({
    super.key,
    this.height = 80,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.glassFill,
      highlightColor: AppColors.glassFillLight,
      child: Container(
        height: height,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        padding: AppSpacing.paddingM,
        decoration: BoxDecoration(
          color: AppColors.glassFill,
          borderRadius: AppSpacing.borderRadiusL,
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            // Index number placeholder
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.glassFillLight,
                borderRadius: AppSpacing.borderRadiusS,
              ),
            ),
            AppSpacing.gapHorizontalM,
            // Content placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.glassFillLight,
                      borderRadius: AppSpacing.borderRadiusXs,
                    ),
                  ),
                  AppSpacing.gapVerticalS,
                  Container(
                    height: 12,
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppColors.glassFillLight,
                      borderRadius: AppSpacing.borderRadiusXs,
                    ),
                  ),
                ],
              ),
            ),
            if (showActions) ...[
              AppSpacing.gapHorizontalM,
              // Action icons placeholder
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 12,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.glassFillLight,
                      borderRadius: AppSpacing.borderRadiusXs,
                    ),
                  ),
                  AppSpacing.gapVerticalS,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      4,
                      (index) => Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: AppColors.glassFillLight,
                          shape: BoxShape.circle,
                        ),
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

/// Shimmer loading for list screens
class ShimmerList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final bool showActions;

  const ShimmerList({
    super.key,
    this.itemCount = 6,
    this.itemHeight = 80,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => ShimmerListItem(
        height: itemHeight,
        showActions: showActions,
      ),
    );
  }
}

/// Shimmer loading for chat messages
class ShimmerChatMessage extends StatelessWidget {
  final bool isUser;

  const ShimmerChatMessage({
    super.key,
    this.isUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.glassFill,
      highlightColor: AppColors.glassFillLight,
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(
            left: isUser ? 60 : AppSpacing.m,
            right: isUser ? AppSpacing.m : 60,
            bottom: AppSpacing.m,
          ),
          padding: AppSpacing.paddingM,
          decoration: BoxDecoration(
            color: isUser ? AppColors.userBubble : AppColors.glassFill,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(AppSpacing.radiusL),
              topRight: const Radius.circular(AppSpacing.radiusL),
              bottomLeft: Radius.circular(isUser ? AppSpacing.radiusL : 4),
              bottomRight: Radius.circular(isUser ? 4 : AppSpacing.radiusL),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 14,
                width: 200,
                decoration: BoxDecoration(
                  color: AppColors.glassFillLight,
                  borderRadius: AppSpacing.borderRadiusXs,
                ),
              ),
              AppSpacing.gapVerticalS,
              Container(
                height: 14,
                width: 150,
                decoration: BoxDecoration(
                  color: AppColors.glassFillLight,
                  borderRadius: AppSpacing.borderRadiusXs,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shimmer loading for content/document view
class ShimmerContent extends StatelessWidget {
  const ShimmerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.glassFill,
      highlightColor: AppColors.glassFillLight,
      child: Padding(
        padding: AppSpacing.paddingL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Container(
              height: 24,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.glassFillLight,
                borderRadius: AppSpacing.borderRadiusS,
              ),
            ),
            AppSpacing.gapVerticalL,
            // Paragraphs
            ...List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.glassFillLight,
                        borderRadius: AppSpacing.borderRadiusXs,
                      ),
                    ),
                    AppSpacing.gapVerticalS,
                    Container(
                      height: 14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.glassFillLight,
                        borderRadius: AppSpacing.borderRadiusXs,
                      ),
                    ),
                    AppSpacing.gapVerticalS,
                    Container(
                      height: 14,
                      width: 200,
                      decoration: BoxDecoration(
                        color: AppColors.glassFillLight,
                        borderRadius: AppSpacing.borderRadiusXs,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
