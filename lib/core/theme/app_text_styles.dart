import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle title() => TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    letterSpacing: -0.5,
  );

  static TextStyle subtitle() =>
      TextStyle(fontSize: 15.sp, color: AppColors.textMuted, height: 1.5);

  static TextStyle buttonText() =>
      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600);
}
