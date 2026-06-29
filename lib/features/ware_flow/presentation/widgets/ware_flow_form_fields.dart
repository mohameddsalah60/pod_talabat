import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/utils/app_colors.dart';

class WareFlowTextField extends StatefulWidget {
  const WareFlowTextField({
    super.key,
    required this.label,
    this.value,
    this.hintText,
    this.enabled = true,
    this.onChanged,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
  });

  final String label;
  final String? value;
  final String? hintText;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;

  @override
  State<WareFlowTextField> createState() => _WareFlowTextFieldState();
}

class _WareFlowTextFieldState extends State<WareFlowTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void didUpdateWidget(WareFlowTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _controller,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          style: TextStyle(
            fontSize: 14.sp,
            color: widget.enabled ? AppColors.textDark : AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
            suffixIcon: widget.suffixIcon,
            filled: true,
            fillColor: widget.enabled && !widget.readOnly
                ? AppColors.white
                : AppColors.wheitDark,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.medium.r),
              borderSide: const BorderSide(color: AppColors.greyBorder),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.medium.r),
              borderSide: BorderSide(
                color: AppColors.greyBorder.withValues(alpha: 0.8),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.medium.r),
              borderSide: const BorderSide(
                color: AppColors.primaryOrange,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class WareFlowDateField extends StatelessWidget {
  const WareFlowDateField({
    super.key,
    required this.label,
    required this.date,
    required this.onDateSelected,
  });

  final String label;
  final DateTime date;
  final ValueChanged<DateTime> onDateSelected;

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select Date',
      cancelText: 'Cancel',
      confirmText: 'Confirm',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryOrange,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.textDark,
            ),
            datePickerTheme: DatePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              headerBackgroundColor: AppColors.primaryOrange,
              headerForegroundColor: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onDateSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    final formatted =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    return WareFlowTextField(
      label: label,
      value: formatted,
      readOnly: true,
      onTap: () => _pickDate(context),
      suffixIcon: Icon(
        Icons.calendar_today_outlined,
        color: AppColors.primaryOrange,
        size: 20.sp,
      ),
    );
  }
}

class WareFlowTimeField extends StatelessWidget {
  const WareFlowTimeField({
    super.key,
    required this.label,
    required this.time,
    required this.onTimeSelected,
  });

  final String label;
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onTimeSelected;

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: time,
      helpText: 'Select Time',
      cancelText: 'Cancel',
      confirmText: 'Confirm',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryOrange,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.textDark,
            ),
            timePickerTheme: TimePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              dialHandColor: AppColors.primaryOrange,
              hourMinuteColor: AppColors.orangeLight,
              hourMinuteTextColor: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onTimeSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    final formatted =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return WareFlowTextField(
      label: label,
      value: formatted,
      readOnly: true,
      onTap: () => _pickTime(context),
      suffixIcon: Icon(
        Icons.access_time_outlined,
        color: AppColors.primaryOrange,
        size: 20.sp,
      ),
    );
  }
}

const double kTableCellHeight = 44;

InputDecoration tableCellDecoration({
  String? hintText,
  Color? fillColor,
  String? errorText,
  Widget? suffixIcon,
  Widget? prefixIcon,
  bool isWarning = false,
}) {
  final hasError = errorText != null && errorText.isNotEmpty;
  final borderColor = hasError
      ? (isWarning ? AppColors.warning : AppColors.error)
      : AppColors.greyBorder;

  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
    errorText: hasError ? errorText : null,
    errorStyle: TextStyle(
      fontSize: 11.sp,
      color: isWarning ? AppColors.warning : AppColors.error,
      height: 1.1,
    ),
    isDense: true,
    filled: true,
    fillColor: fillColor ?? AppColors.white,
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
    constraints: BoxConstraints(minHeight: kTableCellHeight.h),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(
        color: hasError
            ? (isWarning ? AppColors.warning : AppColors.error)
            : AppColors.primaryOrange,
        width: 1.5,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(
        color: isWarning ? AppColors.warning : AppColors.error,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(
        color: isWarning ? AppColors.warning : AppColors.error,
        width: 1.5,
      ),
    ),
  );
}
