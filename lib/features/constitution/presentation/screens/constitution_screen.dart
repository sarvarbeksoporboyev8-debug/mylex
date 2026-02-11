import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/widgets/content_webview.dart';
import '../../../../core/localization/app_language.dart';

String _getConstitutionUrl(String languageCode) {
  switch (languageCode) {
    case 'uz':
      return 'https://lex.uz/uz/docs/-6445145';
    case 'ru':
      return 'https://lex.uz/ru/docs/6445147';
    case 'en':
      return 'https://lex.uz/en/docs/6451070';
    default: // uz-Cyrl
      return 'https://lex.uz/docs/6445145';
  }
}

class ConstitutionScreen extends ConsumerWidget {
  const ConstitutionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final constitutionUrl = _getConstitutionUrl(language.code);
    
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
            // Content WebView
            Expanded(
              child: ContentWebView(
                key: ValueKey(constitutionUrl),
                url: constitutionUrl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
