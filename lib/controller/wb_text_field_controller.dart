import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wb_text_field/config/wb_text_field_default_config.dart';
import 'package:wb_text_field/models/wb_text_field_option.dart';

class WBTextFieldController {
  static WBTextFieldDefaultConfig config = WBTextFieldDefaultConfig(
    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
    border: Border.all(color: const Color(0xFFE9E9E9)),
    borderRadius: BorderRadius.circular(8),
    style: const TextStyle(
      fontSize: 16,
      color: Color(0xFF242424),
    ),
    labelStyle: const TextStyle(
      color: Color(0xFF9A9A9A),
      fontSize: 14,
    ),
    hintStyle: const TextStyle(
      color: Color(0xFF9A9A9A),
      fontSize: 14,
    ),
    focusBorder: Border.all(color: const Color(0xFF0076BC)),
    focusStyle: const TextStyle(
      fontSize: 16,
      color: Color(0xFF242424),
    ),
    focusLabelStyle: const TextStyle(
      color: Color(0xFF0076BC),
      fontSize: 14,
    ),
    focusHintStyle: const TextStyle(
      color: Color(0xFF9A9A9A),
      fontSize: 14,
    ),
    errorBorderOnly: true,
    errorBorder: Border.all(color: const Color(0xFFEF4444)),
    errorStyle: const TextStyle(
      fontSize: 16,
      color: Color(0xFFEF4444),
    ),
    errorLabelStyle: const TextStyle(
      color: Color(0xFFEF4444),
      fontSize: 14,
    ),
    errorHintStyle: const TextStyle(
      color: Color(0xFFEF4444),
      fontSize: 14,
    ),
    maxLines: 1,
    maxLength: 200,
    obscureText: false,
    obscuringCharacter: "*",
    textCapitalization: TextCapitalization.words,
    isClearEnable: true,
    clearButtonColor: const Color(0xFF9A9A9A),
    clearVisibilityAlways: false,
    suffixColor: const Color(0xFF9A9A9A),
    currentDate: DateTime.now(),
    initialDate: DateTime.now(),
    firstDate: DateTime.now().copyWith(year: 1900),
    lastDate: DateTime.now().copyWith(year: 2100),
    initialTime: TimeOfDay.now(),
    itemBuilderMaxHeight: 200,
  );

  WBTextFieldController({
    // Text Field
    TextEditingController? controller,
    FocusNode? focusNode,
    this.initialText,
    this.label,
    this.hint,
    EdgeInsets? padding,
    Border? border,
    BorderRadius? borderRadius,
    TextStyle? style,
    TextStyle? labelStyle,
    TextStyle? hintStyle,
    Border? focusBorder,
    TextStyle? focusStyle,
    TextStyle? focusLabelStyle,
    TextStyle? focusHintStyle,
    this.error,
    bool? errorBorderOnly,
    Border? errorBorder,
    TextStyle? errorStyle,
    TextStyle? errorLabelStyle,
    TextStyle? errorHintStyle,
    this.suffix,
    Color? suffixColor,
    this.suffixAction,
    bool? isClearEnable,
    bool? clearVisibilityAlways,
    Color? clearButtonColor,
    this.textInputType,
    this.returnKeyType,
    int? maxLength,
    int? maxLines,
    this.enabled,
    bool? obscureText,
    String? obscuringCharacter,
    TextCapitalization? textCapitalization,
    TextInputFormatFunction? inputFormatter,
    this.didChange,
    this.onSaved,
    this.onEditingComplete,
    this.onFieldSubmitted,
    // Text Field
    // Date Time Picker
    this.datePicker,
    DateTime? initialDate,
    DateTime? currentDate,
    DateTime? firstDate,
    DateTime? lastDate,
    this.timePicker,
    TimeOfDay? initialTime,
    this.didSelectDateTime,
    // Date Time Picker
    // Options Selection with Search
    this.enableItemSearch,
    double? itemBuilderMaxHeight,
    this.itemBuilderHeader,
    this.itemBuilderHeaderTapped,
    this.items,
    this.itemsSeparator,
    this.itemDidSelect,
    // Options Selection with Search
  }) {
    editingController = controller ?? TextEditingController(text: initialText);
    this.focusNode = (focusNode ?? FocusNode());
    this.padding = padding ?? WBTextFieldController.config.padding;
    this.border = border ?? WBTextFieldController.config.border;
    this.borderRadius =
        borderRadius ?? WBTextFieldController.config.borderRadius;
    this.style = style ?? WBTextFieldController.config.style;
    this.labelStyle = labelStyle ?? WBTextFieldController.config.labelStyle;
    this.hintStyle = hintStyle ?? WBTextFieldController.config.hintStyle;
    this.focusBorder = focusBorder ?? WBTextFieldController.config.focusBorder;
    this.focusLabelStyle =
        focusLabelStyle ?? WBTextFieldController.config.focusLabelStyle;
    this.focusHintStyle =
        focusHintStyle ?? WBTextFieldController.config.focusHintStyle;
    this.focusStyle = focusStyle ?? WBTextFieldController.config.focusStyle;
    this.errorBorderOnly =
        errorBorderOnly ?? WBTextFieldController.config.errorBorderOnly;
    this.errorBorder = errorBorder ?? WBTextFieldController.config.errorBorder;
    this.errorLabelStyle =
        errorLabelStyle ?? WBTextFieldController.config.errorLabelStyle;
    this.errorHintStyle =
        errorHintStyle ?? WBTextFieldController.config.errorHintStyle;
    this.errorStyle = errorStyle ?? WBTextFieldController.config.errorStyle;
    this.suffixColor = suffixColor ?? WBTextFieldController.config.suffixColor;
    this.isClearEnable =
        isClearEnable ?? WBTextFieldController.config.isClearEnable;
    this.clearVisibilityAlways = clearVisibilityAlways ??
        WBTextFieldController.config.clearVisibilityAlways;
    this.clearButtonColor =
        clearButtonColor ?? WBTextFieldController.config.clearButtonColor;
    this.maxLength = maxLength ?? WBTextFieldController.config.maxLength;
    this.maxLines = maxLines ?? WBTextFieldController.config.maxLines;
    this.obscureText = obscureText ?? WBTextFieldController.config.obscureText;
    this.obscuringCharacter =
        obscuringCharacter ?? WBTextFieldController.config.obscuringCharacter;
    this.textCapitalization =
        textCapitalization ?? WBTextFieldController.config.textCapitalization;
    this.inputFormatter = (oldValue, newValue) {
      if (newValue.text.length > this.maxLength) {
        return oldValue;
      } else {
        if (inputFormatter != null) {
          return inputFormatter(oldValue, newValue);
        } else {
          return newValue;
        }
      }
      // final textLastIndex = min(this.maxLength, newValue.text.length);
      // return inputFormatter!(
      //   oldValue,
      //   TextEditingValue(
      //     text: newValue.text.substring(0, textLastIndex),
      //     composing: TextRange(
      //       start: newValue.composing.start,
      //       end: min(newValue.composing.end, textLastIndex),
      //     ),
      //     selection: TextSelection(
      //       baseOffset: newValue.selection.baseOffset,
      //       extentOffset: min(newValue.selection.extentOffset, textLastIndex),
      //       affinity: newValue.selection.affinity,
      //       isDirectional: newValue.selection.isDirectional,
      //     ),
      //   ),
      // );
    };
    this.initialDate = initialDate ?? WBTextFieldController.config.initialDate;
    this.currentDate = currentDate ?? WBTextFieldController.config.currentDate;
    this.firstDate = firstDate ?? WBTextFieldController.config.firstDate;
    this.lastDate = lastDate ?? WBTextFieldController.config.lastDate;
    this.initialTime = initialTime ?? WBTextFieldController.config.initialTime;
    this.itemBuilderMaxHeight = itemBuilderMaxHeight ??
        WBTextFieldController.config.itemBuilderMaxHeight;
  }

