import 'package:equatable/equatable.dart';

sealed class BookPagesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends BookPagesState {
  InitialState();
}

class NextPage extends BookPagesState {
  NextPage({required this.currentIndex});

  final int currentIndex;

  @override
  List<Object?> get props => [currentIndex];
}

class PreviousPage extends BookPagesState {
  PreviousPage({required this.currentIndex});

  final int currentIndex;

  @override
  List<Object?> get props => [currentIndex];
}

class ErrorState extends BookPagesState {
  ErrorState({required this.error});

  final Exception error;

  @override
  List<Object?> get props => [error];
}
