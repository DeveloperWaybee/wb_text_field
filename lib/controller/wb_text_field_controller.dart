import 'package:flutter/material.dart';

class WBTextFieldController {
  WBTextFieldController({
    // Text Field
    TextEditingController? controller,
    FocusNode? focusNode,
    this.initialText,
    this.label,
    this.hint = "Bhavneet Singh",
    this.padding,
    Border? border,
    BorderRadius? borderRadius,
    this.style,
    this.labelStyle,
    this.hintStyle,
    Border? focusBorder,
    this.focusStyle,
    this.focusLabelStyle,
    this.focusHintStyle,
    this.error,
    this.errorBorderOnly = false,
    Border? errorBorder,
    this.errorStyle,
    this.errorLabelStyle,
    this.errorHintStyle,
    this.suffix,
    this.suffixColor = const Color(0x00000000),
    this.suffixAction,
    this.isClearEnable = true,
    this.textInputType,
    this.returnKeyType,
    this.maxLength,
    this.maxLines,
    this.enabled,
    this.didChange,
    this.onSaved,
    this.onEditingComplete,
    this.onFieldSubmitted,
    // Text Field
    // Date Time Picker
    this.datePicker,
    this.timePicker,
    this.didSelectDateTime,
    // Date Time Picker
    // Options Selection with Search
    this.enableItemSearch,
    this.itemBuilderMaxHeight = 200,
    this.itemBuilderHeader,
    this.itemBuilderHeaderTapped,
    // this.items,
    this.itemsSeparator,
    this.itemDidSelect,
    // Options Selection with Search
  }) {
    editingController = controller ?? TextEditingController(text: initialText);
    this.focusNode = (focusNode ?? FocusNode());
    this.border = border ?? Border.all(color: Colors.grey);
    this.borderRadius = borderRadius ?? BorderRadius.circular(10);
    this.focusBorder = focusBorder ?? Border.all(color: Colors.blue);
    this.errorBorder = errorBorder ?? Border.all(color: Colors.red);
  }

  late final TextEditingController editingController;
  late final FocusNode focusNode;
  final String? initialText;
  final String? label;
  final String? hint;
  final EdgeInsets? padding;
  late Border border;
  late BorderRadius borderRadius;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  late Border focusBorder;
  final TextStyle? focusLabelStyle;
  final TextStyle? focusHintStyle;
  final TextStyle? focusStyle;
  final String? error;
  final bool errorBorderOnly;
  late Border errorBorder;
  final TextStyle? errorLabelStyle;
  final TextStyle? errorHintStyle;
  final TextStyle? errorStyle;
  final IconData? suffix;
  final Color suffixColor;
  final void Function(String text)? suffixAction;
  final bool isClearEnable;
  final TextInputType? textInputType;
  final TextInputAction? returnKeyType;
  final int? maxLength;
  final int? maxLines;
  final bool? enabled;
  final void Function(String text)? didChange;
  final void Function(String?)? onSaved;
  final void Function(String)? onEditingComplete;
  void Function(String?)? onFieldSubmitted;

  // -- Date Picker
  final bool? datePicker;
  final bool? timePicker;
  final String Function(DateTime? date, TimeOfDay? time)? didSelectDateTime;
  // -- Date Picker

  // -- Drop Down
  final bool? enableItemSearch;
  final double itemBuilderMaxHeight;
  final Widget? itemBuilderHeader;
  final Future<void> Function()? itemBuilderHeaderTapped;
  // final List<WBTextFieldOption>? items;
  final Widget? itemsSeparator;
  final Future<String> Function(String id)? itemDidSelect;
  // -- Drop Down
}