  late final TextEditingController editingController;
  late final FocusNode focusNode;
  final String? initialText;
  final String? label;
  final String? hint;
  late final EdgeInsets padding;
  late Border border;
  late BorderRadius borderRadius;
  late final TextStyle style;
  late final TextStyle labelStyle;
  late final TextStyle hintStyle;
  late Border focusBorder;
  late final TextStyle focusLabelStyle;
  late final TextStyle focusHintStyle;
  late final TextStyle focusStyle;
  final String? error;
  late final bool errorBorderOnly;
  late Border errorBorder;
  late final TextStyle errorLabelStyle;
  late final TextStyle errorHintStyle;
  late final TextStyle errorStyle;
  final IconData? suffix;
  late final Color suffixColor;
  final void Function(String text)? suffixAction;
  late final bool isClearEnable;
  late final bool clearVisibilityAlways;
  late final Color clearButtonColor;
  final TextInputType? textInputType;
  final TextInputAction? returnKeyType;
  late final int maxLength;
  late final int maxLines;
  final bool? enabled;
  late final bool obscureText;
  late final String obscuringCharacter;
  late final TextCapitalization textCapitalization;
  late final TextInputFormatFunction inputFormatter;
  final void Function(String text)? didChange;
  final void Function(String?)? onSaved;
  final void Function(String)? onEditingComplete;
  void Function(String?)? onFieldSubmitted;

  // -- Date Picker
  final bool? datePicker;
  late final DateTime initialDate;
  late final DateTime currentDate;
  late final DateTime firstDate;
  late final DateTime lastDate;
  final bool? timePicker;
  late final TimeOfDay initialTime;
  final String Function(DateTime? date, TimeOfDay? time)? didSelectDateTime;
  // -- Date Picker

  // -- Drop Down
  final bool? enableItemSearch;
  late final double itemBuilderMaxHeight;
  final Widget? itemBuilderHeader;
  final Future<String?> Function(String)? itemBuilderHeaderTapped;
  final List<WBTextFieldOption>? items;
  final Widget? itemsSeparator;
  final Future<String> Function(String id)? itemDidSelect;
  // -- Drop Down

  List<WBTextFieldOption> get filteredItems {
    var filteredItems = items?.toList() ?? [];
    if ((enableItemSearch ?? false) && editingController.text.isNotEmpty) {
      final text = editingController.text.replaceAll(" ", "").toLowerCase();
      filteredItems.sort(
        (a, b) {
          final aValue = a.matchText.replaceAll(" ", "").toLowerCase();
          final bValue = b.matchText.replaceAll(" ", "").toLowerCase();

          final match = text
              .allMatches(bValue)
              .length
              .compareTo(text.allMatches(aValue).length);
          return match;
        },
      );
    }
    return filteredItems;
  }
}
