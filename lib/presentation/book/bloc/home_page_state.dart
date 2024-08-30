import 'package:book/models/book.dart';
import 'package:equatable/equatable.dart';

sealed class HomePageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends HomePageState {
  LoadingState();
}

class LoadedState extends HomePageState {
  LoadedState();
}

class SuccessfulBookAdded extends HomePageState {
  final Book book;

  SuccessfulBookAdded({required this.book});
}

class InitialState extends HomePageState {
  InitialState();
}
