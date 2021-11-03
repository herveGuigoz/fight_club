import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'font_weights.dart';

/// Text Style Definitions
///
/// ([https://material.io/design/typography](https://material.io/design/typography)).
/// The 2018 spec has thirteen text styles:
/// ```
/// NAME         SIZE  WEIGHT  SPACING
/// headline1    96.0  light   -1.5
/// headline2    60.0  light   -0.5
/// headline3    48.0  regular  0.0
/// headline4    34.0  regular  0.25
/// headline5    24.0  regular  0.0
/// headline6    20.0  medium   0.15
/// subtitle1    16.0  regular  0.15
/// subtitle2    14.0  medium   0.1
/// body1        16.0  regular  0.5   (bodyText1)
/// body2        14.0  regular  0.25  (bodyText2)
/// button       14.0  medium   1.25
/// caption      12.0  regular  0.4
/// overline     10.0  regular  1.5
/// ```
class AppTextStyle {
  static const _kDefaultTextStyle = TextStyle(
    package: 'theme',
    fontFamily: 'RobotoMono',
    inherit: false,
    fontSize: 17.0,
    letterSpacing: -0.41,
    color: Colors.white,
    decoration: TextDecoration.none,
    fontWeight: AppFontWeight.regular,
  );

  /// Headline 1 Text Style
  static TextStyle get headline1 {
    return _kDefaultTextStyle.copyWith(
      fontSize: 96,
      letterSpacing: -1.5,
      fontWeight: AppFontWeight.light,
    );
  }

  /// Headline 2 Text Style
  static TextStyle get headline2 {
    return _kDefaultTextStyle.copyWith(
      fontSize: 60,
      letterSpacing: -0.5,
      fontWeight: AppFontWeight.light,
    );
  }

  /// Headline 3 Text Style
  static TextStyle get headline3 {
    return _kDefaultTextStyle.copyWith(
      fontSize: 48,
      letterSpacing: 0,
      fontWeight: AppFontWeight.regular,
    );
  }

  /// Headline 4 Text Style
  static TextStyle get headline4 {
    return _kDefaultTextStyle.copyWith(
      fontSize: 34,
      letterSpacing: 0.25,
      fontWeight: AppFontWeight.regular,
    );
  }

  /// Headline 5 Text Style
  static TextStyle get headline5 {
    return _kDefaultTextStyle.copyWith(
      fontSize: 24,
      letterSpacing: 0,
      fontWeight: AppFontWeight.regular,
    );
  }

  /// Headline 6 Text Style
  static TextStyle get headline6 {
    return _kDefaultTextStyle.copyWith(
      fontSize: 16,
      letterSpacing: 0.15,
      fontWeight: AppFontWeight.medium,
    );
  }

  /// Subtitle 1 Text Style
  static TextStyle get subtitle1 {
    return _kDefaultTextStyle.copyWith(
      fontSize: 16,
      letterSpacing: 0.15,
      fontWeight: AppFontWeight.regular,
    );
  }

  /// Subtitle 2 Text Style
  static TextStyle get subtitle2 {
    return _kDefaultTextStyle.copyWith(
      fontSize: 14,
      letterSpacing: 0.1,
      fontWeight: AppFontWeight.medium,
    );
  }

  /// Body Text 1 Text Style
  static TextStyle get bodyText1 {
    return _kDefaultTextStyle.copyWith(
      fontSize: 16,
      letterSpacing: 0.5,
      fontWeight: AppFontWeight.regular,
    );
  }

  /// Body Text 2 Text Style (the default)
  static TextStyle get bodyText2 {
    return _kDefaultTextStyle.copyWith(
      fontSize: 12,
      letterSpacing: 0.25,
      fontWeight: AppFontWeight.medium,
    );
  }

  /// Button Text Style
  static TextStyle get button {
    return _kDefaultTextStyle.copyWith(
      fontSize: 14,
      letterSpacing: 1.25,
      fontWeight: AppFontWeight.medium,
    );
  }

  /// Caption Text Style
  static TextStyle get caption {
    return _kDefaultTextStyle.copyWith(
      fontSize: 10,
      letterSpacing: 0.2,
      fontWeight: AppFontWeight.light,
    );
  }

  /// Overline Text Style
  static TextStyle get overline {
    return _kDefaultTextStyle.copyWith(
      fontSize: 10,
      letterSpacing: 1.5,
      fontWeight: AppFontWeight.regular,
    );
  }
}
