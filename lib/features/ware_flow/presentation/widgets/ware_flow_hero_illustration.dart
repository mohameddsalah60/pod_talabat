import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/utils/app_colors.dart';
import 'invoice_summary_card.dart';

class WareFlowHeroIllustration extends StatelessWidget {
  const WareFlowHeroIllustration({
    super.key,
    required this.totalProducts,
    required this.totalReceivedQuantity,
    required this.totalQuantity,
  });

  final int totalProducts;
  final int totalReceivedQuantity;
  final int totalQuantity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 320.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.orangeLight,
                  AppColors.orangeLight.withValues(alpha: 0.4),
                  AppColors.white,
                ],
              ),
              borderRadius: BorderRadius.circular(AppBorderRadius.xLarge.r),
              border: Border.all(
                color: AppColors.primaryOrange.withValues(alpha: 0.12),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 40.h,
                  right: 40.w,
                  child: _IconBubble(
                    icon: Icons.inventory_2_outlined,
                    size: 56,
                  ),
                ),
                Positioned(
                  top: 100.h,
                  left: 48.w,
                  child: _IconBubble(
                    icon: Icons.assignment_outlined,
                    size: 48,
                  ),
                ),
                Positioned(
                  bottom: 80.h,
                  right: 60.w,
                  child: _IconBubble(
                    icon: Icons.qr_code_scanner_outlined,
                    size: 44,
                  ),
                ),
                Positioned(
                  bottom: 60.h,
                  left: 70.w,
                  child: _IconBubble(
                    icon: Icons.local_shipping_outlined,
                    size: 52,
                  ),
                ),
                Center(
                  child: Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryOrange.withValues(alpha: 0.15),
                          blurRadius: 32,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.warehouse_outlined,
                      size: 56.sp,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -20.h,
            left: 24.w,
            right: 24.w,
            child: InvoiceSummaryCard(
              totalProducts: totalProducts,
              totalReceivedQuantity: totalReceivedQuantity,
              totalQuantity: totalQuantity,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, required this.size});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (size + 24).w,
      height: (size + 24).w,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primaryOrange.withValues(alpha: 0.15),
        ),
      ),
      child: Icon(
        icon,
        size: size.sp,
        color: AppColors.primaryOrange.withValues(alpha: 0.7),
      ),
    );
  }
}
