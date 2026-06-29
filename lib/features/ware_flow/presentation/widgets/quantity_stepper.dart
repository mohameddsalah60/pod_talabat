import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/utils/app_colors.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.minQuantity = 1,
    this.maxQuantity = 999999,
  });

  final int quantity;
  final ValueChanged<int> onChanged;
  final int minQuantity;
  final int maxQuantity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyBorder),
          borderRadius: BorderRadius.circular(AppBorderRadius.small.r),
          color: AppColors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _StepperButton(
              icon: Icons.remove,
              enabled: quantity > minQuantity,
              onPressed: () => onChanged(quantity - 1),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border.symmetric(
                    vertical: BorderSide(color: AppColors.greyBorder),
                  ),
                ),
                child: Text(
                  quantity.toString(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ),
            _StepperButton(
              icon: Icons.add,
              enabled: quantity < maxQuantity,
              onPressed: () => onChanged(quantity + 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.w,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(AppBorderRadius.small.r),
        child: Center(
          child: Icon(
            icon,
            size: 18.sp,
            color: enabled ? AppColors.primaryOrange : AppColors.greyDark,
          ),
        ),
      ),
    );
  }
}
