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

  @override
  List<Object?> get props => [
        book,
        Random().nextInt(10000),
      ];
}

class PopBackBookState extends HomePageState {
  PopBackBookState({required this.book});

  final Book book;

  @override
  List<Object?> get props => [
        book,
        Random().nextInt(10000),
      ];
}

class SuccessfulImageAddedState extends HomePageState {
  SuccessfulImageAddedState({required this.imageName});

  final String imageName;
}

class SuccessfulImageDeleted extends HomePageState {
  SuccessfulImageDeleted();
}

class ErrorHomeState extends HomePageState {
  ErrorHomeState({required this.error});

  final Exception error;

  @override
  List<Object?> get props => [
        error,
        Random().nextInt(10000),
      ];
}

class ErrorAuthState extends HomePageState {
  ErrorAuthState({required this.error});

  final Exception error;

  @override
  List<Object?> get props => [
        error,
        Random().nextInt(10000),
      ];
}

class InitialBookState extends HomePageState {
  InitialBookState();
}

class DataRetrieved extends HomePageState {
  DataRetrieved({required this.book});

  final Book book;

  @override
  List<Object?> get props => [
        book,
        Random().nextInt(10000),
      ];
}

class SignOutState extends HomePageState {
  SignOutState();
}

class BookListRetrievedState extends HomePageState {
  BookListRetrievedState({required this.bookList});

  final List<Book> bookList;

  @override
  List<Object?> get props => [
        bookList,
        Random().nextInt(10000),
      ];
}
