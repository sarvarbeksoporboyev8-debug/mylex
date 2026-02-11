import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// WebView screen for displaying lex.uz pages
class LexWebView extends StatefulWidget {
  final String url;
  final String title;

  const LexWebView({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<LexWebView> createState() => _LexWebViewState();
}

class _LexWebViewState extends State<LexWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _progress = progress / 100;
              if (progress == 100) {
                _isLoading = false;
              }
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(PhosphorIconsRegular.arrowLeft, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: AppTypography.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(PhosphorIconsRegular.arrowClockwise, size: 24),
            onPressed: () => _controller.reload(),
          ),
          IconButton(
            icon: Icon(PhosphorIconsRegular.shareFat, size: 24),
            onPressed: () => _shareUrl(),
          ),
          PopupMenuButton<String>(
            icon: Icon(PhosphorIconsRegular.dotsThreeVertical, size: 24),
            onSelected: (value) {
              if (value == 'browser') {
                _openInBrowser();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'browser',
                child: Row(
                  children: [
                    Icon(PhosphorIconsRegular.globe, 
                        size: 22, color: AppColors.textSecondary),
                    const SizedBox(width: 12),
                    Text('Brauzerda ochish', style: AppTypography.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: _isLoading
            ? PreferredSize(
                preferredSize: const Size.fromHeight(3),
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: AppColors.divider,
                  valueColor: AlwaysStoppedAnimation(AppColors.accent),
                ),
              )
            : null,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }

  void _shareUrl() async {
    // Simple share via url_launcher
    final uri = Uri.parse('sms:?body=${widget.url}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openInBrowser() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Helper function to open lex.uz page
void openLexPage(BuildContext context, String url, String title) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LexWebView(url: url, title: title),
    ),
  );
}
