import 'package:flutter/material.dart';

final ThemeData dark = ThemeData(
  colorScheme: const ColorScheme(
    primary: Color(0xff12c2e9),
    primaryVariant: Color(0xff008fb6),
    secondary: Color(0xffc471ed),
    secondaryVariant: Color(0xfff64f59),
    surface: Color(0xffcdcbcd),
    background: Color(0xff303030),
    error: Color(0xffbd0930),
    onPrimary: Color(0xffffffff),
    onSecondary: Color(0xff000000),
    onSurface: Color(0xff000000),
    onBackground: Color(0xffffffff),
    onError: Color(0xffffffff),
    brightness: Brightness.dark,
  ),
  brightness: Brightness.dark,
  fontFamily: 'Odibee Sans Regular',
  dialogTheme: const DialogTheme(elevation: 12),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
