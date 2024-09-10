import 'dart:io';

import 'package:book/models/book/book_imports.dart';
import 'package:equatable/equatable.dart';

sealed class BookState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends BookState {
  InitialState();
}

class DisplayBookPageState extends BookState {
  DisplayBookPageState({
    required this.bookData,
    required this.pageIndex,
  });

  final int pageIndex;
  final BookData bookData;

  @override
  List<Object?> get props => [pageIndex];
}

class ErrorState extends DisplayBookPageState {
  ErrorState({
    required super.bookData,
    required this.error,
    required super.pageIndex,
  });

  final Exception error;

  @override
  List<Object?> get props => [error];
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

class LoadingBookPageState extends BookState {
  LoadingBookPageState();
}

class LoadedBookPageState extends BookState {
  LoadedBookPageState();
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
}

class PopBackBookPageState extends BookState {
  PopBackBookPageState({
    required this.bookPage,
  });

  final BookPage bookPage;
}
