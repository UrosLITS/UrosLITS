import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Book extends Equatable {
  Book({
    required this.author,
    required this.title,
    required this.imageUrl,
    required this.id,
  });

  String title;
  String author;
  @JsonKey(name: "image")
  String imageUrl;
  String id;

  @override
  List<Object?> get props => [title, author, id, imageUrl];
}
