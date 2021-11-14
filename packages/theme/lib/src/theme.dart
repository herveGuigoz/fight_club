import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme/src/colors.dart';
import 'package:theme/src/typography/typography.dart';

/// {@template AppThemeData}
/// Defines the configuration of the overall visual [Theme] for a [MaterialApp]
/// or a widget subtree within the app.
/// {@endtemplate}
class AppThemeData {
  /// App dark theme
  static ThemeData dark = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
      primarySwatch: MaterialColor(
        AppColors.green5.value,
        const {
          100: AppColors.green1,
          200: AppColors.green2,
          300: AppColors.green3,
          400: AppColors.green4,
          500: AppColors.green5,
          600: AppColors.green6,
          700: AppColors.green7,
          800: AppColors.green8,
          900: AppColors.green9,
        },
      ),
      accentColor: AppColors.green5,
    ),
    backgroundColor: AppColors.background,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: TextTheme(
      headline1: AppTextStyle.headline1.copyWith(color: AppColors.gray12),
      headline2: AppTextStyle.headline2.copyWith(color: AppColors.gray12),
      headline3: AppTextStyle.headline3.copyWith(color: AppColors.gray12),
      headline4: AppTextStyle.headline4.copyWith(color: AppColors.gray12),
      headline5: AppTextStyle.headline5.copyWith(color: AppColors.gray12),
      headline6: AppTextStyle.headline6.copyWith(color: AppColors.gray12),
      subtitle1: AppTextStyle.subtitle1.copyWith(color: AppColors.gray12),
      subtitle2: AppTextStyle.subtitle2.copyWith(color: AppColors.gray12),
      bodyText1: AppTextStyle.bodyText1.copyWith(color: AppColors.gray12),
      bodyText2: AppTextStyle.bodyText2.copyWith(color: AppColors.gray12),
      caption: AppTextStyle.caption.copyWith(color: AppColors.gray12),
      button: AppTextStyle.button.copyWith(color: AppColors.gray12),
      overline: AppTextStyle.overline.copyWith(color: AppColors.gray12),
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: AppTextStyle.headline5.copyWith(color: AppColors.gray12),
      color: AppColors.background,
      centerTitle: true,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: AppColors.background,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: AppColors.green12,
      ),
    ),
    dialogTheme: DialogTheme(
      titleTextStyle: AppTextStyle.subtitle1,
      contentTextStyle: AppTextStyle.bodyText2,
    ),
  );
}
