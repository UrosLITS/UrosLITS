import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Book extends Equatable {
  Book({
    required this.author,
    required this.title,
    required this.url,
    required this.id,
  });

  String title;
  String author;
  @JsonKey(name: "image")
  String url;
  String id;

  //yet to be added
  //BookData? bookData;

  @override
  List<Object?> get props => [title, author, id, url];
}
