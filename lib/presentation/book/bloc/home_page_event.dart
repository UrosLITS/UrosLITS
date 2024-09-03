import 'dart:io';

import 'package:book/models/book/book.dart';
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

class onNewBookAdded extends HomePageEvent {
  final Book book;

  onNewBookAdded({required this.book});

  @override
  List<Object?> get props => [book];
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

class DownloadBooks extends HomePageEvent {
  DownloadBooks();

  @override
  List<Object?> get props => [];
}
