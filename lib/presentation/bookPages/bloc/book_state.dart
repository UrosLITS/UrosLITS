part of 'book_bloc.dart';

sealed class BookState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends BookState {}

class DisplayBookPageState extends LoadedBookPageState {
  DisplayBookPageState({
    super.doNotPopDialog,
    required this.bookData,
    required this.pageIndex,
  });

  final int pageIndex;
  final BookData bookData;

  @override
  List<Object?> get props => [
        pageIndex,
        bookData,
        Random().nextInt(10000),
      ];
}

class ErrorState extends DisplayBookPageState {
  ErrorState({
    required super.bookData,
    required this.error,
    required super.pageIndex,
  });

  final Exception error;
}

class AddNewPageState extends BookState {
  AddNewPageState({required this.bookPage, required this.bookID});

  final BookPage bookPage;
  final String bookID;
}

class AddImageState extends BookState {
  AddImageState({required this.file});

  final File? file;
}

class LoadingBookPageState extends BookState {}

class LoadedBookPageState extends BookState {
  LoadedBookPageState({this.doNotPopDialog = false});

  final bool doNotPopDialog;
}

class SuccessfulAddedImage extends BookState {
  SuccessfulAddedImage({required this.fileName});

  final String fileName;
}

class UploadedImageToServerState extends BookState {
  UploadedImageToServerState({
    required this.isUploaded,
    required this.bookPage,
  });

  final bool isUploaded;
  final BookPage bookPage;

  @override
  List<Object?> get props => [isUploaded, bookPage];
}

class PopBackBookPageState extends BookState {
  PopBackBookPageState({
    required this.bookPage,
  });

  final BookPage bookPage;

  @override
  List<Object?> get props => [bookPage];
}

class LoadBookChapterListState extends BookState {
  LoadBookChapterListState({
    required this.bookChapterList,
  });

  final List<BookChapter> bookChapterList;

  @override
  List<Object?> get props => [bookChapterList];
}

class PagesAddedToServerState extends BookState {
  PagesAddedToServerState({
    required this.bookPagesList,
  });

  final List<BookPage> bookPagesList;

  @override
  List<Object?> get props => [bookPagesList];
}

class NavigateToPageState extends BookState {}

class RemoveImageState extends BookState {}

class SelectedChapterState extends BookState {
  SelectedChapterState({required this.bookChapter});

  final BookChapter? bookChapter;

  @override
  List<Object?> get props => [bookChapter];
}
