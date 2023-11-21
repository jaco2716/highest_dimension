import 'package:flutter/material.dart';

class MyInfoDialog extends StatelessWidget {
  const MyInfoDialog({super.key, required this.child, this.title, this.action});
  final Widget child;
  final String? title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: child,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          : null,
      actions: [
        Center(
          child: action ?? TextButton(onPressed: () => Navigator.maybePop(context), child: const Text('Close')),
        ),
      ],
    );
  }
}
