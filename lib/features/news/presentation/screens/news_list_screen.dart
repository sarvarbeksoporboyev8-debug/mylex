import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/localization/app_strings.dart';
import '../../data/news_repository.dart';
import '../../domain/news_model.dart';

final newsSearchQueryProvider = StateProvider<String?>((ref) => null);

class NewsListScreen extends ConsumerStatefulWidget {
  const NewsListScreen({super.key});

  @override
  ConsumerState<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends ConsumerState<NewsListScreen> {
  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);
    final newsAsync = ref.watch(newsListProvider(null));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with logo centered and settings on right
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/yurist_ai_logo.png',
                      height: 32,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: GlassIconButton(
                      icon: PhosphorIconsRegular.gearSix,
                      onPressed: () => context.push(AppRoutes.settings),
                    ),
                  ),
                ],
              ),
            ),
            // List
            Expanded(
              child: newsAsync.when(
                data: (news) {
                  return _buildList(context, news);
                },
                loading: () => Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                ),
                error: (e, _) => Center(
                  child: Text(strings.error, style: AppTypography.bodyMedium),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<NewsArticle> news) {
    final strings = ref.watch(stringsProvider);
    if (news.isEmpty) {
      return Center(
        child: Text(
          strings.noNewsFound,
          style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(newsRepositoryProvider).clearCache();
        ref.invalidate(newsListProvider);
      },
      color: AppColors.accent,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 100 + MediaQuery.of(context).padding.bottom),
        itemCount: news.length,
        itemBuilder: (context, index) {
          final item = news[index];
          return _NewsListItem(
            news: item,
            onTap: () => context.go(AppRoutes.newsDetailsPath(item.id)),
            onShare: () => _shareDocument(item),
            onDownload: () => _downloadFile(item.docUrl, item.title, 'html'),
            onDownloadDoc: () => _downloadFile('https://lex.uz/docs/${item.id}?format=doc', item.title, 'doc'),
            onDownloadPdf: () => _downloadFile(item.pdfUrl?.replaceFirst('/pdfs/', '/pdffile/'), item.title, 'pdf'),
          );
        },
      ),
    );
  }

  void _shareDocument(NewsArticle news) {
    final url = news.docUrl ?? 'https://lex.uz/docs/${news.id}';
    Share.share('${news.title}\n\n$url');
  }

  Future<void> _downloadFile(String? url, String title, String extension) async {
    final strings = ref.read(stringsProvider);
    if (url == null) {
      _showSnackBar(strings.urlNotAvailable);
      return;
    }

    _showSnackBar(strings.downloading);

    try {
      final dio = Dio();
      final dir = await getApplicationDocumentsDirectory();
      final sanitizedTitle = title.replaceAll(RegExp(r'[^\w\s-]'), '').trim();
      final fileName = '${sanitizedTitle.substring(0, sanitizedTitle.length.clamp(0, 50))}.$extension';
      final filePath = '${dir.path}/$fileName';

      await dio.download(url, filePath);

      _showSnackBar('${strings.downloaded}: $fileName');
      
      await Share.shareXFiles([XFile(filePath)], text: title);
    } catch (e) {
      _showSnackBar(strings.downloadError);
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Roboto')),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _NewsListItem extends StatelessWidget {
  final NewsArticle news;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final VoidCallback onDownload;
  final VoidCallback onDownloadDoc;
  final VoidCallback onDownloadPdf;

  const _NewsListItem({
    required this.news,
    required this.onTap,
    required this.onShare,
    required this.onDownload,
    required this.onDownloadDoc,
    required this.onDownloadPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      news.category,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.accent,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    news.formattedDate,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                news.title,
                style: AppTypography.bodyMedium.copyWith(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (news.summary != null) ...[
                const SizedBox(height: 4),
                Text(
                  news.summary!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontFamily: 'Roboto',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              // 4 action buttons
              Row(
                children: [
                  _ActionButton(
                    icon: Icons.download,
                    onTap: onDownload,
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    icon: Icons.picture_as_pdf,
                    onTap: onDownloadPdf,
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    icon: Icons.description,
                    onTap: onDownloadDoc,
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    icon: Icons.share,
                    onTap: onShare,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: AppColors.textSecondary),
      ),
    );
  }
}
