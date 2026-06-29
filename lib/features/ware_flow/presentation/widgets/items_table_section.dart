import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/utils/app_colors.dart';
import '../../data/models/transfer_invoice_item.dart';
import '../cubits/ware_flow_cubit.dart';
import '../cubits/ware_flow_state.dart';
import 'quantity_stepper.dart';
import 'section_header.dart';
import 'ware_flow_form_fields.dart';

class ItemsTableSection extends StatelessWidget {
  const ItemsTableSection({super.key});

  static const _columnFlex = [2, 3, 2, 2, 2, 2, 1];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WareFlowCubit, WareFlowState>(
      builder: (context, state) {
        final cubit = context.read<WareFlowCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(icon: Icons.inventory_outlined, title: 'Items'),
            if (state.isCatalogLoading) ...[
              SizedBox(height: 12.h),
              _CatalogLoadingBanner(),
            ],
            if (state.catalogLoadError != null) ...[
              SizedBox(height: 12.h),
              _CatalogErrorBanner(message: state.catalogLoadError!),
            ],
            SizedBox(height: 24.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppBorderRadius.medium.r),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyBorder),
                  borderRadius: BorderRadius.circular(AppBorderRadius.medium.r),
                ),
                child: Column(
                  children: [
                    const _TableHeader(),
                    if (state.items.isEmpty)
                      const _EmptyTableState()
                    else
                      ...state.items.asMap().entries.map(
                        (entry) => _ItemTableRow(
                          key: ValueKey(entry.value.id),
                          index: entry.key + 1,
                          item: entry.value,
                          catalogReady: state.isCatalogReady,
                          isHighlighted:
                              state.highlightedItemId == entry.value.id,
                          onItemCodeChanged: (v) =>
                              cubit.onItemCodeChanged(entry.value.id, v),
                          onItemCodeSubmitted: (v) =>
                              cubit.onItemCodeSubmitted(entry.value.id, v),
                          onItemCodeUnfocused: (v) =>
                              cubit.lookupProduct(entry.value.id, v.trim()),
                          onProductNameChanged: (v) =>
                              cubit.updateProductName(entry.value.id, v),
                          onReceivedQuantityChanged: (v) =>
                              cubit.updateReceivedQuantity(entry.value.id, v),
                          onBarcodeChanged: (v) =>
                              cubit.updateBarcode(entry.value.id, v),
                          onQuantityChanged: (v) =>
                              cubit.updateItemQuantity(entry.value.id, v),
                          onCommentChanged: (v) =>
                              cubit.updateItemComment(entry.value.id, v),
                          onCustomCommentChanged: (v) =>
                              cubit.updateCustomComment(entry.value.id, v),
                          onDelete: () => cubit.removeItem(entry.value.id),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            _AddItemButton(onPressed: cubit.addItem),
          ],
        );
      },
    );
  }
}

