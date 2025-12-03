import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get light {
    return FlexThemeData.light(
      scheme: FlexScheme.green,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 7,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 10,
        blendOnColors: false,
        useMaterial3Typography: true,
        useM2StyleDividerInM3: true,
        alignedDropdown: true,
        useInputDecoratorThemeInDialogs: true,
        filledButtonTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 16)),
        outlinedButtonTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 16),
        ),
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          color: Colors.green,
        ),
      ),
    );
  }

  static ThemeData get dark {
    return FlexThemeData.dark(
      scheme: FlexScheme.green,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 13,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
        useMaterial3Typography: true,
        useM2StyleDividerInM3: true,
        alignedDropdown: true,
        useInputDecoratorThemeInDialogs: true,
        filledButtonTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 16)),
        outlinedButtonTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 16),
        ),
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          color: Colors.green,
        ),
      ),
    );
  }
}
