part of 'home_page_bloc.dart';

sealed class HomePageEvent extends Equatable {}

class AddNewBook extends HomePageEvent {
  AddNewBook({
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

class NewBookAdded extends HomePageEvent {
  NewBookAdded({required this.book});

  final Book book;

  @override
  List<Object?> get props => [book];
}

class DeleteBookImage extends HomePageEvent {
  DeleteBookImage();

  @override
  List<Object?> get props => [];
}

class AddBookImageEvent extends HomePageEvent {
  AddBookImageEvent({required this.file});

  final File file;

  @override
  List<Object?> get props => [file];
}

class DownloadBooks extends HomePageEvent {
  DownloadBooks();

  @override
  List<Object?> get props => [];
}
