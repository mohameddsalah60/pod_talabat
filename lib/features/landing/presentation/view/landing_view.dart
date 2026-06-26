import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pod_talabat/features/core/routing/app_routes.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/scaffold_background.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});
  static const String routeName = '/landing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          const ScaffoldBackground(),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 720.w),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: GlassCard(
                  width: MediaQuery.sizeOf(context).width * 0.88,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'svg/talabat.svg',
                        width: 215.w,
                        colorFilter: ColorFilter.mode(
                          AppColors.primaryOrange,
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(
                        'Transfer Invoice System',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Create, search, and manage inventory transfer invoices effortlessly.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 26.h),
                      AppTextField(
                        hintText: 'Batch Number or Invoice Number',
                        prefixIcon: Icons.search_rounded,
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              height: 54,
                              label: 'Search',
                              onPressed: () {},
                              isPrimary: false,
                              icon: Icons.search_rounded,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: AppButton(
                              height: 54,
                              label: 'Create New Invoice',
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.createInvoice,
                                );
                              },
                              isPrimary: true,
                              icon: Icons.add_circle_outline,
                            ),
                          ),
                        ],
                      ),
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
