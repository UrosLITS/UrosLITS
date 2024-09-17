part of 'book_bloc.dart';

sealed class BookEvents extends Equatable {}

class NextPageEvent extends BookEvents {
  NextPageEvent();

  @override
  List<Object?> get props => [];
}

class PreviousPageEvent extends BookEvents {
  PreviousPageEvent();

  @override
  List<Object?> get props => [];
}

class InitBookEvent extends BookEvents {
  InitBookEvent(this.book);

  final Book book;

  @override
  List<Object?> get props => [
        book,
        Random().nextInt(10000),
      ];
}

class AddNewPageEvent extends BookEvents {
  AddNewPageEvent({
    required this.bookPage,
  });

  final BookPage bookPage;

  @override
  List<Object?> get props => [
        bookPage,
        Random().nextInt(10000),
      ];
}

class AddBookPageImageEvent extends BookEvents {
  AddBookPageImageEvent({required this.file});

  final File file;

  @override
  List<Object?> get props => [
        file,
        Random().nextInt(10000),
      ];
}

class AddImageToServerEvent extends BookEvents {
  AddImageToServerEvent({
    required this.imageFile,
    required this.bookID,
    required this.bookPage,
  });

  final File imageFile;
  final String bookID;
  final BookPage bookPage;

  @override
  List<Object?> get props => [
        imageFile,
        bookID,
        bookPage,
        Random().nextInt(10000),
      ];
}

class PopBackBookPageEvent extends BookEvents {
  PopBackBookPageEvent({
    required this.bookPage,
  });

  final BookPage bookPage;

  @override
  List<Object?> get props => [
        bookPage,
        Random().nextInt(10000),
      ];
}

class AddNewChapterEvent extends BookEvents {
  AddNewChapterEvent({
    required this.bookChapter,
  });

  final BookChapter? bookChapter;

  @override
  List<Object?> get props => [
        bookChapter,
        Random().nextInt(10000),
      ];
}

class PageEditedEvent extends BookEvents {
  PageEditedEvent({
    required this.bookPage,
  });

  final BookPage bookPage;

  @override
  List<Object?> get props => [
        bookPage,
        Random().nextInt(10000),
      ];
}

class NavigateToPageEvent extends BookEvents {
  NavigateToPageEvent({required this.chapterIndex});

  final int chapterIndex;

  @override
  List<Object?> get props => [chapterIndex];
}

class RemoveImageEvent extends BookEvents {
  RemoveImageEvent();

  @override
  List<Object?> get props => [];
}

class SelectChapterEvent extends BookEvents {
  SelectChapterEvent({required this.selectedChapter});

  final BookChapter? selectedChapter;

  @override
  List<Object?> get props => [selectedChapter];
}
