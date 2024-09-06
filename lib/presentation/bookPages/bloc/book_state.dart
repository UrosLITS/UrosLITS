import 'package:book/models/book/book_data.dart';
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
  final Exception error;

  ErrorState({
    required super.bookData,
    required this.error,
    required super.pageIndex,
  });

  @override
  List<Object?> get props => [error];
}
