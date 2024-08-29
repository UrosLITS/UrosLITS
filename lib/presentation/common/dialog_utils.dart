import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static Future<void> showLoadingScreen(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
