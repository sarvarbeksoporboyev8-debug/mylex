import 'package:flutter/material.dart';

/// Spacing system based on 8px grid for consistent layout
/// 
/// Document details screen spacing:
/// - Page padding: 20 horizontal, 16 top
/// - chip -> title: 10-12px
/// - title -> meta card: 12-14px
/// - meta card -> content card: 14-16px
/// - Inside cards: 16-18px padding
/// - label -> value: 4px
/// - heading -> paragraph: 8-10px
/// - paragraph -> next item: 10-12px
/// - bullet list: 6-8px between items
class AppSpacing {
  AppSpacing._();

  // Base 8px grid values
  static const double xs = 4.0;   // half grid
  static const double s = 8.0;    // 1x grid
  static const double sm = 10.0;  // 1.25x grid (chip->title, paragraph->item)
  static const double m = 12.0;   // 1.5x grid (title->meta)
  static const double ml = 14.0;  // 1.75x grid (meta->content)
  static const double l = 16.0;   // 2x grid (card padding, page top)
  static const double xl = 20.0;  // 2.5x grid (page horizontal)
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  // Border radius values - Perplexity uses more rounded corners
  static const double radiusXs = 6.0;
  static const double radiusS = 10.0;
  static const double radiusM = 14.0;
  static const double radiusL = 18.0;
  static const double radiusXl = 22.0;
  static const double radiusXxl = 26.0;
  static const double radiusFull = 999.0;

  // Card padding (16-18px)
  static const EdgeInsets cardPadding = EdgeInsets.all(l);
  static const EdgeInsets cardPaddingLarge = EdgeInsets.all(18.0);

  // Common EdgeInsets
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingS = EdgeInsets.all(s);
  static const EdgeInsets paddingM = EdgeInsets.all(m);
  static const EdgeInsets paddingL = EdgeInsets.all(l);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  static const EdgeInsets paddingHorizontalS = EdgeInsets.symmetric(horizontal: s);
  static const EdgeInsets paddingHorizontalM = EdgeInsets.symmetric(horizontal: m);
  static const EdgeInsets paddingHorizontalL = EdgeInsets.symmetric(horizontal: l);

  static const EdgeInsets paddingVerticalS = EdgeInsets.symmetric(vertical: s);
  static const EdgeInsets paddingVerticalM = EdgeInsets.symmetric(vertical: m);
  static const EdgeInsets paddingVerticalL = EdgeInsets.symmetric(vertical: l);

  // Screen padding: 20 horizontal, 16 top
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: xl, vertical: l);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets screenPaddingLarge = EdgeInsets.symmetric(horizontal: xxl, vertical: l);

  // Common BorderRadius
  static BorderRadius get borderRadiusXs => BorderRadius.circular(radiusXs);
  static BorderRadius get borderRadiusS => BorderRadius.circular(radiusS);
  static BorderRadius get borderRadiusM => BorderRadius.circular(radiusM);
  static BorderRadius get borderRadiusL => BorderRadius.circular(radiusL);
  static BorderRadius get borderRadiusXl => BorderRadius.circular(radiusXl);
  static BorderRadius get borderRadiusXxl => BorderRadius.circular(radiusXxl);
  static BorderRadius get borderRadiusFull => BorderRadius.circular(radiusFull);

  // Gap widgets for use in Row/Column
  static const SizedBox gapXs = SizedBox(width: xs, height: xs);
  static const SizedBox gapS = SizedBox(width: s, height: s);
  static const SizedBox gapM = SizedBox(width: m, height: m);
  static const SizedBox gapL = SizedBox(width: l, height: l);
  static const SizedBox gapXl = SizedBox(width: xl, height: xl);

  static const SizedBox gapHorizontalXs = SizedBox(width: xs);
  static const SizedBox gapHorizontalS = SizedBox(width: s);
  static const SizedBox gapHorizontalM = SizedBox(width: m);
  static const SizedBox gapHorizontalL = SizedBox(width: l);

  static const SizedBox gapVerticalXs = SizedBox(height: xs);
  static const SizedBox gapVerticalS = SizedBox(height: s);
  static const SizedBox gapVerticalSm = SizedBox(height: sm);  // 10px
  static const SizedBox gapVerticalM = SizedBox(height: m);    // 12px
  static const SizedBox gapVerticalMl = SizedBox(height: ml);  // 14px
  static const SizedBox gapVerticalL = SizedBox(height: l);    // 16px
  static const SizedBox gapVerticalXl = SizedBox(height: xl);  // 20px

  /// Max content width for tablets (prevents text from stretching too wide)
  static const double maxContentWidth = 560.0;
}
