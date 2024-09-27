import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:book/core/constants.dart';
import 'package:book/data/firebase_cloud_messaging.dart';
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
    on<AddNewChapterEvent>(_onAddNewChapter);
    on<PageEditedEvent>(_onPageEditedEvent);
    on<NavigateToPageEvent>(_onNavigateToPage);
    on<RemoveImageEvent>(_onRemoveImageEvent);
    on<SelectChapterEvent>(_onSelectChapterEvent);
    on<DeletePageEvent>(_onDeletePageEvent);
    on<SwipeLeftEvent>(_onSwipeLeftEvent);
    on<SwipeRightEvent>(_onSwipeRightEvent);
  }

  late Book book;
  int currentPageIndex = 0;

  Future<void> _onNextPage(NextPageEvent event, Emitter<BookState> emit) async {
    currentPageIndex = event.currentIndex;

    if (currentPageIndex < book.bookData!.pages.length - 1) currentPageIndex++;
    emit(DisplayBookPageState(
        bookData: book.bookData!, pageIndex: currentPageIndex));
  }

  Future<void> _onInitBook(InitBookEvent event, Emitter<BookState> emit) async {
    this.book = event.book;

    emit(LoadingBookPageState());

    try {
      final result = await FirebaseDbManager.instance.downloadBookData(book.id);
      book.bookData = result;
      emit(LoadedBookPageState());
      emit(DisplayBookPageState(
          bookData: book.bookData!, pageIndex: currentPageIndex));
    } on Exception catch (e) {
      emit(LoadedBookPageState());
      emit(ErrorState(
          bookData: book.bookData!, error: e, pageIndex: currentPageIndex));
    }
  }

  Future<void> _onPreviousPage(
      PreviousPageEvent event, Emitter<BookState> emit) async {
    currentPageIndex = event.currentIndex;
    if (currentPageIndex > 0) {
      currentPageIndex--;
    }
    emit(DisplayBookPageState(
        bookData: book.bookData!, pageIndex: currentPageIndex));
  }

  Future<void> _onAddNewPage(
      AddNewPageEvent event, Emitter<BookState> emit) async {
    emit(LoadingBookPageState());
    for (int i = 0; i < book.bookData!.pages.length; i++) {
      if (book.bookData!.pages[i].bookChapter!.chNumber >
          event.bookPage.bookChapter!.chNumber) {
        book.bookData!.pages[i].pageNumber++;
        event.bookPage.pageNumber--;
      }
    }
    book.bookData!.pages.add(event.bookPage);
    book.bookData!.pages.sort((a, b) => a.pageNumber.compareTo(b.pageNumber));

    try {
      await FirebaseDbManager.instance
          .addPagesToServer(book.bookData!.pages, book.id);
      currentPageIndex = book.bookData!.pages.indexOf(event.bookPage);
      emit(LoadedBookPageState());

      Map<String, dynamic> additionalData = {
        'action': pageChangedAction,
        'bookId': book.id,
        'index': currentPageIndex.toString()
      };

      final result = await FCM.instance.sendPushMessage(
        topic: messageTopic,
        title: event.title,
        body: event.body,
        additionalData: additionalData,
      );

      if (result) {
        emit(DisplayBookPageState(
            bookData: book.bookData!, pageIndex: currentPageIndex));
      }
    } on Exception catch (e) {
      emit(LoadedBookPageState());
      emit(ErrorState(
          bookData: book.bookData!, error: e, pageIndex: currentPageIndex));
    }
  }

  Future<void> _onAddBookPageImage(
      AddBookPageImageEvent event, Emitter<BookState> emit) async {
    emit(LoadingBookPageState());

    final result = await FileUtils.getFileName(event.file);

    emit(SuccessfulAddedImage(fileName: result));
    emit(LoadedBookPageState());
    emit(DisplayBookPageState(
        bookData: book.bookData!, pageIndex: currentPageIndex));
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
    emit(DisplayBookPageState(
        bookData: book.bookData!, pageIndex: currentPageIndex));
  }

  Future<void> _onAddNewChapter(
      AddNewChapterEvent event, Emitter<BookState> emit) async {
    emit(LoadingBookPageState());

    try {
      book.bookData?.chapters.add(event.bookChapter!);
      await FirebaseDbManager.instance
          .addChapterToServer(book.bookData!.chapters, book.id);

      emit(LoadBookChapterListState(bookChapterList: book.bookData!.chapters));
    } on Exception catch (e) {
      emit(ErrorState(
          bookData: book.bookData!, error: e, pageIndex: currentPageIndex));
    } finally {
      emit(LoadedBookPageState());
      emit(DisplayBookPageState(
          bookData: book.bookData!, pageIndex: currentPageIndex));
    }
  }

  Future<void> _onPageEditedEvent(
      PageEditedEvent event, Emitter<BookState> emit) async {
    emit(LoadingBookPageState());

    book.bookData?.pages[currentPageIndex] = event.bookPage;
    try {
      await FirebaseDbManager.instance
          .updatePage(book.bookData!.pages, book.id);
      currentPageIndex = book.bookData!.pages.indexOf(event.bookPage);
      emit(LoadedBookPageState());

      Map<String, dynamic> additionalData = {
        'action': pageChangedAction,
        'bookId': book.id,
        'index': currentPageIndex.toString()
      };

      final result = await FCM.instance.sendPushMessage(
        topic: messageTopic,
        title: event.title,
        body: event.body,
        additionalData: additionalData,
      );
      if (result) {
        emit(DisplayBookPageState(
            bookData: book.bookData!, pageIndex: currentPageIndex));
      }
    } on Exception catch (e) {
      emit(LoadedBookPageState());
      emit(ErrorState(
          bookData: book.bookData!, error: e, pageIndex: currentPageIndex));
    }
  }

  Future<void> _onNavigateToPage(
      NavigateToPageEvent event, Emitter<BookState> emit) async {
    if (event.pageIndex != -1) {
      currentPageIndex = event.pageIndex;
      emit(DisplayBookPageState(
          bookData: book.bookData!, pageIndex: currentPageIndex));
    }
  }

  Future<void> _onRemoveImageEvent(
      RemoveImageEvent event, Emitter<BookState> emit) async {
    emit(RemoveImageState());
  }

  Future<void> _onSelectChapterEvent(
      SelectChapterEvent event, Emitter<BookState> emit) async {
    emit(SelectedChapterState(bookChapter: event.selectedChapter));
  }

  Future<void> _onDeletePageEvent(
      DeletePageEvent event, Emitter<BookState> emit) async {
    emit(LoadingBookPageState());
    try {
      await FirebaseDbManager.instance
          .deletePage(book.bookData!.pages[currentPageIndex], book.id);
      book.bookData!.pages.removeAt(currentPageIndex);

      for (int i = currentPageIndex; i < book.bookData!.pages.length; i++) {
        book.bookData!.pages[i].pageNumber--;
      }

      if (currentPageIndex > 0 &&
          currentPageIndex == book.bookData!.pages.length) {
        currentPageIndex--;
      }
      emit(LoadedBookPageState());

      Map<String, dynamic> additionalData = {
        'action': pageChangedAction,
        'bookId': book.id,
      };

      final result = await FCM.instance.sendPushMessage(
        topic: messageTopic,
        title: event.title,
        body: event.body,
        additionalData: additionalData,
      );
      if (result) {
        emit(DisplayBookPageState(
            bookData: book.bookData!, pageIndex: currentPageIndex));
      }
    } on Exception catch (e) {
      emit(LoadedBookPageState());
      emit(ErrorState(
          bookData: book.bookData!, error: e, pageIndex: currentPageIndex));
    }
  }

  Future<void> _onSwipeLeftEvent(
      SwipeLeftEvent event, Emitter<BookState> emit) async {
    currentPageIndex = event.currentIndex;
    currentPageIndex++;
    emit(DisplayBookPageState(
        bookData: book.bookData!, pageIndex: currentPageIndex));
  }

  Future<void> _onSwipeRightEvent(
      SwipeRightEvent event, Emitter<BookState> emit) async {
    currentPageIndex = event.currentIndex;
    currentPageIndex--;
    emit(DisplayBookPageState(
        bookData: book.bookData!, pageIndex: currentPageIndex));
  }
}
