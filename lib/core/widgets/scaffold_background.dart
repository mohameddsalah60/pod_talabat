import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class ScaffoldBackground extends StatelessWidget {
  const ScaffoldBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF4E8), Color(0xFFFFFFFF), Color(0xFFFFEEE0)],
            ),
          ),
        ),
        Positioned(
          top: -60.h,
          right: -40.w,
          child: Container(
            width: 260.w,
            height: 260.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryOrange.withValues(alpha: 0.16),
            ),
          ),
        ),
        Positioned(
          bottom: -90.h,
          left: -100.w,
          child: Container(
            width: 320.w,
            height: 320.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryOrange.withValues(alpha: 0.08),
            ),
          ),
        ),
        Positioned(
          top: 140.h,
          left: 80.w,
          child: Icon(
            Icons.qr_code_2_outlined,
            size: 84.sp,
            color: AppColors.primaryOrange.withValues(alpha: 0.18),
          ),
        ),
        Positioned(
          bottom: 140.h,
          right: 90.w,
          child: Icon(
            Icons.inventory_2_outlined,
            size: 88.sp,
            color: AppColors.primaryOrange.withValues(alpha: 0.16),
          ),
        ),
        Positioned(
          top: 260.h,
          right: 150.w,
          child: Icon(
            Icons.local_shipping_outlined,
            size: 72.sp,
            color: AppColors.primaryOrange.withValues(alpha: 0.14),
          ),
        ),
      ],
    );
  }
}
