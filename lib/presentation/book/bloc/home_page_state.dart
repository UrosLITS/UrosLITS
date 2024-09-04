part of 'home_page_bloc.dart';

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
  SuccessfulBookAdded({required this.book});

  final Book book;
}

class SuccessfulImageAdded extends HomePageState {
  SuccessfulImageAdded({required this.imageName});

  final String imageName;
}

class SuccessfulImageDeleted extends HomePageState {
  SuccessfulImageDeleted();
}

class ServerError extends HomePageState {
  ServerError({required this.error});

  final Exception error;
}

class InitialState extends HomePageState {
  InitialState();
}

class BooksDownloadedState extends HomePageState {
  BooksDownloadedState({required this.bookList});

  final List<Book> bookList;
}
