import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:book/data/firebase_auth/firebase_auth_singleton.dart';
import 'package:book/data/firebase_cloud_messaging.dart';
import 'package:book/data/firebase_firestore/firebase_db_manager.dart';
import 'package:book/models/app_user_singleton.dart';
import 'package:book/models/book/book.dart';
import 'package:book/utils/file_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super((InitialBookState())) {
    on<AddNewBookEvent>((event, emit) => _onBookAdded(event, emit));
    on<NewBookAddedEvent>((event, emit) => _onNewBookAdded(event, emit));
    on<AddBookImageEvent>((event, emit) => _onAddBookImage(event, emit));
    on<DeleteBookImageEvent>((event, emit) => _onDeleteBookImage(emit));
    on<GetBookDataEvent>((event, emit) => _onDataRetrieved(event, emit));
    on<SignOutEvent>((event, emit) => _onSignOut(emit));
    on<GetBookListEvent>((event, emit) => _onGetBookList(event, emit));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getBooksStream() {
    return FirebaseDbManager.instance.downloadBooksStream();
  }

  Future<void> _onSignOut(Emitter<HomePageState> emit) async {
    try {
      await FirebaseAuthSingleton.instance.auth.signOut();
      AppUserSingleton.instance.clearUser();
      emit(SignOutState());
    } on FirebaseAuthException catch (e) {
      emit(ErrorAuthState(error: e));
    }
  }

  Future<void> _onBookAdded(
      AddNewBookEvent event, Emitter<HomePageState> emit) async {
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

      final messageResult = await FCM.instance.sendPushMessage(
        topic: 'books',
        title: 'New  book has been added',
        body: 'A new book has been published by ${result.author}',
      );
      if (messageResult) {
        emit(PopBackBookState(book: result));
      }
    } on Exception catch (e) {
      emit(LoadedState());
      emit(ErrorHomeState(error: e));
    }
  }

  Future<void> _onAddBookImage(
      AddBookImageEvent event, Emitter<HomePageState> emit) async {
    emit(LoadingState());

    try {
      final result = await FileUtils.getFileName(event.file);

      if (result.isNotEmpty) {
        emit(LoadedState());
        emit(SuccessfulImageAddedState(imageName: result));
      } else {
        emit(LoadedState());
      }
    } on Exception catch (e) {
      emit(LoadedState());
      emit(ErrorHomeState(error: e));
    }
  }

  Future<void> _onDeleteBookImage(Emitter<HomePageState> emit) async {
    emit(LoadingState());

    emit(LoadedState());
    emit(SuccessfulImageDeleted());
  }

  Future<void> _onNewBookAdded(
      NewBookAddedEvent event, Emitter<HomePageState> emit) async {
    emit(SuccessfulBookAddedState(book: event.book));
  }

  Future<void> _onDataRetrieved(
      GetBookDataEvent event, Emitter<HomePageState> emit) async {
    emit(LoadingState());

    try {
      final result =
          await FirebaseDbManager.instance.getBookData(event.book.id);

      event.book.bookData = result;
      emit(LoadedState());
      emit(DataRetrieved(book: event.book));
    } on Exception catch (e) {
      emit(LoadedState());
      emit(ErrorHomeState(error: e));
    }
  }

  Future<void> _onGetBookList(
      GetBookListEvent event, Emitter<HomePageState> emit) async {
    final List<Book> books = [];

    for (final item in event.querySnapshot.docs) {
      books.add(Book.fromJson(item.data(), item.id));
    }

    emit(BookListRetrievedState(bookList: books));
  }
}
