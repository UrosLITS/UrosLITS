import 'package:equatable/equatable.dart';

sealed class BookState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends BookState {
  InitialState();
}

class NextPage extends BookState {
  NextPage();

  @override
  List<Object?> get props => [];
}

class PreviousPage extends BookState {
  PreviousPage();

  @override
  List<Object?> get props => [];
}

class ErrorState extends BookState {
  ErrorState({required this.error});

  final Exception error;

  @override
  List<Object?> get props => [error];
}
