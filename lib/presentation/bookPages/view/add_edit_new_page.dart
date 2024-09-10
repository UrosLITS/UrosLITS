import 'dart:io';

import 'package:book/models/book/book_imports.dart';
import 'package:book/presentation/bookPages/bloc/book_bloc.dart';
import 'package:book/presentation/common/common.dart';
import 'package:book/styles/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class AddEditNewPage extends StatefulWidget {
  const AddEditNewPage({
    Key? key,
    required this.bookPage,
    required this.bookID,
  }) : super(key: key);

  final BookPage bookPage;
  final String bookID;

  State<AddEditNewPage> createState() => _AddEditNewPage();
}

class _AddEditNewPage extends State<AddEditNewPage> {
  final _formKey = GlobalKey<FormState>();
  File? imageFile;
  late File image;
  late ImagePicker _imagePicker;
  String? text;
  String? imageName;

  @override
  void initState() {
    _imagePicker = ImagePicker();

    imageName = "No image";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookBloc, BookState>(listener: (context, state) {
      if (state is LoadingBookPageState) {
        DialogUtils.showLoadingScreen(context);
      } else if (state is LoadedBookPageState) {
        Navigator.pop(context);
      } else if (state is SuccessfulAddedImage) {
        imageName = state.fileName;
      } else if (state is InitBookEvent) {
        imageName = 'no image';
      } else if (state is UploadedImageToServerState) {
        state.bookPage.text = text!;
        state.bookPage.pageNumber = widget.bookPage.pageNumber;

        if (state.isUploaded == true) {
          context
              .read<BookBloc>()
              .add(PopBackBookPageEvent(bookPage: state.bookPage));
        }
      } else if (state is PopBackBookPageState) {
        Navigator.of(context).pop(state.bookPage);
      }
    }, builder: (BuildContext context, Object? state) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            icon: Icon(CupertinoIcons.back),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.brown.withOpacity(0.8),
        ),
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(height: 50),
                      TextFormField(
                        enableInteractiveSelection: true,
                        maxLength: 1100,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
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
                        onChanged: (value) => setState(() {
                          text = value;
                        }),
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.empty_text;
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Visibility(
                            visible: true,
                            child: SizedBox(
                                height: 50,
                                width: 50,
                                child: imageFile != null
                                    ? Image.file(imageFile!)
                                    : null),
                          ),
                          Expanded(
                            child: Text(
                              imageName!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (imageFile != null) {
                      context.read<BookBloc>().add(AddImageToServerEvent(
                          imageFile: imageFile!,
                          bookID: widget.bookID,
                          bookPage: widget.bookPage));
                    } else {
                      widget.bookPage.text = text!;
                      context.read<BookBloc>().add(PopBackBookPageEvent(
                            bookPage: widget.bookPage,
                          ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brown.withOpacity(0.8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.save,
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      SizedBox(width: 8),
                      Icon(
                        color: Colors.black,
                        Icons.add,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: FloatingActionButton(
            child: Icon(CupertinoIcons.camera),
            onPressed: () async {
              final XFile? result =
                  await _imagePicker.pickImage(source: ImageSource.gallery);
              if (result != null) {
                imageFile = File(result.path);

                context
                    .read<BookBloc>()
                    .add(AddBookPageImageEvent(file: imageFile!));
              }
            },
          ),
        ),
      );
    });
  }
}
