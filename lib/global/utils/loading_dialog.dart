import 'package:flutter/material.dart';

class LoadingDialog {
  static showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
