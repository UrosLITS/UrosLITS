import 'package:book/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddChapterDialog extends StatelessWidget {
  AddChapterDialog({required this.newChapterTitle});

  final _formKey2 = GlobalKey<FormState>();
  String? newChapterTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Dialog(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.add_new_chapter),
                Form(
                  key: _formKey2,
                  child: TextFormField(
                    enableInteractiveSelection: true,
                    maxLength: 50,
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: AppLocalizations.of(context)!.text,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.empty_text;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      newChapterTitle = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(newChapterTitle);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brown.withOpacity(0.8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(AppLocalizations.of(context)!.save,
                            style:
                                TextStyle(fontSize: 16, color: Colors.black)),
                        SizedBox(width: 8),
                        Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
