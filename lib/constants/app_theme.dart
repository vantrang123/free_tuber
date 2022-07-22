import 'package:flutter/material.dart';

import 'colors.dart';
import 'font_family.dart';

final ThemeData themeData = new ThemeData(
    fontFamily: FontFamily.productSans,
    primaryColor: AppColors.accentColor[500],
    colorScheme: ColorScheme.fromSwatch(
            primarySwatch: MaterialColor(
                AppColors.accentColor[500]!.value, AppColors.accentColor))
        .copyWith(
            secondary: AppColors.accentColor[500],
            brightness: Brightness.light));

final ThemeData themeDataDark = ThemeData(
    fontFamily: FontFamily.productSans,
    primaryColor: AppColors.accentColor[500],
    colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: AppColors.accentColor[500], brightness: Brightness.dark));
