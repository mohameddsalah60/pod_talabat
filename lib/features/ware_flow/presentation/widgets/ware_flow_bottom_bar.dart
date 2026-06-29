import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/utils/app_colors.dart';
import '../cubits/ware_flow_cubit.dart';
import '../cubits/ware_flow_state.dart';
import 'invoice_summary_card.dart';

class WareFlowBottomBar extends StatelessWidget {
  const WareFlowBottomBar({super.key});

  Future<void> _handleSave(
    BuildContext context,
    WareFlowSaveAction action,
    Future<bool> Function() saveAction,
  ) async {
    final cubit = context.read<WareFlowCubit>();
    final state = cubit.state;

    if (state.isSaving) return;

    if (state.hasInvalidItems) {
      _showSnackBar(
        context,
        'Please resolve invalid SKUs before submitting. '
        'Product not found entries must be corrected or removed.',
        AppColors.error,
      );
      return;
    }

    final hasPrintableItems = state.items.any(
      (item) => item.itemCode.trim().isNotEmpty,
    );

    if (!hasPrintableItems) {
      _showSnackBar(
        context,
        'Add at least one valid product before saving.',
        AppColors.warning,
      );
      return;
    }

    final success = await saveAction();

    if (!context.mounted) return;

    if (success) {
      final message = action == WareFlowSaveAction.print
          ? 'Invoice saved. Opening print preview…'
          : 'Draft saved successfully.';
      _showSnackBar(context, message, AppColors.success);
    } else {
      _showSnackBar(
        context,
        action == WareFlowSaveAction.print
            ? 'Failed to generate the invoice PDF. Please try again.'
            : 'Failed to save draft. Please try again.',
        AppColors.error,
      );
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WareFlowCubit, WareFlowState>(
      builder: (context, state) {
        final cubit = context.read<WareFlowCubit>();
        final isSavingDraft =
            state.isSaving && state.savingAction == WareFlowSaveAction.draft;
        final isSavingPrint =
            state.isSaving && state.savingAction == WareFlowSaveAction.print;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppBorderRadius.large.r),
            border: Border.all(color: AppColors.greyBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 14.w),
              _WareFlowActionButton(
                label: 'Save & Print',
                icon: Icons.print_rounded,
                isPrimary: true,
                isLoading: isSavingPrint,
                enabled: !state.isSaving,
                onPressed: () => _handleSave(
                  context,
                  WareFlowSaveAction.print,
                  cubit.saveAndPrint,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 300.w,
                child: InvoiceSummaryCard(
                  totalProducts: state.totalItems,
                  totalReceivedQuantity: state.totalReceivedQuantity,
                  totalQuantity: state.totalQuantity,
                  compact: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WareFlowActionButton extends StatefulWidget {
  const _WareFlowActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.isLoading,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final bool isLoading;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  State<_WareFlowActionButton> createState() => _WareFlowActionButtonState();
}

class _WareFlowActionButtonState extends State<_WareFlowActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    const height = 52.0;

    if (widget.isPrimary) {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: height.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            gradient: LinearGradient(
              colors: widget.enabled
                  ? [
                      const Color(0xFFFF8A1F),
                      _isHovered
                          ? const Color(0xFFFF5500)
                          : const Color(0xFFFF6B00),
                    ]
                  : [AppColors.greyBorder, AppColors.greyBorder],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: widget.enabled && _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primaryOrange.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : widget.enabled
                ? [
                    BoxShadow(
                      color: AppColors.primaryOrange.withValues(alpha: 0.22),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.enabled && !widget.isLoading
                  ? widget.onPressed
                  : null,
              borderRadius: BorderRadius.circular(14.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.isLoading)
                      SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    else
                      Icon(widget.icon, size: 18.sp, color: AppColors.white),
                    SizedBox(width: 10.w),
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: height.h,
        decoration: BoxDecoration(
          color: _isHovered && widget.enabled
              ? AppColors.orangeLight.withValues(alpha: 0.45)
              : AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: widget.enabled
                ? AppColors.primaryOrange.withValues(
                    alpha: _isHovered ? 0.55 : 0.35,
                  )
                : AppColors.greyBorder,
            width: 1.4,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.enabled && !widget.isLoading
                ? widget.onPressed
                : null,
            borderRadius: BorderRadius.circular(14.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.isLoading)
                    SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryOrange,
                      ),
                    )
                  else
                    Icon(
                      widget.icon,
                      size: 18.sp,
                      color: widget.enabled
                          ? AppColors.primaryOrange
                          : AppColors.textMuted,
                    ),
                  SizedBox(width: 10.w),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: widget.enabled
                          ? AppColors.primaryOrange
                          : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
