import 'dart:io';

import 'package:book/core/constants.dart';
import 'package:book/enums/page_mode.dart';
import 'package:book/models/book/book_imports.dart';
import 'package:book/presentation/bookPages/bloc/book_bloc.dart';
import 'package:book/presentation/bookPages/widgets/add_chapter_dialog.dart';
import 'package:book/presentation/common/common.dart';
import 'package:book/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class AddEditNewPage extends StatefulWidget {
  AddEditNewPage(
      {Key? key,
      required this.bookPage,
      required this.bookID,
      required this.bookChapterList,
      required this.pageMode,
      required this.bookPageList})
      : super(key: key);

  final BookPage bookPage;
  final String bookID;

  List<BookChapter> bookChapterList;
  List<BookPage> bookPageList;
  final PageMode pageMode;

  State<AddEditNewPage> createState() => _AddEditNewPage();
}

class _AddEditNewPage extends State<AddEditNewPage> {
  final _formKey = GlobalKey<FormState>();
  File? imageFile;
  late File image;
  late ImagePicker _imagePicker;
  String? text;
  bool imageSelected = false;
  String? imageName;
  BookChapter? selectedChapter;
  String? newChapterTitle;
  int currentIndex = 0;

  @override
  void initState() {
    _imagePicker = ImagePicker();
    if (editPageMode) {
      if (hasImage) {
        imageSelected = true;
        imageName = widget.bookPage.bookPageImage?.getFileName();
      } else {
        imageName = noImage;
      }
      text = widget.bookPage.text;
      selectedChapter = widget.bookPage.bookChapter;
      selectedChapter = widget.bookChapterList.lastOrNull;
    } else {
      imageName = noImage;
      selectedChapter = widget.bookChapterList.lastOrNull;
    }

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
        imageSelected = true;
      } else if (state is InitBookEvent) {
        imageName = noImage;
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
      } else if (state is LoadBookChapterListState) {
        selectedChapter = widget.bookChapterList.lastOrNull;

        widget.bookChapterList = state.bookChapterList;
      } else if (state is RemoveImageState) {
        imageFile = null;
        imageSelected = false;
        imageName = noImage;
      } else if (state is SelectedChapterState) {
        selectedChapter = state.bookChapter;
      }
    }, builder: (BuildContext context, Object? state) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
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
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: DropdownButton<BookChapter>(
                              isExpanded: true,
                              icon: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [Icon(Icons.arrow_drop_down)],
                              ),
                              value: selectedChapter,
                              items: dropDownItems(widget.bookChapterList),
                              onChanged: editPageMode
                                  ? null
                                  : (BookChapter? value) {
                                      context.read<BookBloc>().add(
                                          SelectChapterEvent(
                                              selectedChapter: value));
                                    },
                            ),
                          ),
                          Visibility(
                            visible: addPageMode,
                            child: IconButton(
                              onPressed: () async {
                                final result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AddChapterDialog(
                                      newChapterTitle: newChapterTitle,
                                    );
                                  },
                                );
                                if (result != null) {
                                  BookChapter bookChapter = new BookChapter(
                                      chTitle: result,
                                      chNumber:
                                          widget.bookChapterList.length + 1);
                                  context.read<BookBloc>().add(
                                      AddNewChapterEvent(
                                          bookChapter: bookChapter));
                                }
                              },
                              icon: Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        enableInteractiveSelection: true,
                        maxLength: 1100,
                        initialValue: text,
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
                        onChanged: (value) {
                          text = value;
                        },
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
                            visible: imageSelected,
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: hasImage
                                  ? Image.network(
                                      fit: BoxFit.cover,
                                      widget.bookPage.bookPageImage!.url!,
                                    )
                                  : imageFile != null
                                      ? Image.file(imageFile!)
                                      : null,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              imageName!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Visibility(
                            visible: imageSelected,
                            child: IconButton(
                              onPressed: () {
                                context
                                    .read<BookBloc>()
                                    .add(RemoveImageEvent());
                              },
                              icon: Icon(Icons.close),
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
                      BookPage bookPage = BookPage(
                          pageNumber: widget.bookPage.pageNumber,
                          text: text!,
                          bookChapter: selectedChapter,
                          bookPageImage: null);
                      context
                          .read<BookBloc>()
                          .add(PopBackBookPageEvent(bookPage: bookPage));
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
            child: Icon(Icons.camera_alt_rounded),
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

  bool get addPageMode => widget.pageMode == PageMode.addNewPage;

  bool get editPageMode => widget.pageMode == PageMode.editMode;

  bool get hasImage => widget.bookPage.bookPageImage != null && editPageMode;

  List<DropdownMenuItem<BookChapter>> dropDownItems(List<BookChapter> bookCh) {
    final items = bookCh.map((BookChapter chapter) {
      return DropdownMenuItem<BookChapter>(
        value: chapter,
        child: Text(
          chapter.chTitle!,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      );
    }).toList();

    return items;
  }
}