class _CatalogLoadingBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.orangeLight,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.primaryOrange.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 16.w,
            height: 16.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryOrange,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            'Loading product catalog...',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogErrorBanner extends StatelessWidget {
  const _CatalogErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 13.sp, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  static const _headers = [
    'SKU',
    'Product Name',
    'Received Quantity',
    'Quantity',
    'Barcode',
    'Comment',
    'Actions',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF8A1F), Color(0xFFFF6B00)],
        ),
      ),
      child: Row(
        children: [
          for (var i = 0; i < _headers.length; i++) ...[
            if (i > 0) SizedBox(width: 12.w),
            _HeaderCell(
              _headers[i],
              flex: ItemsTableSection._columnFlex[i],
              align: i == _headers.length - 1
                  ? TextAlign.center
                  : TextAlign.start,
            ),
          ],
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(
    this.text, {
    required this.flex,
    this.align = TextAlign.start,
  });

  final String text;
  final int flex;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _ItemTableRow extends StatefulWidget {
  const _ItemTableRow({
    super.key,
    required this.index,
    required this.item,
    required this.catalogReady,
    required this.isHighlighted,
    required this.onItemCodeChanged,
    required this.onItemCodeSubmitted,
    required this.onItemCodeUnfocused,
    required this.onProductNameChanged,
    required this.onReceivedQuantityChanged,
    required this.onBarcodeChanged,
    required this.onQuantityChanged,
    required this.onCommentChanged,
    required this.onCustomCommentChanged,
    required this.onDelete,
  });

  final int index;
  final TransferInvoiceItem item;
  final bool catalogReady;
  final bool isHighlighted;
  final ValueChanged<String> onItemCodeChanged;
  final ValueChanged<String> onItemCodeSubmitted;
  final ValueChanged<String> onItemCodeUnfocused;
  final ValueChanged<String> onProductNameChanged;
  final ValueChanged<String> onReceivedQuantityChanged;
  final ValueChanged<String> onBarcodeChanged;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<String?> onCommentChanged;
  final ValueChanged<String> onCustomCommentChanged;
  final VoidCallback onDelete;

  @override
  State<_ItemTableRow> createState() => _ItemTableRowState();
}

class _ItemTableRowState extends State<_ItemTableRow> {
  late TextEditingController _itemCodeController;
  late TextEditingController _productNameController;
  late TextEditingController _receivedQuantityController;
  late TextEditingController _barcodeController;
  late FocusNode _itemCodeFocusNode;
  late FocusNode _productNameFocusNode;
  late FocusNode _receivedQuantityFocusNode;
  late FocusNode _barcodeFocusNode;

  @override
  void initState() {
    super.initState();
    _itemCodeController = TextEditingController(text: widget.item.itemCode);
    _productNameController = TextEditingController(
      text: widget.item.productName,
    );
    _receivedQuantityController = TextEditingController(
      text: widget.item.receivedQuantity == 0
          ? ''
          : widget.item.receivedQuantity.toString(),
    );
    _barcodeController = TextEditingController(text: widget.item.barcode);
    _itemCodeFocusNode = FocusNode();
    _productNameFocusNode = FocusNode();
    _receivedQuantityFocusNode = FocusNode();
    _barcodeFocusNode = FocusNode();
    _itemCodeFocusNode.addListener(_onItemCodeFocusChanged);
  }

  void _onItemCodeFocusChanged() {
    if (!_itemCodeFocusNode.hasFocus) {
      widget.onItemCodeUnfocused(_itemCodeController.text);
    }
  }

  @override
  void didUpdateWidget(_ItemTableRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id) {
      _syncControllersFromItem();
      return;
    }

    if (oldWidget.item.lookupStatus != widget.item.lookupStatus &&
        widget.item.lookupStatus == ItemLookupStatus.found) {
      _productNameController.text = widget.item.productName;
      _barcodeController.text = widget.item.barcode;
    }

    if (oldWidget.item.itemCode != widget.item.itemCode &&
        _itemCodeController.text != widget.item.itemCode &&
        !_itemCodeFocusNode.hasFocus) {
      _itemCodeController.text = widget.item.itemCode;
    }

    if (oldWidget.item.productName != widget.item.productName &&
        _productNameController.text != widget.item.productName &&
        !_productNameFocusNode.hasFocus) {
      _productNameController.text = widget.item.productName;
    }

    if (oldWidget.item.receivedQuantity != widget.item.receivedQuantity &&
        !_receivedQuantityFocusNode.hasFocus) {
      _receivedQuantityController.text = widget.item.receivedQuantity == 0
          ? ''
          : widget.item.receivedQuantity.toString();
    }

    if (oldWidget.item.barcode != widget.item.barcode &&
        _barcodeController.text != widget.item.barcode &&
        !_barcodeFocusNode.hasFocus) {
      _barcodeController.text = widget.item.barcode;
    }

    if (widget.item.lookupStatus == ItemLookupStatus.duplicate &&
        oldWidget.item.lookupStatus != ItemLookupStatus.duplicate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _itemCodeFocusNode.requestFocus();
      });
    }
  }

  void _syncControllersFromItem() {
    _itemCodeController.text = widget.item.itemCode;
    _productNameController.text = widget.item.productName;
    _receivedQuantityController.text = widget.item.receivedQuantity == 0
        ? ''
        : widget.item.receivedQuantity.toString();
    _barcodeController.text = widget.item.barcode;
  }

  @override
  void dispose() {
    _itemCodeFocusNode.removeListener(_onItemCodeFocusChanged);
    _itemCodeFocusNode.dispose();
    _productNameFocusNode.dispose();
    _receivedQuantityFocusNode.dispose();
    _barcodeFocusNode.dispose();
    _itemCodeController.dispose();
    _productNameController.dispose();
    _receivedQuantityController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  bool get _isSkuLoading =>
      widget.item.lookupStatus == ItemLookupStatus.loading;

  bool get _isProductFound => widget.item.lookupStatus == ItemLookupStatus.found;

  bool get _isDuplicate =>
      widget.item.lookupStatus == ItemLookupStatus.duplicate;

  @override
  Widget build(BuildContext context) {
    final baseRowColor =
        widget.index.isEven ? AppColors.white : AppColors.wheitDark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: widget.isHighlighted
            ? AppColors.orangeLight.withValues(alpha: 0.65)
            : (_isProductFound
                  ? AppColors.success.withValues(alpha: 0.04)
                  : baseRowColor),
        border: Border(
          top: const BorderSide(color: AppColors.greyBorder),
          left: BorderSide(
            color: widget.isHighlighted
                ? AppColors.primaryOrange
                : (_isProductFound
                      ? AppColors.success.withValues(alpha: 0.45)
                      : Colors.transparent),
            width: widget.isHighlighted || _isProductFound ? 3 : 0,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TableCell(
            flex: ItemsTableSection._columnFlex[0],
            child: _TableTextField(
              controller: _itemCodeController,
              focusNode: _itemCodeFocusNode,
              hintText: 'Item SKU',
              enabled: widget.catalogReady,
              isLoading: _isSkuLoading,
              isSuccess: _isProductFound,
              isWarning: _isDuplicate,
              errorText: widget.item.lookupError,
              onChanged: widget.onItemCodeChanged,
              onSubmitted: widget.onItemCodeSubmitted,
            ),
          ),
          _TableCell(
            flex: ItemsTableSection._columnFlex[1],
            child: _TableTextField(
              controller: _productNameController,
              focusNode: _productNameFocusNode,
              hintText: 'Product name',
              isSuccess: _isProductFound,
              onChanged: widget.onProductNameChanged,
            ),
          ),
          _TableCell(
            flex: ItemsTableSection._columnFlex[2],
            child: _TableTextField(
              controller: _receivedQuantityController,
              focusNode: _receivedQuantityFocusNode,
              hintText: '0',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: widget.onReceivedQuantityChanged,
            ),
          ),
          _TableCell(
            flex: ItemsTableSection._columnFlex[3],
            child: Padding(
              padding: EdgeInsets.only(top: 0),
              child: QuantityStepper(
                quantity: widget.item.quantity,
                onChanged: widget.onQuantityChanged,
              ),
            ),
          ),
          _TableCell(
            flex: ItemsTableSection._columnFlex[4],
            child: _TableTextField(
              controller: _barcodeController,
              focusNode: _barcodeFocusNode,
              hintText: 'Barcode',
              monospace: true,
              isSuccess: _isProductFound,
              onChanged: widget.onBarcodeChanged,
            ),
          ),
          _TableCell(
            flex: ItemsTableSection._columnFlex[5],
            child: _TableCommentField(
              comment: widget.item.comment,
              customComment: widget.item.customComment,
              onCommentChanged: widget.onCommentChanged,
              onCustomCommentChanged: widget.onCustomCommentChanged,
            ),
          ),
          _TableCell(
            flex: ItemsTableSection._columnFlex[6],
            isLast: true,
            child: Center(
              child: IconButton(
                onPressed: widget.onDelete,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: 40.w,
                  minHeight: kTableCellHeight.h,
                ),
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                  size: 22.sp,
                ),
                tooltip: 'Remove item',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({
    required this.flex,
    required this.child,
    this.isLast = false,
  });

  final int flex;
  final Widget child;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.only(right: isLast ? 0 : 12.w),
        child: child,
      ),
    );
  }
}

class _TableTextField extends StatelessWidget {
  const _TableTextField({
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.isLoading = false,
    this.isSuccess = false,
    this.isWarning = false,
    this.errorText,
    this.monospace = false,
    this.keyboardType,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool enabled;
  final bool isLoading;
  final bool isSuccess;
  final bool isWarning;
  final String? errorText;
  final bool monospace;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: 1,
      textInputAction: onSubmitted != null ? TextInputAction.done : null,
      decoration: tableCellDecoration(
        hintText: hintText,
        fillColor: isSuccess
            ? AppColors.success.withValues(alpha: 0.06)
            : AppColors.white,
        errorText: errorText,
        isWarning: isWarning,
        suffixIcon: _buildSuffixIcon(),
      ),
      style: TextStyle(
        fontSize: 13.sp,
        color: AppColors.textDark,
        fontFamily: monospace ? 'monospace' : null,
        fontWeight: isSuccess ? FontWeight.w500 : FontWeight.w400,
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (isLoading) {
      return Padding(
        padding: EdgeInsets.all(12.w),
        child: SizedBox(
          width: 16.w,
          height: 16.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryOrange,
          ),
        ),
      );
    }

    if (isSuccess) {
      return Padding(
        padding: EdgeInsets.only(right: 10.w),
        child: Icon(
          Icons.check_circle_outline,
          size: 16.sp,
          color: AppColors.success,
        ),
      );
    }

    return null;
  }
}

class _TableCommentField extends StatefulWidget {
  const _TableCommentField({
    required this.comment,
    required this.customComment,
    required this.onCommentChanged,
    required this.onCustomCommentChanged,
  });

  final String? comment;
  final String? customComment;
  final ValueChanged<String?> onCommentChanged;
  final ValueChanged<String> onCustomCommentChanged;

  @override
  State<_TableCommentField> createState() => _TableCommentFieldState();
}

class _TableCommentFieldState extends State<_TableCommentField> {
  late TextEditingController _customCommentController;

  @override
  void initState() {
    super.initState();
    _customCommentController = TextEditingController(
      text: widget.customComment ?? '',
    );
  }

  @override
  void didUpdateWidget(_TableCommentField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.customComment != oldWidget.customComment &&
        _customCommentController.text != (widget.customComment ?? '')) {
      _customCommentController.text = widget.customComment ?? '';
    }
  }

  @override
  void dispose() {
    _customCommentController.dispose();
    super.dispose();
  }

  bool get _showCustomField => widget.comment == ItemCommentOptions.other;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: kTableCellHeight.h,
          child: DropdownButtonFormField<String>(
            key: ValueKey(widget.comment),
            initialValue: widget.comment,
            hint: Text(
              'Select',
              style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
            ),
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primaryOrange,
              size: 20.sp,
            ),
            decoration: tableCellDecoration(),
            items: ItemCommentOptions.values
                .map(
                  (option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textDark,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: widget.onCommentChanged,
          ),
        ),
        if (_showCustomField) ...[
          SizedBox(height: 8.h),
          TextField(
            controller: _customCommentController,
            onChanged: widget.onCustomCommentChanged,
            maxLines: 1,
            decoration: tableCellDecoration(hintText: 'Enter custom comment'),
            style: TextStyle(fontSize: 12.sp, color: AppColors.textDark),
          ),
        ],
      ],
    );
  }
}

class _EmptyTableState extends StatelessWidget {
  const _EmptyTableState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40.w),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 48.sp, color: AppColors.textMuted),
          SizedBox(height: 12.h),
          Text(
            'No items added yet',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _AddItemButton extends StatelessWidget {
  const _AddItemButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppBorderRadius.medium.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadius.medium.r),
          border: Border.all(
            color: AppColors.primaryOrange.withValues(alpha: 0.4),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          color: AppColors.orangeLight.withValues(alpha: 0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: AppColors.primaryOrange,
              size: 22.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Add Another Item',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
