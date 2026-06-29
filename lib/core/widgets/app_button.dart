import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_border_radius.dart';
import '../utils/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
    this.height = 56,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final IconData? icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final style = isPrimary
        ? FilledButton.styleFrom(
            foregroundColor: AppColors.white,
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: (height / 2 - 8).h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.medium.r),
            ),
            elevation: 0,
          )
        : OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryOrange,
            padding: EdgeInsets.symmetric(vertical: (height / 2 - 8).h),
            side: BorderSide(
              color: AppColors.primaryOrange.withValues(alpha: 0.35),
              width: 1.2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.medium.r),
            ),
          );

    if (isPrimary) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadius.medium.r),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8A1F), Color(0xFFFF6B00)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        height: height.h,
        child: FilledButton(
          onPressed: onPressed,
          style: style,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18.sp),
                SizedBox(width: 8.w),
              ],
              Text(
                label,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: height.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18.sp),
              SizedBox(width: 8.w),
            ],
            Text(
              label,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
