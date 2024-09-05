import 'dart:io';

import 'package:book/data/firebase_firestore/firebase_db_manager.dart';
import 'package:book/models/book/book.dart';
import 'package:book/utils/file_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super((InitialState())) {
    on<AddNewBook>(_onBookAdded);
    on<NewBookAdded>(_onNewBookAdded);
    on<AddBookImageEvent>(_onAddBookImage);
    on<DeleteBookImage>(_onDeleteBookImage);
    on<DownloadBooks>(_onDownloadBooks);
    on<GetBookData>(_onDataRetrieved);
  }

  Future<void> _onBookAdded(
      AddNewBook event, Emitter<HomePageState> emit) async {
    emit(LoadingState());

    try {
      final urlResult = await FirebaseDbManager.instance
          .uploadBookImage(event.imageFile, event.title);
      final Book? result = new Book(
          author: event.author,
          title: event.title,
          imageUrl: urlResult,
          id: '');

      await FirebaseDbManager.instance.addBookToServer(result!);

      emit(LoadedState());
      emit(SuccessfulBookAdded(book: result));
    } on Exception catch (e) {
      emit(LoadedState());
      emit(ServerError(error: e));
    }
  }

  Future<void> _onAddBookImage(
      AddBookImageEvent event, Emitter<HomePageState> emit) async {
    emit(LoadingState());

    final result = await FileUtils.getFileName(event.file);

    emit(LoadedState());
    emit(SuccessfulImageAdded(imageName: result));
  }

  Future<void> _onDeleteBookImage(
      DeleteBookImage event, Emitter<HomePageState> emit) async {
    emit(LoadingState());

    emit(LoadedState());
    emit(SuccessfulImageDeleted());
  }

  Future<void> _onNewBookAdded(
      NewBookAdded event, Emitter<HomePageState> emit) async {
    emit(SuccessfulBookAdded(book: event.book));
  }

  Future<void> _onDownloadBooks(
      DownloadBooks event, Emitter<HomePageState> emit) async {
    try {
      final result = await FirebaseDbManager.instance.downloadBooks();
      emit(BooksDownloadedState(bookList: result));
    } on Exception catch (e) {
      emit(LoadedState());
      emit(ServerError(error: e));
    }
  }

  Future<void> _onDataRetrieved(
      GetBookData event, Emitter<HomePageState> emit) async {
    emit(LoadingState());

    try {
      final result =
          await FirebaseDbManager.instance.getBookData(event.book.id);

      event.book.bookData = result;
      emit(LoadedState());
      emit(DataRetrieved(book: event.book));
    } on Exception catch (e) {
      emit(LoadedState());
      emit(ServerError(error: e));
    }
  }
}
