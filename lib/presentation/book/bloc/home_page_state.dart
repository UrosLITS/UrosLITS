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

class SuccessfulBookAddedState extends HomePageState {
  SuccessfulBookAddedState({required this.book});

  final Book book;
}

class SuccessfulImageAddedState extends HomePageState {
  SuccessfulImageAddedState({required this.imageName});

  final String imageName;
}

class SuccessfulImageDeleted extends HomePageState {
  SuccessfulImageDeleted();
}

class ErrorState extends HomePageState {
  ErrorState({required this.error});

  final Exception error;
}

class ErrorAuthState extends HomePageState {
  ErrorAuthState({required this.error});

  final Exception error;
}

class InitialState extends HomePageState {
  InitialState();
}

class BooksDownloadedState extends HomePageState {
  BooksDownloadedState({required this.bookList});

  final List<Book> bookList;
}

class DataRetrieved extends HomePageState {
  DataRetrieved({required this.book});

  final Book book;
}

class SignOutState extends HomePageState {
  SignOutState();
}
