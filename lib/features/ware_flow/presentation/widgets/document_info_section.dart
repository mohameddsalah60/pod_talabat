import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../cubits/ware_flow_cubit.dart';
import '../cubits/ware_flow_state.dart';
import 'section_header.dart';
import 'ware_flow_form_fields.dart';

class DocumentInfoSection extends StatelessWidget {
  const DocumentInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WareFlowCubit, WareFlowState>(
      builder: (context, state) {
        final cubit = context.read<WareFlowCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              icon: Icons.description_outlined,
              title: 'Document Info',
            ),
            SizedBox(height: 24.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: WareFlowTextField(
                    label: 'Batch ID',
                    value: state.batchId,
                    hintText: 'Enter batch ID',
                    onChanged: cubit.updateBatchId,
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: WareFlowTextField(
                    label: 'Store',
                    value: state.store,
                    hintText: 'Enter store code',
                    onChanged: cubit.updateStore,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: WareFlowTextField(
                    label: 'Created By',
                    value: state.submittedBy,
                    hintText: 'Enter your name',
                    onChanged: cubit.updateSubmittedBy,
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: WareFlowDateField(
                    label: 'Date',
                    date: state.shipDate,
                    onDateSelected: cubit.updateShipDate,
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: WareFlowTimeField(
                    label: 'Time',
                    time: state.shipTime,
                    onTimeSelected: cubit.updateShipTime,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Divider(color: AppColors.greyBorder, height: 1),
    );
  }
}
