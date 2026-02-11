import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/localization/app_strings.dart';
import '../../data/codes_repository.dart';
import '../../domain/code_model.dart';

final codesSearchQueryProvider = StateProvider<String?>((ref) => null);

class CodesListScreen extends ConsumerStatefulWidget {
  const CodesListScreen({super.key});

  @override
  ConsumerState<CodesListScreen> createState() => _CodesListScreenState();
}

class _CodesListScreenState extends ConsumerState<CodesListScreen> {
  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);
    final codesAsync = ref.watch(
      codesListProvider((filter: CodeFilter.all, query: null)),
    );

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
              child: codesAsync.when(
                data: (codes) => _buildList(codes),
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

  Widget _buildList(List<CodeDocument> codes) {
    final strings = ref.watch(stringsProvider);
    if (codes.isEmpty) {
      return Center(
        child: Text(
          strings.noCodesFound,
          style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(codesRepositoryProvider).clearCache();
        ref.invalidate(codesListProvider);
      },
      color: AppColors.accent,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 100 + MediaQuery.of(context).padding.bottom),
        itemCount: codes.length,
        itemBuilder: (context, index) {
          final code = codes[index];
          return _CodeListItem(
            code: code,
            onTap: () => context.go(AppRoutes.codeDetailsPath(code.id)),
            onShare: () => _shareDocument(code),
            onDownload: () => _downloadFile(code.docUrl, code.title, 'html'),
            onDownloadDoc: () => _downloadFile('https://lex.uz/docs/${code.id}?format=doc', code.title, 'doc'),
            onDownloadPdf: () => _downloadFile(code.pdfUrl?.replaceFirst('/pdfs/', '/pdffile/'), code.title, 'pdf'),
          );
        },
      ),
    );
  }

  void _shareDocument(CodeDocument code) {
    final url = code.docUrl ?? 'https://lex.uz/docs/${code.id}';
    Share.share('${code.title}\n\n$url');
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
      
      // Share the downloaded file so user can open/save it
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

class _CodeListItem extends ConsumerWidget {
  final CodeDocument code;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final VoidCallback onDownload;
  final VoidCallback onDownloadDoc;
  final VoidCallback onDownloadPdf;

  const _CodeListItem({
    required this.code,
    required this.onTap,
    required this.onShare,
    required this.onDownload,
    required this.onDownloadDoc,
    required this.onDownloadPdf,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: code.isExpired ? Colors.red.withOpacity(0.5) : AppColors.divider,
          width: code.isExpired ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                code.title,
                style: AppTypography.bodyMedium.copyWith(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                  color: code.isExpired ? AppColors.textSecondary : AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Date and summary
              Row(
                children: [
                  if (code.formattedDate != null)
                    Text(
                      code.formattedDate!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  if (code.summary != null && code.summary!.isNotEmpty) ...[
                    if (code.formattedDate != null) const SizedBox(width: 8),
                    Text(
                      '• ${code.summary}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ],
              ),
              // Expired warning
              if (code.isExpired) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 16, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        '${strings.expiredDate}: ${code.formattedExpiredDate}',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.red,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
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
