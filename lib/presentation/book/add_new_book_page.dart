import 'dart:io';

import 'package:book/models/book.dart';
import 'package:book/styles/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class AddNewBookPage extends StatefulWidget {
  const AddNewBookPage({super.key});

  State<AddNewBookPage> createState() => _AddNewBookPage();
}

class _AddNewBookPage extends State<AddNewBookPage> {
  final _formKey = GlobalKey<FormState>();

  String? title;
  String? author;
  String? url;
  late bool validURL;
  late ImagePicker _imagePicker;
  File? imageFile;

  String? imageName;

  @override
  void initState() {
    _imagePicker = ImagePicker();
    imageName = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.add_book),
      ),
      body: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30),
                TextFormField(
                  enableInteractiveSelection: true,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  maxLength: 20,
                  decoration: InputDecoration(
                    counterText: "",
                    alignLabelWithHint: true,
                    labelText: AppLocalizations.of(context)!.book_title,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    title = value;
                  }),
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.empty_book_title;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                TextFormField(
                  enableInteractiveSelection: true,
                  keyboardType: TextInputType.text,
                  maxLength: 20,
                  maxLines: 1,
                  decoration: InputDecoration(
                    counterText: "",
                    alignLabelWithHint: true,
                    labelText: AppLocalizations.of(context)!.author,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    author = value;
                  }),
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.empty_author;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: imageFile != null ? Image.file(imageFile!) : null,
                    ),
                    Expanded(
                      child: Text(
                        imageName!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Visibility(
                      visible: imageFile != null,
                      child: IconButton(
                        onPressed: () {
                          imageFile = null;
                          imageName = "";
                          setState(() {});
                        },
                        icon: Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brown.withOpacity(0.8)),
                  onPressed: () {
                    addNewBook(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.add_book,
                        style: TextStyle(color: AppColors.black),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.add,
                        color: AppColors.black,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          child: Icon(CupertinoIcons.camera),
          onPressed: () async {
            final XFile? result =
                await _imagePicker.pickImage(source: ImageSource.gallery);
            if (result != null) {
              imageFile = File(result.path);
              imageName = imageFile?.path.split("/").last;

              setState(() {});
            }
          },
        ),
      ),
    );
  }

  void addNewBook(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      Book addNewBook = Book(author: author!, title: title!, url: url!, id: "");

      Navigator.of(context).pop(addNewBook);
    }
  }
}
