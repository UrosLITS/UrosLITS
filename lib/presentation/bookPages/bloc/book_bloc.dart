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
    on<NextPageEvent>((event, emit) => _onNextPage(event, emit));
    on<PreviousPageEvent>((event, emit) => _onPreviousPage(event, emit));
    on<InitBookEvent>((event, emit) => _onInitBook(event, emit));
    on<AddNewPageEvent>((event, emit) => _onAddNewPage(event, emit));
    on<AddBookPageImageEvent>(
        (event, emit) => _onAddBookPageImage(event, emit));
    on<AddImageToServerEvent>(
        (event, emit) => _onAddImageToServer(event, emit));
    on<PopBackBookPageEvent>((event, emit) => _onPopBackBookPage(event, emit));
    on<AddNewChapterEvent>((event, emit) => _onAddNewChapter(event, emit));
    on<PageEditedEvent>((event, emit) => _onPageEditedEvent(event, emit));
    on<NavigateToPageEvent>((event, emit) => _onNavigateToPage(event, emit));
    on<RemoveImageEvent>((event, emit) => _onRemoveImageEvent(emit));
    on<SelectChapterEvent>((event, emit) => _onSelectChapterEvent(event, emit));
    on<DeletePageEvent>((event, emit) => _onDeletePageEvent(event, emit));
    on<SwipeLeftEvent>((event, emit) => _onSwipeLeftEvent(event, emit));
    on<SwipeRightEvent>((event, emit) => _onSwipeRightEvent(event, emit));
  }

  late Book book;
  int currentPageIndex = 0;

  Future<void> _onNextPage(NextPageEvent event, Emitter<BookState> emit) async {
    currentPageIndex = event.currentIndex;

    if (currentPageIndex < book.bookData!.pages.length - 1) currentPageIndex++;
    emit(DisplayBookPageState(
        bookData: book.bookData!,
        pageIndex: currentPageIndex,
        doNotPopDialog: true));
  }

  Future<void> _onInitBook(InitBookEvent event, Emitter<BookState> emit) async {
    this.book = event.book;

    emit(LoadingBookPageState());

    try {
      final result = await FirebaseDbManager.instance.downloadBookData(book.id);
      book.bookData = result;
      emit(DisplayBookPageState(
          bookData: book.bookData!, pageIndex: currentPageIndex));
    } on Exception catch (e) {
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
        bookData: book.bookData!,
        pageIndex: currentPageIndex,
        doNotPopDialog: true));
  }

  Future<void> _onAddNewPage(
      AddNewPageEvent event, Emitter<BookState> emit) async {
    final bookPage = event.bookPage;
    for (int i = 0; i < book.bookData!.pages.length; i++) {
      if (book.bookData!.pages[i].bookChapter!.chNumber >
          bookPage.bookChapter!.chNumber) {
        book.bookData!.pages[i].pageNumber++;
        bookPage.pageNumber--;
      }
    }
    book.bookData!.pages.insert(bookPage.pageNumber - 1, bookPage);
    book.bookData!.pages.sort((a, b) => a.pageNumber.compareTo(b.pageNumber));

    emit(LoadingBookPageState());
    try {
      await FirebaseDbManager.instance
          .addPagesToServer(book.bookData!.pages, book.id);
      currentPageIndex = book.bookData!.pages.indexOf(bookPage);

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
      } else {
        throw Exception();
      }
    } on Exception catch (e) {
      emit(ErrorState(
          bookData: book.bookData!, error: e, pageIndex: currentPageIndex));
    } finally {
      emit(DisplayBookPageState(
          bookData: book.bookData!, pageIndex: currentPageIndex));
    }
  }

  Future<void> _onAddBookPageImage(
      AddBookPageImageEvent event, Emitter<BookState> emit) async {
    emit(LoadingBookPageState());

    try {
      final result = await FileUtils.getFileName(event.file);

      if (result.isNotEmpty) {
        emit(SuccessfulAddedImage(fileName: result));
        emit(DisplayBookPageState(
            bookData: book.bookData!, pageIndex: currentPageIndex));
      } else {
        emit(DisplayBookPageState(
            bookData: book.bookData!, pageIndex: currentPageIndex));
      }
    } on Exception catch (e) {
      emit(ErrorState(
          bookData: book.bookData!, error: e, pageIndex: currentPageIndex));
    }
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
          .addImageToServer(event.bookPage, event.imageFile, book.id);

      if (result) {
        emit(UploadedImageToServerState(
            isUploaded: result, bookPage: event.bookPage));
        emit(DisplayBookPageState(
            bookData: book.bookData!,
            pageIndex: currentPageIndex,
            doNotPopDialog: true));
      } else {
        throw Exception();
      }
    } on Exception catch (e) {
      emit(ErrorState(
          bookData: book.bookData!, error: e, pageIndex: currentPageIndex));
    }
  }

  Future<void> _onPopBackBookPage(
      PopBackBookPageEvent event, Emitter<BookState> emit) async {
    emit(LoadingBookPageState());
    emit(DisplayBookPageState(
        bookData: book.bookData!, pageIndex: currentPageIndex));
    emit(PopBackBookPageState(bookPage: event.bookPage));
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
      emit(DisplayBookPageState(
          bookData: book.bookData!,
          pageIndex: currentPageIndex,
          doNotPopDialog: true));
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
      } else {
        throw Exception();
      }
    } on Exception catch (e) {
      emit(ErrorState(
          bookData: book.bookData!, error: e, pageIndex: currentPageIndex));
    } finally {
      emit(DisplayBookPageState(
          bookData: book.bookData!, pageIndex: currentPageIndex));
    }
  }

  Future<void> _onNavigateToPage(
      NavigateToPageEvent event, Emitter<BookState> emit) async {
    if (event.pageIndex != -1) {
      currentPageIndex = event.pageIndex;
      emit(DisplayBookPageState(
          bookData: book.bookData!,
          pageIndex: currentPageIndex,
          doNotPopDialog: true));
    }
  }

  Future<void> _onRemoveImageEvent(Emitter<BookState> emit) async {
    emit(RemoveImageState());
    emit(DisplayBookPageState(
        bookData: book.bookData!, pageIndex: currentPageIndex));
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
      } else {
        throw Exception();
      }
    } on Exception catch (e) {
      emit(ErrorState(
          bookData: book.bookData!, error: e, pageIndex: currentPageIndex));
    }
  }

  Future<void> _onSwipeLeftEvent(
      SwipeLeftEvent event, Emitter<BookState> emit) async {
    currentPageIndex = event.currentIndex;
    currentPageIndex++;
    emit(DisplayBookPageState(
        bookData: book.bookData!,
        pageIndex: currentPageIndex,
        doNotPopDialog: true));
  }

  Future<void> _onSwipeRightEvent(
      SwipeRightEvent event, Emitter<BookState> emit) async {
    currentPageIndex = event.currentIndex;
    currentPageIndex--;
    emit(DisplayBookPageState(
        bookData: book.bookData!,
        pageIndex: currentPageIndex,
        doNotPopDialog: true));
  }
}
