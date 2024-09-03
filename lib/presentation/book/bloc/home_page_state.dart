import 'package:book/models/book/book.dart';
import 'package:equatable/equatable.dart';

sealed class HomePageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends HomePageState {
  LoadingState();
}

class LoadedState extends HomePageState {
  LoadedState();
}

class SuccessfulBookAdded extends HomePageState {
  final Book book;

  SuccessfulBookAdded({required this.book});
}

class SuccessfulImageAdded extends HomePageState {
  final String imageName;

  SuccessfulImageAdded({required this.imageName});
}

class SuccessfulImageDeleted extends HomePageState {
  SuccessfulImageDeleted();
}

class ServerError extends HomePageState {
  final Exception error;

  ServerError({required this.error});
}

class InitialState extends HomePageState {
  InitialState();
}

class BooksDownloadedState extends HomePageState {
  final List<Book> bookList;

  BooksDownloadedState({required this.bookList});
}
