import 'package:flutter/material.dart';

class WBTextFieldDefaultConfig {
  WBTextFieldDefaultConfig({
    // Text Field
    required this.padding,
    required this.border,
    required this.borderRadius,
    required this.style,
    required this.labelStyle,
    required this.hintStyle,
    required this.focusBorder,
    required this.focusStyle,
    required this.focusLabelStyle,
    required this.focusHintStyle,
    required this.errorBorderOnly,
    required this.errorBorder,
    required this.errorStyle,
    required this.errorLabelStyle,
    required this.errorHintStyle,
    required this.suffixColor,
    required this.isClearEnable,
    required this.clearVisibilityAlways,
    required this.clearButtonColor,
    required this.maxLines,
    required this.maxLength,
    // Text Field
    // Date Time Picker
    required this.initialDate,
    required this.currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.initialTime,
    // Date Time Picker
    // Options Selection with Search
    this.itemBuilderMaxHeight = 200,
    // Options Selection with Search
  });

  EdgeInsets padding;
  Border border;
  BorderRadius borderRadius;
  TextStyle style;
  TextStyle labelStyle;
  TextStyle hintStyle;
  Border focusBorder;
  TextStyle focusLabelStyle;
  TextStyle focusHintStyle;
  TextStyle focusStyle;
  bool errorBorderOnly;
  Border errorBorder;
  TextStyle errorLabelStyle;
  TextStyle errorHintStyle;
  TextStyle errorStyle;
  Color suffixColor;
  bool isClearEnable;
  bool clearVisibilityAlways;
  Color clearButtonColor;
  int maxLength;
  int maxLines;

  // -- Date Picker
  DateTime initialDate;
  DateTime currentDate;
  DateTime firstDate;
  DateTime lastDate;
  TimeOfDay initialTime;
  // -- Date Picker

  // -- Drop Down
  double itemBuilderMaxHeight;
  // -- Drop Down
}
