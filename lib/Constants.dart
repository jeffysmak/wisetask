import 'package:flutter/material.dart';

class Constants {
  static void showMessage(BuildContext context, String message, bool success) {
    Color color = success ? Colors.greenAccent : Colors.redAccent;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSecondary)),
        backgroundColor: color,
        duration: Duration(seconds: 5),
        dismissDirection: DismissDirection.endToStart,
      ),
    );
  }
}
