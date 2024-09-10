import 'dart:io';

import 'package:book/models/book/book_imports.dart';
import 'package:equatable/equatable.dart';

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
  List<Object?> get props => [book];
}

class AddNewPageEvent extends BookEvents {
  AddNewPageEvent({required this.bookPage});

  final BookPage bookPage;

  @override
  List<Object?> get props => [
        bookPage,
      ];
}

class AddBookPageImageEvent extends BookEvents {
  AddBookPageImageEvent({required this.file});

  final File file;

  @override
  List<Object?> get props => [file];
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
  List<Object?> get props => [];
}

class PopBackBookPageEvent extends BookEvents {
  PopBackBookPageEvent({
    required this.bookPage,
  });

  final BookPage bookPage;

  @override
  List<Object?> get props => [bookPage];
}
