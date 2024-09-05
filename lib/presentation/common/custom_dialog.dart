import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    required this.content,
    required this.positiveAnswer,
    required this.negativeAnswer,
  }) : super(key: key);

  final String content;
  final VoidCallback positiveAnswer;
  final VoidCallback negativeAnswer;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              content,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: positiveAnswer,
                  child: Text(AppLocalizations.of(context)!.yes),
                ),
                TextButton(
                  onPressed: negativeAnswer,
                  child: Text(AppLocalizations.of(context)!.no),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
