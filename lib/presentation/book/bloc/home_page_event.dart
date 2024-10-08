part of 'home_page_bloc.dart';

sealed class HomePageEvent extends Equatable {}

class AddNewBookEvent extends HomePageEvent {
  AddNewBookEvent({
    required this.title,
    required this.author,
    required this.imageFile,
  });

  final String author;
  final String title;
  final File imageFile;

  @override
  List<Object?> get props => [
        title,
        author,
        imageFile,
      ];
}

class NewBookAddedEvent extends HomePageEvent {
  NewBookAddedEvent({required this.book});

  final Book book;

  @override
  List<Object?> get props => [book];
}

class DeleteBookImageEvent extends HomePageEvent {
  DeleteBookImageEvent();

  @override
  List<Object?> get props => [];
}

class AddBookImageEvent extends HomePageEvent {
  AddBookImageEvent({required this.file});

  final File file;

  @override
  List<Object?> get props => [file];
}

class DownloadBooksEvent extends HomePageEvent {
  DownloadBooksEvent();

  @override
  List<Object?> get props => [];
}

class GetBookDataEvent extends HomePageEvent {
  GetBookDataEvent({required this.book});

  final Book book;

  @override
  List<Object?> get props => [book];
}

class SignOutEvent extends HomePageEvent {
  SignOutEvent();

  @override
  List<Object?> get props => [];
}
