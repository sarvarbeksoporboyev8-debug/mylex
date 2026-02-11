import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../theme/theme.dart';

/// JavaScript to extract only document content from lex.uz pages
const String _contentOnlyJs = '''
(function() {
  // HTML content page - extract #divCont
  var divCont = document.getElementById('divCont');
  if (divCont) {
    var content = divCont.innerHTML;
    document.body.innerHTML = '<div style="padding:16px;font-family:Roboto,Arial,sans-serif;font-size:16px;line-height:1.7;color:#2D2D2D;background:#FFFBF5;">' + content + '</div>';
    document.body.style.margin = '0';
    document.body.style.padding = '0';
    document.body.style.backgroundColor = '#FFFBF5';
    return;
  }
  
  // Fallback - try .main-column.document
  var mainDoc = document.querySelector('.main-column.document');
  if (mainDoc) {
    var content = mainDoc.innerHTML;
    document.body.innerHTML = '<div style="padding:16px;font-family:Roboto,Arial,sans-serif;font-size:16px;line-height:1.7;color:#2D2D2D;background:#FFFBF5;">' + content + '</div>';
    document.body.style.margin = '0';
    document.body.style.padding = '0';
    document.body.style.backgroundColor = '#FFFBF5';
    return;
  }
})();
''';

/// A widget that shows document content from lex.uz pages
/// Uses native PDF viewer for PDF files, WebView for HTML content
class ContentWebView extends StatefulWidget {
  final String url;
  final Function(bool isLoading, double progress)? onLoadingChanged;

  const ContentWebView({
    super.key,
    required this.url,
    this.onLoadingChanged,
  });

  @override
  State<ContentWebView> createState() => _ContentWebViewState();
}

class _ContentWebViewState extends State<ContentWebView> {
  WebViewController? _controller;
  bool _isLoading = true;
  double _progress = 0;
  bool _isPdf = false;
  String? _pdfUrl;
  String? _htmlContent;
  bool _contentReady = false;

  @override
  void initState() {
    super.initState();
    _fetchAndDetectContent();
  }

  Future<void> _fetchAndDetectContent() async {
    final url = widget.url;
    
    // Direct PDF URL
    if (url.contains('/pdfs/') || url.contains('/pdffile/') || url.endsWith('.pdf')) {
      String pdfUrl = url;
      if (url.contains('/pdfs/')) {
        pdfUrl = url.replaceFirst('/pdfs/', '/pdffile/');
      }
      setState(() {
        _isPdf = true;
        _pdfUrl = pdfUrl;
        _isLoading = false;
        _contentReady = true;
      });
      widget.onLoadingChanged?.call(false, 1);
      return;
    }

    // Fetch page to detect type and extract content
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final html = response.body;
        
        // Check if it's a PDF page (has pdfBody and PDFObject.embed)
        if (html.contains('id="pdfBody"') && html.contains('PDFObject.embed')) {
          // Extract PDF URL from: PDFObject.embed("/pdffile/12345", "#pdfBody");
          final pdfMatch = RegExp(r'PDFObject\.embed\("([^"]+)"').firstMatch(html);
          if (pdfMatch != null) {
            String pdfPath = pdfMatch.group(1)!;
            String pdfUrl = pdfPath.startsWith('http') ? pdfPath : 'https://lex.uz$pdfPath';
            setState(() {
              _isPdf = true;
              _pdfUrl = pdfUrl;
              _isLoading = false;
              _contentReady = true;
            });
            widget.onLoadingChanged?.call(false, 1);
            return;
          }
        }
        
        // HTML content page - extract content
        String? content;
        
        // Try #divCont
        final divContMatch = RegExp(r'<div id="divCont"[^>]*>([\s\S]*?)</div>\s*</div>\s*</div>\s*</div>\s*</main>', caseSensitive: false).firstMatch(html);
        if (divContMatch != null) {
          content = divContMatch.group(1);
        }
        
        // Fallback: try to find document content area
        if (content == null) {
          final mainDocMatch = RegExp(r'<div id="mD" class="main-column document"[^>]*>([\s\S]*?)</div>\s*</div>\s*</div>', caseSensitive: false).firstMatch(html);
          if (mainDocMatch != null) {
            content = mainDocMatch.group(1);
          }
        }
        
        if (content != null) {
          // Build clean HTML
          _htmlContent = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    body {
      padding: 16px;
      margin: 0;
      font-family: Roboto, Arial, sans-serif;
      font-size: 16px;
      line-height: 1.7;
      color: #2D2D2D;
      background: #FFFBF5;
    }
    a { color: #1976D2; }
    .lx_elem2, .lx_elem3 { display: none; }
  </style>
</head>
<body>$content</body>
</html>
''';
          setState(() {
            _isLoading = false;
            _contentReady = true;
          });
          widget.onLoadingChanged?.call(false, 1);
          _initWebViewWithHtml();
          return;
        }
      }
    } catch (e) {
      debugPrint('Error fetching content: $e');
    }
    
    // Fallback: load in WebView with JS injection
    _initWebView();
  }

  void _initWebViewWithHtml() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFBF5));

    if (_controller!.platform is AndroidWebViewController) {
      (_controller!.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller!.loadHtmlString(_htmlContent!, baseUrl: 'https://lex.uz');
    setState(() {});
  }

  void _initWebView() {
    try {
      late final PlatformWebViewControllerCreationParams params;
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }

      _controller = WebViewController.fromPlatformCreationParams(params)
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0xFFFFFBF5))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              setState(() {
                _progress = progress / 100;
              });
              widget.onLoadingChanged?.call(true, _progress);
            },
            onPageStarted: (String url) {
              widget.onLoadingChanged?.call(true, 0);
            },
            onPageFinished: (String url) {
              _controller?.runJavaScript(_contentOnlyJs);
              setState(() {
                _isLoading = false;
                _contentReady = true;
              });
              widget.onLoadingChanged?.call(false, 1);
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint('WebView error: ${error.description}');
            },
          ),
        );

      if (_controller!.platform is AndroidWebViewController) {
        (_controller!.platform as AndroidWebViewController)
            .setMediaPlaybackRequiresUserGesture(false);
      }

      _controller!.loadRequest(Uri.parse(widget.url));
      setState(() {});
    } catch (e) {
      // If WebView is not supported on this platform, fall back to external browser.
      debugPrint('WebView init error: $e');
      setState(() {
        _isLoading = false;
        _contentReady = true;
        _controller = null;
      });
    }
  }

  void reload() {
    if (_isPdf) {
      setState(() {});
    } else {
      _controller?.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while fetching/detecting content
    if (!_contentReady) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.accent),
            const SizedBox(height: 16),
            Text(
              'Юкланмоқда...',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    // PDF viewer for PDF files
    if (_isPdf && _pdfUrl != null) {
      return SfPdfViewer.network(
        _pdfUrl!,
        onDocumentLoadFailed: (details) {
          debugPrint('PDF load failed: ${details.error}');
        },
      );
    }

    // If WebView failed to initialize (e.g., unsupported platform), show a fallback
    if (_controller == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.public, size: 40, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            const Text(
              'Hujjatni ko‘rsatib bo‘lmadi.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final uri = Uri.parse(widget.url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: const Text('Brauzerda ochish'),
            ),
          ],
        ),
      );
    }

    // WebView for HTML content
    return Column(
      children: [
        if (_isLoading)
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation(AppColors.accent),
            minHeight: 2,
          ),
        Expanded(
          child: WebViewWidget(controller: _controller!),
        ),
      ],
    );
  }
}
