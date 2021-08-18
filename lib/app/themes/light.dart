import 'package:flutter/material.dart';

final ThemeData light = ThemeData(
  colorScheme: const ColorScheme(
    primary: Color(0xffc471ed),
    secondary: Color(0xff12c2e9),
    primaryVariant: Color(0xff008fb6),
    secondaryVariant: Color(0xfff64f59),
    surface: Color(0xff424242),
    background: Color(0xffffffff),
    error: Color(0xffbd0930),
    onPrimary: Color(0xff000000),
    onSecondary: Color(0xffffffff),
    onSurface: Color(0xffffffff),
    onBackground: Color(0xff000000),
    onError: Color(0xff000000),
    brightness: Brightness.light,
  ),
  brightness: Brightness.light,
  fontFamily: 'Odibee Sans Regular',
  dialogTheme: const DialogTheme(elevation: 12),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
