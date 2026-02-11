import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/localization/app_strings.dart';

/// Clean bottom navigation bar - Claude style
/// 
/// - White background
/// - Bigger icons (34px)
/// - Bigger labels (14px)
/// - Subtle top border
/// - Generous spacing
class GlassNavBar extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GlassNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 100 + bottomPadding,
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          top: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            asset: AppConstants.navKonstitutsiya,
            label: strings.navConstitution,
            isActive: currentIndex == 0,
            onTap: () => _onItemTap(0),
          ),
          _NavItem(
            asset: AppConstants.navKodekslar,
            label: strings.navCodes,
            isActive: currentIndex == 1,
            onTap: () => _onItemTap(1),
          ),
          _NavItem(
            asset: AppConstants.navChatbot,
            label: strings.navAiAssistant,
            isActive: currentIndex == 2,
            onTap: () => _onItemTap(2),
          ),
          _NavItem(
            asset: AppConstants.navQonunlar,
            label: strings.navLaws,
            isActive: currentIndex == 3,
            onTap: () => _onItemTap(3),
          ),
          _NavItem(
            asset: AppConstants.navYangiliklar,
            label: strings.navNews,
            isActive: currentIndex == 4,
            onTap: () => _onItemTap(4),
          ),
        ],
      ),
    );
  }

  void _onItemTap(int index) {
    HapticFeedback.lightImpact();
    onTap(index);
  }
}

/// Individual navigation item
class _NavItem extends StatelessWidget {
  final String asset;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.asset,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isActive 
        ? AppColors.accent 
        : AppColors.textTertiary;
    
    final labelColor = isActive
        ? AppColors.accent
        : AppColors.textTertiary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 74,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon - BIG (34px)
            Image.asset(
              asset,
              width: 34,
              height: 34,
              color: iconColor,
              colorBlendMode: BlendMode.srcIn,
            ),
            const SizedBox(height: 8),
            // Label - BIG (14px)
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: labelColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
