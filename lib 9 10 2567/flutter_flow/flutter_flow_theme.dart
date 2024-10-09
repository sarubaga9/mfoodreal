// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class FlutterFlowTheme {
  static FlutterFlowTheme of(BuildContext context) {
    return LightModeTheme();
  }

  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary;
  late Color secondary;
  late Color tertiary;
  late Color alternate;
  late Color primaryText;
  late Color secondaryText;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color accent1;
  late Color accent2;
  late Color accent3;
  late Color accent4;
  late Color success;
  late Color warning;
  late Color error;
  late Color info;
  //=====================================================

  @Deprecated('Use displaySmallFamily instead')
  String get greenFamily => greenSmallFamily;
  @Deprecated('Use displaySmallFamily instead')
  String get redFamily => redSmallFamily;
  @Deprecated('Use displaySmallFamily instead')
  String get orangeFamily => orangeSmallFamily;
  //=====================================================

  @Deprecated('Use displaySmallFamily instead')
  String get title1Family => displaySmallFamily;
  @Deprecated('Use displaySmall instead')
  TextStyle get title1 => typography.displaySmall;
  @Deprecated('Use headlineMediumFamily instead')
  String get title2Family => typography.headlineMediumFamily;
  @Deprecated('Use headlineMedium instead')
  TextStyle get title2 => typography.headlineMedium;
  @Deprecated('Use headlineSmallFamily instead')
  String get title3Family => typography.headlineSmallFamily;
  @Deprecated('Use headlineSmall instead')
  TextStyle get title3 => typography.headlineSmall;
  @Deprecated('Use titleMediumFamily instead')
  String get subtitle1Family => typography.titleMediumFamily;
  @Deprecated('Use titleMedium instead')
  TextStyle get subtitle1 => typography.titleMedium;
  @Deprecated('Use titleSmallFamily instead')
  String get subtitle2Family => typography.titleSmallFamily;
  @Deprecated('Use titleSmall instead')
  TextStyle get subtitle2 => typography.titleSmall;
  @Deprecated('Use bodyMediumFamily instead')
  String get bodyText1Family => typography.bodyMediumFamily;
  @Deprecated('Use bodyMedium instead')
  TextStyle get bodyText1 => typography.bodyMedium;
  @Deprecated('Use bodySmallFamily instead')
  String get bodyText2Family => typography.bodySmallFamily;
  @Deprecated('Use bodySmall instead')
  TextStyle get bodyText2 => typography.bodySmall;

  String get displayLargeFamily => typography.displayLargeFamily;
  TextStyle get displayLarge => typography.displayLarge;
  String get displayMediumFamily => typography.displayMediumFamily;
  TextStyle get displayMedium => typography.displayMedium;
  String get displaySmallFamily => typography.displaySmallFamily;
  TextStyle get displaySmall => typography.displaySmall;
  //=====================================================
  TextStyle get greenSmall => typography.greenSmall;
  String get greenSmallFamily => typography.greenSmallFamily;
  TextStyle get redSmall => typography.redSmall;
  String get redSmallFamily => typography.redSmallFamily;
  TextStyle get orangeSmall => typography.orangeSmall;
  String get orangeSmallFamily => typography.orangeSmallFamily;
  TextStyle get greySmall => typography.greySmall;
  String get greySmallFamily => typography.greySmallFamily;
  //=====================================================
  String get headlineLargeFamily => typography.headlineLargeFamily;
  TextStyle get headlineLarge => typography.headlineLarge;
  String get headlineMediumFamily => typography.headlineMediumFamily;
  TextStyle get headlineMedium => typography.headlineMedium;
  String get headlineSmallFamily => typography.headlineSmallFamily;
  TextStyle get headlineSmall => typography.headlineSmall;
  String get titleLargeFamily => typography.titleLargeFamily;
  TextStyle get titleLarge => typography.titleLarge;
  //=====================================================
  String get titleLargeFamilyFont => typography.titleLargeFontFamily;
  TextStyle get titleLargeFont => typography.titleLargeFont;
  //=======================================================
  String get titleMediumFamily => typography.titleMediumFamily;
  TextStyle get titleMedium => typography.titleMedium;
  String get titleSmallFamily => typography.titleSmallFamily;
  TextStyle get titleSmall => typography.titleSmall;
  String get labelLargeFamily => typography.labelLargeFamily;
  TextStyle get labelLarge => typography.labelLarge;
  String get labelMediumFamily => typography.labelMediumFamily;
  TextStyle get labelMedium => typography.labelMedium;
  String get labelSmallFamily => typography.labelSmallFamily;
  TextStyle get labelSmall => typography.labelSmall;
  String get bodyLargeFamily => typography.bodyLargeFamily;
  TextStyle get bodyLarge => typography.bodyLarge;
  String get bodyMediumFamily => typography.bodyMediumFamily;
  TextStyle get bodyMedium => typography.bodyMedium;

  TextStyle get bodyMediumWhite => typography.bodyMediumWhite;
  String get bodySmallFamily => typography.bodySmallFamily;

  TextStyle get bodySmall => typography.bodySmall;

  TextStyle get bodySmallRed => typography.bodySmallRed;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends FlutterFlowTheme {
  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary = const Color(0xFF4B39EF);
  late Color secondary = const Color(0xFF3498DB);
  late Color tertiary = const Color(0xFFEE8B60);
  late Color alternate = const Color(0xFF3A5287);
  late Color primaryText = const Color(0xFF14181B);
  late Color secondaryText = const Color(0xFF57636C);
  late Color primaryBackground = const Color(0xFFF1F4F8);
  late Color secondaryBackground = const Color(0xFFC4C4C4);
  late Color accent1 = const Color(0xFFD6D6D6);
  late Color accent2 = const Color(0xFFA4B6CD);
  late Color accent3 = const Color(0xFFCBCBCB);
  late Color accent4 = const Color(0xCCFFFFFF);
  late Color success = const Color(0xFF6BAA42);
  late Color warning = const Color(0xFFF9CF58);
  late Color error = const Color(0xFFFF5963);
  late Color info = const Color(0xFFFFFFFF);
}

