import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLoadingScreen {
  static Future<void> showLoadingScreen(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ));
  }
}
