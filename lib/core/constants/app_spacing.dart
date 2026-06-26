import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
}

class AppPaddings {
  AppPaddings._();

  static const EdgeInsetsGeometry screen = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
    vertical: AppSpacing.lg,
  );

  static const EdgeInsetsGeometry card = EdgeInsets.symmetric(
    horizontal: AppSpacing.xl,
    vertical: AppSpacing.xl,
  );
}
