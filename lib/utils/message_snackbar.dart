import 'package:flutter/material.dart';

class MessageSnackBar {
  final BuildContext context;
  final String message;
  MessageSnackBar({
    required this.context,
    required this.message,
  });

  void showMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
