import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/app_colors.dart';

class WareFlowHeader extends StatelessWidget {
  const WareFlowHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          'svg/talabat.svg',
          width: 200.w,
          height: 100.h,
          colorFilter: ColorFilter.mode(
            AppColors.primaryOrange,
            BlendMode.srcIn,
          ),
        ),

        SizedBox(height: 32.h),
        Text(
          'Create Transfer Invoice',
          style: TextStyle(
            fontSize: 36.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            letterSpacing: -1,
            height: 1.2,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Fill the details below to create a new warehouse transfer invoice.',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textMuted,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _LogoBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52.w,
      height: 52.w,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8A1F), Color(0xFFFF6B00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(
        Icons.local_shipping_rounded,
        color: AppColors.white,
        size: 28.sp,
      ),
    );
  }
}
