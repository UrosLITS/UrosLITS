import 'dart:io';

import 'package:book/core/constants.dart';
import 'package:book/presentation/book/bloc/home_page_bloc.dart';
import 'package:book/presentation/book/bloc/home_page_event.dart';
import 'package:book/presentation/book/bloc/home_page_state.dart';
import 'package:book/presentation/common/custom_snackbar.dart';
import 'package:book/presentation/common/custom_text_form.dart';
import 'package:book/presentation/common/dialog_utils.dart';
import 'package:book/styles/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  String? imageUrl;
  late ImagePicker _imagePicker;
  File? imageFile;

  String? imageName;

  @override
  void initState() {
    _imagePicker = ImagePicker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageState>(
      listener: (context, state) {
        if (state is SuccessfulBookAdded) {
          Navigator.of(context).pop(state.book);
        } else if (state is LoadingState) {
          DialogUtils.showLoadingScreen(context);
        } else if (state is LoadedState) {
          Navigator.pop(context);
        } else if (state is SuccessfulImageAdded) {
          imageName = state.imageName;
        } else if (state is SuccessfulImageDeleted) {
          imageName = null;
          imageFile = null;
        } else if (state is ServerError) {
          CustomSnackBar.showSnackBar(
              color: Colors.red,
              content: AppLocalizations.of(context)!.error,
              context: context);
        }
      },
      builder: (BuildContext context, Object? state) {
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
                  CustomTextForm(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.empty_book_title;
                        }
                        return null;
                      },
                      labelText: AppLocalizations.of(context)!.book_title,
                      keyboardType: TextInputType.text,
                      maxLength: titleMaxLength,
                      onChanged: (value) => setState(() {
                            title = value;
                          })),
                  SizedBox(height: 40),
                  CustomTextForm(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.empty_author;
                      }
                      return null;
                    },
                    labelText: AppLocalizations.of(context)!.author,
                    keyboardType: TextInputType.text,
                    maxLength: authorMaxLength,
                    onChanged: (value) => setState(
                      () {
                        author = value;
                      },
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child:
                            imageFile != null ? Image.file(imageFile!) : null,
                      ),
                      Expanded(
                        child: Text(
                          imageName != null ? imageName! : '',
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
                            context.read<HomePageBloc>().add(DeleteBookImage());
                          },
                          icon: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brown.withOpacity(0.8),
                    ),
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
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: FloatingActionButton(
              child: Icon(CupertinoIcons.camera),
              onPressed: () async {
                final XFile? result =
                    await _imagePicker.pickImage(source: ImageSource.gallery);
                if (result != null) {
                  imageFile = File(result.path);

                  context
                      .read<HomePageBloc>()
                      .add(AddBookImageEvent(file: imageFile!));
                }
              },
            ),
          ),
        );
      },
    );
  }

  void addNewBook(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<HomePageBloc>().add(AddNewBook(
            title: title!,
            author: author!,
            imageFile: imageFile!,
          ));
    }
  }
}
