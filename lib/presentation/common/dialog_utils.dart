import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static BuildContext? oldDialogContext;

  static Future<void> showLoadingScreen(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          oldDialogContext = dialogContext;
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  static void popLoadingScreen() {
    if (oldDialogContext != null) {
      Navigator.of(oldDialogContext!).pop();
    }
    oldDialogContext = null;
  }
}