abstract class Typography {
  String get displayLargeFamily;
  TextStyle get displayLarge;
  String get displayMediumFamily;
  TextStyle get displayMedium;
  String get displaySmallFamily;
  TextStyle get displaySmall;
  //=====================================================
  TextStyle get greenSmall;
  String get greenSmallFamily;
  TextStyle get redSmall;
  String get redSmallFamily;
  TextStyle get orangeSmall;
  String get orangeSmallFamily;
  TextStyle get greySmall;
  String get greySmallFamily;
  //=====================================================
  String get headlineLargeFamily;
  TextStyle get headlineLarge;
  String get headlineMediumFamily;
  TextStyle get headlineMedium;
  String get headlineSmallFamily;
  TextStyle get headlineSmall;
  String get titleLargeFamily;
  TextStyle get titleLarge;
  //======
  String get titleLargeFontFamily;
  TextStyle get titleLargeFont;
  //=========

  String get titleMediumFamily;
  TextStyle get titleMedium;
  String get titleSmallFamily;
  TextStyle get titleSmall;
  String get labelLargeFamily;
  TextStyle get labelLarge;
  String get labelMediumFamily;
  TextStyle get labelMedium;
  String get labelSmallFamily;
  TextStyle get labelSmall;
  String get bodyLargeFamily;
  TextStyle get bodyLarge;
  String get bodyMediumFamily;
  TextStyle get bodyMedium;
  TextStyle get bodyMediumWhite;
  String get bodySmallFamily;
  TextStyle get bodySmall;
  TextStyle get bodySmallRed;
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final FlutterFlowTheme theme;

