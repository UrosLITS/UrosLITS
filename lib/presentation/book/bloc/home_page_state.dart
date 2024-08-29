import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

sealed class HomePageState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoadingState extends HomePageState {
  LoadingState();
}

class LoadedState extends HomePageState {
  LoadedState();
}

class SuccessfulBookAdded extends HomePageState {
  SuccessfulBookAdded();
}

class InitialState extends HomePageState {
  InitialState();
}
