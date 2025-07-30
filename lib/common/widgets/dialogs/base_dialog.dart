import 'package:flutter/material.dart';

class BaseDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final bool barrierDismissible;
  final EdgeInsets? contentPadding;

  const BaseDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.barrierDismissible = true,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Padding(
        padding: contentPadding ?? const EdgeInsets.all(0),
        child: content,
      ),
      actions: actions,
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    bool barrierDismissible = true,
    EdgeInsets? contentPadding,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder:
          (context) => BaseDialog(
            title: title,
            content: content,
            actions: actions,
            barrierDismissible: barrierDismissible,
            contentPadding: contentPadding,
          ),
    );
  }
}
