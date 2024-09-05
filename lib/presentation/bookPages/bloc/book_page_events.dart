import 'package:equatable/equatable.dart';

sealed class BookPagesEvents extends Equatable {}

class NextPageEvent extends BookPagesEvents {
  NextPageEvent({required this.currentIndex});

  int currentIndex;

  @override
  List<Object?> get props => [currentIndex];
}

class PreviousPageEvent extends BookPagesEvents {
  PreviousPageEvent({required this.currentIndex});

  int currentIndex;

  @override
  List<Object?> get props => [currentIndex];
}