  String get displayLargeFamily => 'Kanit';
  TextStyle get displayLarge => GoogleFonts.getFont(
        'Kanit',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 62.0,
      );
  String get displayMediumFamily => 'Kanit';
  TextStyle get displayMedium => GoogleFonts.getFont(
        'Kanit',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 42.0,
      );
  String get displaySmallFamily => 'Kanit';
  TextStyle get displaySmall => GoogleFonts.getFont(
        'Kanit',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 34.0,
      );

  //=====================================================
  String get greenSmallFamily => 'Kanit';
  TextStyle get greenSmall => GoogleFonts.getFont(
        'Kanit',
        color: Colors.green.shade900,
        // fontWeight: FontWeight.w600,
        fontSize: 12.0,
      );

  String get redSmallFamily => 'Kanit';
  TextStyle get redSmall => GoogleFonts.getFont(
        'Kanit',
        color: Colors.red.shade900,
        // fontWeight: FontWeight.w600,
        fontSize: 12.0,
      );

  String get orangeSmallFamily => 'Kanit';
  TextStyle get orangeSmall => GoogleFonts.getFont(
        'Kanit',
        color: Colors.deepOrange,
        // fontWeight: FontWeight.w600,
        fontSize: 12.0,
      );

  String get greySmallFamily => 'Kanit';
  TextStyle get greySmall => GoogleFonts.getFont(
        'Kanit',
        color: Colors.grey,
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
      );
  //=====================================================
  String get headlineLargeFamily => 'Kanit';
  TextStyle get headlineLarge => GoogleFonts.getFont(
        'Kanit',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 30.0,
      );
  String get headlineMediumFamily => 'Kanit';
  TextStyle get headlineMedium => GoogleFonts.getFont(
        'Kanit',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 22.0,
      );
  String get headlineSmallFamily => 'Kanit';
  TextStyle get headlineSmall => GoogleFonts.getFont(
        'Kanit',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 22.0,
      );
  String get titleLargeFamily => 'Kanit';
  TextStyle get titleLarge => GoogleFonts.getFont(
        'Kanit',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 20.0,
      );

  //=============
  String get titleLargeFontFamily => 'Kanit';
  TextStyle get titleLargeFont => GoogleFonts.getFont(
        'Kanit',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      );
  //=============
  String get titleMediumFamily => 'Kanit';
  TextStyle get titleMedium => GoogleFonts.getFont(
        'Kanit',
        color: theme.primaryBackground,
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
      );
  String get titleSmallFamily => 'Kanit';
  TextStyle get titleSmall => GoogleFonts.getFont(
        'Kanit',
        color: theme.primaryBackground,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      );
  String get labelLargeFamily => 'Kanit';
  TextStyle get labelLarge => GoogleFonts.getFont(
        'Kanit',
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
      );
  String get labelMediumFamily => 'Kanit';
  TextStyle get labelMedium => GoogleFonts.getFont(
        'Kanit',
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
      );
  String get labelSmallFamily => 'Kanit';
  TextStyle get labelSmall => GoogleFonts.getFont(
        'Kanit',
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 10.0,
      );
  String get bodyLargeFamily => 'Kanit';
  TextStyle get bodyLarge => GoogleFonts.getFont(
        'Kanit',
        color: theme.primaryBackground,
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
      );
  String get bodyMediumFamily => 'Kanit';
  TextStyle get bodyMedium => GoogleFonts.getFont(
        'Kanit',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
      );

  TextStyle get bodyMediumWhite => GoogleFonts.getFont(
        'Kanit',
        color: Colors.white,
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
      );
  String get bodySmallFamily => 'Kanit';
  TextStyle get bodySmall => GoogleFonts.getFont(
        'Kanit',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 10.0,
      );

  String get bodySmallRedFamily => 'Kanit';
  TextStyle get bodySmallRed => GoogleFonts.getFont(
        'Kanit',
        color: Colors.red,
        fontWeight: FontWeight.normal,
        fontSize: 10.0,
      );
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily!,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              letterSpacing: letterSpacing ?? this.letterSpacing,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              decoration: decoration,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              decoration: decoration,
              height: lineHeight,
            );
}
