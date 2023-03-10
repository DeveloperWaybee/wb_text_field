// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wb_text_field/wb_text_field.dart';

import 'controller/wb_text_field_controller.dart';

export 'controller/wb_text_field_controller.dart';
export 'models/wb_text_field_option.dart';

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

  late OverlayState overlayState = Overlay.of(context);
  OverlayEntry? optionsOverlayEntry;
  bool animateOptionsOverlay = false;

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
    return EdgeInsets.fromLTRB(
      controller.padding.left,
      controller.padding.top,
      ((controller.suffix != null) || !(showClear && controller.isClearEnable))
          ? controller.padding.right
          : 0,
      controller.padding.bottom,
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
            ? controller.focusStyle
            : (hasError)
                ? controller.errorStyle
                : controller.style)
        .copyWith(height: lineHeight);
  }

  /// Get Label Style
  ///
  TextStyle? get labelStyle {
    if (hasFocus) {
      return controller.focusLabelStyle.copyWith(height: labelLineHeight);
    } else if (hasError) {
      return controller.errorLabelStyle.copyWith(height: labelLineHeight);
    } else {
      return controller.labelStyle.copyWith(height: labelLineHeight);
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
      return controller.focusHintStyle.copyWith(height: lineHeight);
    } else if (hasError) {
      return controller.errorHintStyle.copyWith(height: lineHeight);
    } else {
      return controller.hintStyle.copyWith(height: lineHeight);
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
    return Focus(
      // focusNode: controller.focusNode,
      onFocusChange: (value) {
        if (hasFocus != value) {
          WidgetsFlutterBinding.ensureInitialized()
              .addPostFrameCallback((timeStamp) async {
            setState(() {
              hasFocus = value;
              if (readOnly && hasFocus) {
                if (isDatePicker || isTimePicker) {
                  // controller.focusNode.unfocus();
                } else {
                  _onTap();
                }
              } else if (!hasFocus) {
                // WidgetsFlutterBinding.ensureInitialized()
                //     .addPostFrameCallback((timeStamp) async {
                //   Future.delayed(const Duration(milliseconds: 500)).then((value) {
                //     // _onResignFocus();
                //   });
                // });
              }
            });
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
      },
      child: Container(
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
          // focusNode: controller.focusNode,
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
          inputFormatters: [
            TextInputFormatter.withFunction(controller.inputFormatter),
          ],
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
          maxLines: controller.maxLines,
          keyboardType: controller.textInputType,
          textInputAction: controller.returnKeyType,
          obscureText: controller.obscureText,
          obscuringCharacter: controller.obscuringCharacter,
          textCapitalization: controller.textCapitalization,
        ),
      ),
    );
  }

  /// Initial Setup
  ///
  void initialSetup() {
    controller.editingController.addListener(() {
      WidgetsFlutterBinding.ensureInitialized()
          .addPostFrameCallback((timeStamp) {
        optionsOverlayEntry?.markNeedsBuild();
      });

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
        WidgetsFlutterBinding.ensureInitialized()
            .addPostFrameCallback((timeStamp) async {
          setState(() {
            hasFocus = controller.focusNode.hasFocus;
            if (readOnly && hasFocus) {
              if (isDatePicker || isTimePicker) {
                controller.focusNode.unfocus();
              } else {
                _onTap();
              }
            } else if (!hasFocus) {
              // WidgetsFlutterBinding.ensureInitialized()
              //     .addPostFrameCallback((timeStamp) async {
              //   Future.delayed(const Duration(milliseconds: 500)).then((value) {
              //     // _onResignFocus();
              //   });
              // });
            }
          });
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
    print("_ON TAP INSIDE");
    if (controller.items != null || controller.itemBuilderHeader != null) {
      WidgetsFlutterBinding.ensureInitialized()
          .addPostFrameCallback((timeStamp) async {
        // await Future.delayed(const Duration(milliseconds: 330));
        _showOptionsOverlay();
      });
    } else if (isDatePicker || isTimePicker) {
      _showDatePicker();
    } else {
      // controller.focusNode.requestFocus();
    }
  }

  void _onTapOutside(event) {
    // print("_ON TAP OUTSIDE");
    // if (optionsOverlayEntry != null) {
    //   return;
    // }
    // controller.focusNode.unfocus();
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

  void _showOptionsOverlay() async {
    animateOptionsOverlay = false;
    if (controller.itemBuilderHeader == null && controller.items == null) {
      return;
    }
    if (optionsOverlayEntry != null) {
      return;
    }
    optionsOverlayEntry = OverlayEntry(builder: (c) {
      final mediaQuery = MediaQuery.maybeOf(c);
      // if (optionsFirstOverlayBuild) {
      //   WidgetsFlutterBinding.ensureInitialized()
      //       .addPostFrameCallback((timeStamp) {
      //     optionsFirstOverlayBuild = false;
      //     optionsOverlayEntry?.markNeedsBuild();
      //   });
      // }
      final currentContext = widget._widgetKey.currentContext;
      final RenderBox renderBox =
          currentContext?.findRenderObject() as RenderBox;
      final Size size = renderBox.size; // or _widgetKey.currentContext?.size
      final Offset offset = renderBox.localToGlobal(Offset.zero);

      final screenPath = Path();
      screenPath.addRect(
        Rect.fromLTWH(
            0, 0, mediaQuery?.size.width ?? 0, mediaQuery?.size.height ?? 0),
      );
      screenPath.close();
      final textFieldPath = Path();
      textFieldPath.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height),
          controller.borderRadius.bottomRight,
        ),
      );
      textFieldPath.close();

      final finalPath = Path.combine(
        PathOperation.difference,
        screenPath,
        textFieldPath,
      );

      final windowPadding = EdgeInsets.fromWindowPadding(
        WidgetsBinding.instance.window.viewPadding,
        WidgetsBinding.instance.window.devicePixelRatio,
      );

      final windowInsets = EdgeInsets.fromWindowPadding(
        WidgetsBinding.instance.window.viewInsets,
        WidgetsBinding.instance.window.devicePixelRatio,
      );

      final topAvailableSpace =
          offset.dy - (windowInsets.top + windowPadding.top);
      final bottomAvailableSpace =
          ((WidgetsBinding.instance.window.physicalSize.height /
                  WidgetsBinding.instance.window.devicePixelRatio) -
              (offset.dy +
                  size.height +
                  (windowInsets.bottom + windowPadding.bottom)));

      final shouldShowAbove =
          (bottomAvailableSpace > controller.itemBuilderMaxHeight)
              ? false
              : topAvailableSpace > bottomAvailableSpace;

      final maxHeight = shouldShowAbove
          ? min(topAvailableSpace, controller.itemBuilderMaxHeight)
          : min(bottomAvailableSpace, controller.itemBuilderMaxHeight);

      final top = shouldShowAbove ? null : (offset.dy + size.height);
      final bottom =
          shouldShowAbove ? ((mediaQuery?.size.height ?? 0) - offset.dy) : null;
      final left = offset.dx + 7.5;
      final width = size.width - 15;

      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        animateOptionsOverlay = true;
        optionsOverlayEntry?.markNeedsBuild();
      });
      // You can return any widget you like here
      // to be displayed on the Overlay
      return AnimatedOpacity(
        duration: const Duration(milliseconds: 330),
        opacity: animateOptionsOverlay ? 1 : 0,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  _removeOptionsOverlay();
                },
                child: ClipPath(
                  clipper: _TextFieldClipper(finalPath),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(color: Colors.black.withOpacity(0.1)),
                ),
              ),
            ),
            Positioned(
              top: top,
              bottom: bottom,
              left: left,
              width: width,
              child: Column(
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: 1, //optionsFirstOverlayBuild ? 0 : 1,
                    child: Material(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        constraints: BoxConstraints(
                          minHeight: 50,
                          maxHeight:
                              maxHeight, // optionsFirstOverlayBuild ? 0 : maxHeight,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: shouldShowAbove
                                ? controller.borderRadius.bottomRight
                                : Radius.zero,
                            bottom: shouldShowAbove
                                ? Radius.zero
                                : controller.borderRadius.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, shouldShowAbove ? -1 : 1),
                              blurRadius: 3,
                              color: Colors.grey.withOpacity(0.25),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          reverse: shouldShowAbove,
                          padding: EdgeInsets.zero,
                          child: IntrinsicHeight(
                            child: Column(
                              verticalDirection: shouldShowAbove
                                  ? VerticalDirection.up
                                  : VerticalDirection.down,
                              children: [
                                if (controller.itemBuilderHeader != null)
                                  InkWell(
                                    onTap: (controller
                                                .itemBuilderHeaderTapped ==
                                            null)
                                        ? null
                                        : () async {
                                            _removeOptionsOverlay();
                                            final newText = await controller
                                                    .itemBuilderHeaderTapped!(
                                                controller
                                                    .editingController.text);
                                            if (newText != null) {
                                              controller.editingController
                                                  .text = newText;
                                            }
                                            // _onResignFocus();
                                            if (controller.onFieldSubmitted !=
                                                null) {
                                              controller
                                                  .onFieldSubmitted!(null);
                                            }
                                          },
                                    child: controller.itemBuilderHeader!,
                                  ),
                                if (controller.filteredItems.isNotEmpty)
                                  ...List.generate(
                                      max(
                                          0,
                                          (controller.itemsSeparator != null)
                                              ? (controller.filteredItems
                                                          .length) *
                                                      2 -
                                                  1
                                              : controller.filteredItems
                                                  .length), (index) {
                                    final int itemIndex =
                                        (controller.itemsSeparator != null)
                                            ? index ~/ 2
                                            : index;
                                    final Widget? listWidget;

                                    if (index.isEven ||
                                        controller.itemsSeparator == null) {
                                      listWidget = InkWell(
                                        onTap:
                                            (controller.itemDidSelect == null)
                                                ? null
                                                : () async {
                                                    _removeOptionsOverlay();
                                                    controller.editingController
                                                        .text = await controller
                                                            .itemDidSelect!(
                                                        controller
                                                            .filteredItems[
                                                                itemIndex]
                                                            .matchText);
                                                    // controller.focusNode.nextFocus();
                                                    // _onResignFocus();
                                                    // if (controller.onFieldSubmitted != null) {
                                                    //   controller.onFieldSubmitted!(null);
                                                    // }
                                                  },
                                        child:
                                            controller.filteredItems[itemIndex],
                                      );
                                    } else {
                                      if (controller.itemsSeparator == null) {
                                        return null;
                                      }
                                      listWidget = controller.itemsSeparator;
                                    }
                                    return Flexible(
                                        child: listWidget ??
                                            const SizedBox.shrink());
                                  }).whereType<Widget>(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
    // Inserting the OverlayEntry into the Overlay
    if (optionsOverlayEntry != null && !optionsOverlayEntry!.mounted) {
      overlayState.insert(optionsOverlayEntry!);
    }
  }

  void _removeOptionsOverlay() {
    if (optionsOverlayEntry == null) {
      // optionsFirstOverlayBuild = true;
      return;
    }
    animateOptionsOverlay = false;
    // optionsOverlayRect = null;
    optionsOverlayEntry?.remove();
    optionsOverlayEntry = null;
    // optionsFirstOverlayBuild = true;
    controller.focusNode.unfocus();
  }
}

class _TextFieldClipper extends CustomClipper<Path> {
  _TextFieldClipper(this.path);

  final Path path;

  @override
  Path getClip(Size size) {
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
