import 'dart:io';
import 'dart:ui' as ui;

import 'package:book/data/firebase_firestore/firebase_db_manager.dart';
import 'package:book/models/book/book_imports.dart';
import 'package:book/utils/file_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_events.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvents, BookState> {
  BookBloc() : super((InitialState())) {
    on<NextPageEvent>(_onNextPage);
    on<PreviousPageEvent>(_onPreviousPage);
    on<InitBookEvent>(_onInitBook);
    on<AddNewPageEvent>(_onAddNewPage);
    on<AddBookPageImageEvent>(_onAddBookPageImage);
    on<AddImageToServerEvent>(_onAddImageToServer);
    on<PopBackBookPageEvent>(_onPopBackBookPage);
  }

  late Book book;
  int currentPageIndex = 0;

  Future<void> _onNextPage(NextPageEvent event, Emitter<BookState> emit) async {
    currentPageIndex++;
    emit(DisplayBookPageState(
        bookData: book.bookData!, pageIndex: currentPageIndex));
  }

  Future<void> _onInitBook(InitBookEvent event, Emitter<BookState> emit) async {
    this.book = event.book;
    if (book.bookData == null) {
      book.bookData = BookData(chapters: [], pages: []);
    }
    this.currentPageIndex = 0;
    emit(DisplayBookPageState(
        bookData: book.bookData!, pageIndex: currentPageIndex));
  }

  Future<void> _onPreviousPage(
      PreviousPageEvent event, Emitter<BookState> emit) async {
    currentPageIndex--;
    emit(DisplayBookPageState(
        bookData: book.bookData!, pageIndex: currentPageIndex));
  }

  Future<void> _onAddNewPage(
      AddNewPageEvent event, Emitter<BookState> emit) async {
    book.bookData!.pages.add(event.bookPage);

    emit(DisplayBookPageState(
        bookData: book.bookData!, pageIndex: currentPageIndex));
  }

  Future<void> _onAddBookPageImage(
      AddBookPageImageEvent event, Emitter<BookState> emit) async {
    emit(LoadingBookPageState());

    final result = await FileUtils.getFileName(event.file);

    emit(SuccessfulAddedImage(fileName: result));
    emit(LoadedBookPageState());
  }

  Future<void> _onAddImageToServer(
      AddImageToServerEvent event, Emitter<BookState> emit) async {
    emit(LoadingBookPageState());

    try {
      ui.Image? decodedImage;
      File image = File(event.imageFile.path);

      decodedImage = await decodeImageFromList(image.readAsBytesSync());
      BookPageImage bookPageImage = BookPageImage(
        width: decodedImage.width,
        height: decodedImage.height,
        filePath: event.imageFile.path,
      );
      event.bookPage.bookPageImage = bookPageImage;

      final result = await FirebaseDbManager.instance
          .addImageToServer(event.bookPage, event.imageFile, event.bookID);

      emit(UploadedImageToServerState(
          isUploaded: result, bookPage: event.bookPage));
      emit(LoadedBookPageState());
    } on Exception catch (e) {
      emit(LoadedBookPageState());

      emit(ErrorState(
          bookData: book.bookData!, error: e, pageIndex: currentPageIndex));
    }
  }

  Future<void> _onPopBackBookPage(
      PopBackBookPageEvent event, Emitter<BookState> emit) async {
    emit(LoadingBookPageState());

    emit(LoadedBookPageState());
    emit(PopBackBookPageState(bookPage: event.bookPage));
  }
}
