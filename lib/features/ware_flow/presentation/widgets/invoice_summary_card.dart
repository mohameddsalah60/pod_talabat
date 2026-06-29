import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/utils/app_colors.dart';

class InvoiceSummaryCard extends StatelessWidget {
  const InvoiceSummaryCard({
    super.key,
    required this.totalProducts,
    required this.totalReceivedQuantity,
    required this.totalQuantity,
    this.compact = false,
  });

  final int totalProducts;
  final int totalReceivedQuantity;
  final int totalQuantity;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 20.w : 24.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.large.r),
        border: Border.all(color: AppColors.greyBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                color: AppColors.primaryOrange,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Invoice Summary',
                style: TextStyle(
                  fontSize: compact ? 15.sp : 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 16.h : 20.h),
          _SummaryRow(
            label: 'Total Products',
            value: totalProducts.toString(),
          ),
          SizedBox(height: 12.h),
          _SummaryRow(
            label: 'Total Received Quantity',
            value: totalReceivedQuantity.toString(),
          ),
          SizedBox(height: 12.h),
          _SummaryRow(
            label: 'Total Quantity',
            value: totalQuantity.toString(),
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: highlight ? AppColors.orangeLight : AppColors.wheitDark,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: highlight
                  ? AppColors.primaryOrange
                  : AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }
}
