import 'dart:math';

import 'package:equatable/equatable.dart';

sealed class HomePageEvent extends Equatable {}

class AddBook extends HomePageEvent {
  final String author;
  final String title;
  final String url;
  final String id;

  AddBook(
      {required this.title,
      required this.author,
      required this.url,
      required this.id});

  @override
  List<Object?> get props => [title, author, url, id, Random().nextInt(10000)];
}
