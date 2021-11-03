import 'package:flutter/material.dart';
import 'package:theme/src/typography/typography.dart';

class AppThemeData {
  static ThemeData dark = ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(
      titleTextStyle: AppTextStyle.headline6,
      color: Colors.transparent,
      centerTitle: true,
      elevation: 0,
    ),
    textTheme: TextTheme(
      headline1: AppTextStyle.headline1,
      headline2: AppTextStyle.headline2,
      headline3: AppTextStyle.headline3,
      headline4: AppTextStyle.headline4,
      headline5: AppTextStyle.headline5,
      headline6: AppTextStyle.headline6,
      subtitle1: AppTextStyle.subtitle1,
      subtitle2: AppTextStyle.subtitle2,
      bodyText1: AppTextStyle.bodyText1,
      bodyText2: AppTextStyle.bodyText2,
      caption: AppTextStyle.caption,
      button: AppTextStyle.button,
      overline: AppTextStyle.overline,
    ),
  );
}
