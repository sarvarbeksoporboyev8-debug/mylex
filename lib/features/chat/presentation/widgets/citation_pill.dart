import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/theme.dart';
import '../../domain/chat_model.dart';

/// Perplexity-style inline citation pill (e.g., "norma +1", "lex")
/// Shows primary source label and +N for additional sources
class CitationPill extends StatelessWidget {
  final String primaryLabel;
  final int additionalCount;
  final List<Source> anchorSources;  // All sources for this anchor

  const CitationPill({
    super.key,
    required this.primaryLabel,
    required this.additionalCount,
    required this.anchorSources,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = additionalCount > 0 
        ? '$primaryLabel +$additionalCount' 
        : primaryLabel;
    
    return GestureDetector(
      onTap: () => _showAnchorSourcesSheet(context),
      child: Container(
        margin: const EdgeInsets.only(left: 6, right: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          displayText,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.accent,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }

  void _showAnchorSourcesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true, // Allow dynamic height
      builder: (context) => AnchorSourcesSheet(sources: anchorSources),
    );
  }
}

/// Bottom sheet showing all sources for an anchor (Perplexity style)
class AnchorSourcesSheet extends StatelessWidget {
  final List<Source> sources;

  const AnchorSourcesSheet({
    super.key,
    required this.sources,
  });

  @override
  Widget build(BuildContext context) {
    // Set max height to 70% of screen to prevent overflow
    final maxHeight = MediaQuery.of(context).size.height * 0.7;
    
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Manbalar (${sources.length})',
                style: AppTypography.titleMedium.copyWith(
                  fontFamily: 'Roboto',
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Scrollable sources list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: sources.length,
                itemBuilder: (context, index) {
                  // Remove bottom margin from last item
                  final isLast = index == sources.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                    child: _SourceRow(source: sources[index]),
                  );
                },
              ),
            ),
            
            // Bottom padding
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  final Source source;

  const _SourceRow({required this.source});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openUrl(source.url),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            // Label pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                source.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Title and domain
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    source.title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontFamily: 'Roboto',
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    source.domain,
                    style: AppTypography.bodySmall.copyWith(
                      fontFamily: 'Roboto',
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(
              Icons.open_in_new,
              size: 18,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Sources section at bottom of message (optional consolidated view)
class SourcesSection extends StatelessWidget {
  final Map<String, Source> sources;

  const SourcesSection({
    super.key,
    required this.sources,
  });

  @override
  Widget build(BuildContext context) {
    if (sources.isEmpty) return const SizedBox.shrink();

    final sourcesList = sources.values.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Manbalar',
          style: AppTypography.labelMedium.copyWith(
            fontFamily: 'Roboto',
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sourcesList.map((source) => _SourceChip(source: source)).toList(),
        ),
      ],
    );
  }
}

class _SourceChip extends StatelessWidget {
  final Source source;

  const _SourceChip({required this.source});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openUrl(source.url),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                source.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                source.title,
                style: AppTypography.bodySmall.copyWith(
                  fontFamily: 'Roboto',
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Related questions section
class RelatedQuestionsSection extends StatelessWidget {
  final List<String> questions;
  final Function(String) onQuestionTap;

  const RelatedQuestionsSection({
    super.key,
    required this.questions,
    required this.onQuestionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Tegishli savollar',
          style: AppTypography.labelMedium.copyWith(
            fontFamily: 'Roboto',
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: questions.map((q) => _QuestionChip(
            question: q,
            onTap: () => onQuestionTap(q),
          )).toList(),
        ),
      ],
    );
  }
}

class _QuestionChip extends StatelessWidget {
  final String question;
  final VoidCallback onTap;

  const _QuestionChip({
    required this.question,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: AppColors.accent,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                question,
                style: AppTypography.bodySmall.copyWith(
                  fontFamily: 'Roboto',
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
