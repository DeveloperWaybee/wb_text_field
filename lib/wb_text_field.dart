// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:wb_text_field/wb_text_field.dart';

import 'controller/wb_text_field_controller.dart';

export 'controller/wb_text_field_controller.dart';

class WBTextField extends StatefulWidget {
  WBTextField({
    super.key,
    required this.controller,
  });

  final WBTextFieldController controller;

  final _widgetKey = GlobalKey();

  @override
  State<WBTextField> createState() => _WBTextFieldState();
}

class _WBTextFieldState extends State<WBTextField> {
  WBTextFieldController get controller => widget.controller;
  MediaQueryData? get mediaQuery => MediaQuery.maybeOf(context);

  bool get hasError => controller.error != null;
  bool hasFocus = false;
  bool showClear = false;
  bool readOnly = false;
  bool dateTimePickerOpened = false;

  bool get isDatePicker => controller.datePicker ?? false;
  bool get isTimePicker => controller.timePicker ?? false;

  /// Get Content Padding
  ///
  EdgeInsets get contentPadding {
    return controller.padding ??
        EdgeInsets.fromLTRB(
          16,
          10,
          ((controller.suffix != null) ||
                  !(showClear && controller.isClearEnable))
              ? 16
              : 0,
          10,
        );
  }

  /// Get Label
  ///
  Widget? get label {
    return (controller.label != null) ? Text(controller.label!) : null;
  }

  /// Get Style
  ///
  TextStyle? get style {
    return ((hasFocus)
            ? controller.focusStyle ??
                TextStyle(color: Theme.of(context).textTheme.labelMedium?.color)
            : (hasError)
                ? controller.errorStyle ??
                    TextStyle(color: Theme.of(context).colorScheme.error)
                : controller.style ??
                    TextStyle(
                        color: Theme.of(context).textTheme.labelMedium?.color))
        .copyWith(height: lineHeight);
  }

  /// Get Label Style
  ///
  TextStyle? get labelStyle {
    if (hasFocus) {
      return (controller.focusLabelStyle ??
              TextStyle(color: Theme.of(context).colorScheme.secondary))
          .copyWith(height: labelLineHeight);
    } else if (hasError) {
      return (controller.errorLabelStyle ??
              TextStyle(color: Theme.of(context).colorScheme.error))
          .copyWith(height: labelLineHeight);
    } else {
      return (controller.labelStyle ??
              TextStyle(color: Theme.of(context).hintColor))
          .copyWith(height: labelLineHeight);
    }
  }

  /// Get Label Line Height
  ///
  double? get labelLineHeight =>
      ((mediaQuery?.size.width ?? 0) > 600 && controller.label != null)
          ? 1
          : 0.75;

  /// Get Hint Style
  ///
  TextStyle? get hintStyle {
    if (hasFocus) {
      return (controller.focusHintStyle ??
              TextStyle(color: Theme.of(context).colorScheme.secondary))
          .copyWith(height: lineHeight);
    } else if (hasError) {
      return controller.errorHintStyle ??
          TextStyle(color: Theme.of(context).colorScheme.error);
    } else {
      return (controller.hintStyle ??
              TextStyle(color: Theme.of(context).hintColor))
          .copyWith(height: lineHeight);
    }
  }

  /// Get Hint Line Height
  ///
  double? get lineHeight =>
      ((mediaQuery?.size.width ?? 0) > 600 && controller.label != null)
          ? 1.5
          : 1.4;

