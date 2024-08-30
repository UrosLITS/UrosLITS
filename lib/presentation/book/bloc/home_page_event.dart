import 'dart:io';

import 'package:book/models/book.dart';
import 'package:equatable/equatable.dart';

sealed class HomePageEvent extends Equatable {}

class AddNewBook extends HomePageEvent {
  final String author;
  final String title;
  final File imageFile;

  AddNewBook({
    required this.title,
    required this.author,
    required this.imageFile,
  });

  @override
  List<Object?> get props => [
        title,
        author,
        imageFile,
      ];
}

class RefreshBooks extends HomePageEvent {
  final List<Book>? bookList;

  RefreshBooks({this.bookList});

  @override
  List<Object?> get props => [bookList];
}

class DeleteBookImage extends HomePageEvent {
  DeleteBookImage();

  @override
  List<Object?> get props => [];
}

class AddBookImageEvent extends HomePageEvent {
  final File file;

  AddBookImageEvent({required this.file});

  @override
  List<Object?> get props => [file];
}
