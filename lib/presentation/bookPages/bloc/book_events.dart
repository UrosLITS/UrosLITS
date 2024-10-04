part of 'book_bloc.dart';

sealed class BookEvents extends Equatable {}

class NextPageEvent extends BookEvents {
  NextPageEvent({required this.currentIndex});

  final int currentIndex;

  @override
  List<Object?> get props => [
        currentIndex,
        Random().nextInt(10000),
      ];
}

class PreviousPageEvent extends BookEvents {
  PreviousPageEvent({required this.currentIndex});

  final int currentIndex;

  @override
  List<Object?> get props => [
        currentIndex,
        Random().nextInt(10000),
      ];
}

class InitBookEvent extends BookEvents {
  InitBookEvent(
    this.book,
  );

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
    this.imageFile,
    required this.title,
    required this.body,
  });

  final BookPage bookPage;
  final String title;
  final String body;
  final File? imageFile;

  @override
  List<Object?> get props => [
        bookPage,
        Random().nextInt(10000),
        title,
        body,
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
    required this.bookPage,
  });

  final File imageFile;
  final BookPage bookPage;

  @override
  List<Object?> get props => [
        imageFile,
        bookPage,
        Random().nextInt(10000),
      ];
}

class PopBackBookPageEvent extends BookEvents {
  PopBackBookPageEvent({
    required this.bookPage,
    this.imageFile,
  });

  final BookPage bookPage;
  final File? imageFile;

  @override
  List<Object?> get props => [
        bookPage,
        Random().nextInt(10000),
      ];
}

class AddNewChapterEvent extends BookEvents {
  AddNewChapterEvent({required this.bookChapter});

  final BookChapter? bookChapter;

  @override
  List<Object?> get props => [
        bookChapter,
        Random().nextInt(10000),
      ];
}

class PageEditedEvent extends BookEvents {
  PageEditedEvent(
      {required this.bookPage,
      required this.body,
      required this.title,
      this.imageFile});

  final BookPage bookPage;
  final String title;
  final String body;
  final File? imageFile;

  @override
  List<Object?> get props => [
        bookPage,
        Random().nextInt(10000),
        title,
        body,
      ];
}

class NavigateToPageEvent extends BookEvents {
  NavigateToPageEvent({required this.pageIndex});

  final int pageIndex;

  @override
  List<Object?> get props => [pageIndex];
}

class RemoveImageEvent extends BookEvents {
  @override
  List<Object?> get props => [];
}

class SelectChapterEvent extends BookEvents {
  SelectChapterEvent({required this.selectedChapter});

  final BookChapter? selectedChapter;

  @override
  List<Object?> get props => [selectedChapter];
}

class DeletePageEvent extends BookEvents {
  DeletePageEvent({
    required this.body,
    required this.title,
  });

  final String title;
  final String body;

  @override
  List<Object?> get props => [
        title,
        body,
      ];
}

class SwipeLeftEvent extends BookEvents {
  SwipeLeftEvent({required this.currentIndex});

  final int currentIndex;

  @override
  List<Object?> get props => [
        currentIndex,
        Random().nextInt(10000),
      ];
}

class SwipeRightEvent extends BookEvents {
  SwipeRightEvent({required this.currentIndex});

  final int currentIndex;

  @override
  List<Object?> get props => [
        currentIndex,
        Random().nextInt(10000),
      ];
}