  /// Get Suffix Icon
  ///
  Widget? get suffixIcon {
    return (controller.clearVisibilityAlways ||
            (showClear && controller.isClearEnable))
        ? IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              controller.editingController.text = "";
            },
            splashRadius: 20,
            iconSize: 20,
            icon: Icon(
              Icons.close_rounded,
              color: controller.clearButtonColor,
            ),
          )
        : (controller.suffix != null)
            ? IconButton(
                padding: EdgeInsets.zero,
                onPressed: controller.suffixAction != null
                    ? () => controller
                        .suffixAction!(controller.editingController.text)
                    : null,
                splashRadius: 20,
                iconSize: 20,
                icon: Icon(
                  controller.suffix,
                  color: controller.suffixColor,
                  size: 20,
                ),
              )
            : null;
  }

  /// Get Vertical Alignment
  ///
  TextAlignVertical? get verticalAlignment {
    return !(showClear && controller.isClearEnable)
        ? (controller.suffix != null)
            ? const TextAlignVertical(y: -0.5)
            : null
        : (controller.label == null)
            ? const TextAlignVertical(y: -0.5)
            : TextAlignVertical.center;
  }

  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget._widgetKey,
      decoration: BoxDecoration(
        border: () {
          if (hasFocus) {
            return controller.focusBorder;
          } else if (hasError) {
            return controller.errorBorder;
          } else {
            return controller.border;
          }
        }(),
        borderRadius: controller.borderRadius,
      ),
      child: TextFormField(
        controller: controller.editingController,
        focusNode: controller.focusNode,
        onChanged: (value) {
          if (controller.didChange != null) {
            controller.didChange!(value);
          }
          if (controller.enableItemSearch ?? false) {
            // optionsOverlayEntry?.markNeedsBuild();
          }
        },
        onTap: _onTap,
        onTapOutside: _onTapOutside,
        onSaved: (newValue) {
          if (controller.onSaved != null) {
            controller.onSaved!(newValue);
          }
        },
        onEditingComplete: () {
          if (controller.onEditingComplete != null) {
            controller.onEditingComplete!(controller.editingController.text);
          }
        },
        onFieldSubmitted: (value) {
          // controller.focusNode.nextFocus();

          if (controller.onFieldSubmitted != null) {
            controller.onFieldSubmitted!(value);
          }
        },
        readOnly: () {
          readOnly = !(controller.enableItemSearch ?? true) ||
              isDatePicker ||
              isTimePicker;
          return readOnly;
        }(),
        enabled: controller.enabled,
        decoration: InputDecoration(
          contentPadding: contentPadding,
          border: InputBorder.none,
          label: label,
          alignLabelWithHint: false,
          labelStyle: labelStyle,
          hintText: controller.hint,
          hintStyle: controller.hintStyle,
          suffixIcon: suffixIcon,
        ),
        style: style,
        textAlignVertical: verticalAlignment,
        maxLength: controller.maxLength,
        maxLines: controller.maxLines,
        keyboardType: controller.textInputType,
        textInputAction: controller.returnKeyType,
      ),
    );
  }

  /// Initial Setup
  ///
  void initialSetup() {
    controller.editingController.addListener(() {
      if (showClear !=
              (hasFocus && controller.editingController.text.isNotEmpty) &&
          controller.isClearEnable) {
        setState(() {
          showClear =
              (hasFocus && controller.editingController.text.isNotEmpty) &&
                  controller.isClearEnable;
        });
      }
    });

    controller.focusNode.addListener(() {
      if (hasFocus != controller.focusNode.hasFocus) {
        setState(() {
          hasFocus = controller.focusNode.hasFocus;
          if (readOnly && hasFocus) {
            if (isDatePicker || isTimePicker) {
              controller.focusNode.unfocus();
            } else {
              _onTap();
            }
          } else if (!hasFocus) {
            WidgetsFlutterBinding.ensureInitialized()
                .addPostFrameCallback((timeStamp) async {
              Future.delayed(const Duration(milliseconds: 500)).then((value) {
                // _onResignFocus();
              });
            });
          }
        });
      }
      if (showClear !=
              (hasFocus && controller.editingController.text.isNotEmpty) &&
          controller.isClearEnable) {
        setState(() {
          showClear =
              (hasFocus && controller.editingController.text.isNotEmpty) &&
                  controller.isClearEnable;
        });
      }
    });
  }

  void _onTap() {
    if (isDatePicker || isTimePicker) {
      _showDatePicker();
    } else {
      controller.focusNode.requestFocus();
    }
  }

  void _onTapOutside(event) {
    controller.focusNode.unfocus();
  }

  void _showDatePicker() async {
    if (dateTimePickerOpened) return;
    dateTimePickerOpened = true;

    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    if (isDatePicker) {
      selectedDate = await showDatePicker(
        context: context,
        initialDate: controller.initialDate,
        currentDate: controller.currentDate,
        firstDate: controller.firstDate,
        lastDate: controller.lastDate,
        initialEntryMode: DatePickerEntryMode.calendar,
        keyboardType: TextInputType.datetime,
      );
    }

    if (isTimePicker && !(isDatePicker && selectedDate == null)) {
      selectedTime = await showTimePicker(
        context: context,
        initialTime: controller.initialTime,
      );
    }

    if (controller.didSelectDateTime != null) {
      controller.editingController.text =
          controller.didSelectDateTime!(selectedDate, selectedTime);
    }
    // controller.focusNode.nextFocus();
    controller.focusNode.unfocus();
    if (controller.onFieldSubmitted != null) {
      controller.onFieldSubmitted!(null);
    }

    dateTimePickerOpened = false;
  }
}
