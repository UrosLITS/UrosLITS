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
