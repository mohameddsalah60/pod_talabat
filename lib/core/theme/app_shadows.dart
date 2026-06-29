import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static BoxShadow softOrange({Color? color}) {
    return BoxShadow(
      color: (color ?? Colors.orange).withValues(alpha: .12),
      blurRadius: 28,
      offset: const Offset(0, 18),
    );
  }
}
