import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_border_radius.dart';
import '../utils/app_colors.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child, this.padding, this.width});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppBorderRadius.xLarge.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: width,
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 28.w, vertical: 34.h),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(AppBorderRadius.xLarge.r),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.7),
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
