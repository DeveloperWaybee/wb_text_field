import 'package:flutter/material.dart';

class WBTextFieldOption extends StatelessWidget {
  const WBTextFieldOption({
    super.key,
    required this.uniqueId,
    required this.matchText,
    required this.child,
  });

  final String uniqueId;
  final String matchText;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
