import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/utils/app_colors.dart';
import '../cubits/ware_flow_cubit.dart';
import '../cubits/ware_flow_state.dart';
import '../widgets/document_info_section.dart';
import '../widgets/items_table_section.dart';
import '../widgets/ware_flow_bottom_bar.dart';
import '../widgets/ware_flow_header.dart';
import '../widgets/ware_flow_hero_illustration.dart';

class WareFlowView extends StatelessWidget {
  const WareFlowView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WareFlowCubit(),
      child: const _WareFlowBody(),
    );
  }
}

class _WareFlowBody extends StatelessWidget {
  const _WareFlowBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wheitDark,
      body: Stack(
        children: [
          const _BackgroundDecorations(),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 32.h),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 1340.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WareFlowHeader(),
                      SizedBox(height: 40.h),
                      BlocBuilder<WareFlowCubit, WareFlowState>(
                        builder: (context, state) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _FormCard()),
                              SizedBox(width: 40.w),
                              Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: WareFlowHeroIllustration(
                                  totalProducts: state.totalItems,
                                  totalReceivedQuantity:
                                      state.totalReceivedQuantity,
                                  totalQuantity: state.totalQuantity,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 32.h),
                      const WareFlowBottomBar(),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(36.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.xLarge.r),
        border: Border.all(color: AppColors.greyBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DocumentInfoSection(),
          SectionDivider(),
          ItemsTableSection(),
        ],
      ),
    );
  }
}

class _BackgroundDecorations extends StatelessWidget {
  const _BackgroundDecorations();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.white,
                AppColors.wheitDark,
                AppColors.orangeLight.withValues(alpha: 0.15),
              ],
            ),
          ),
        ),
        Positioned(
          top: -80.h,
          right: -60.w,
          child: Container(
            width: 300.w,
            height: 300.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryOrange.withValues(alpha: 0.04),
            ),
          ),
        ),
        Positioned(
          bottom: -100.h,
          left: -80.w,
          child: Container(
            width: 400.w,
            height: 400.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryOrange.withValues(alpha: 0.03),
            ),
          ),
        ),
      ],
    );
  }
}
