import 'package:book/models/book/book_imports.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book.g.dart';

@JsonSerializable()
class Book extends Equatable {
  Book({
    required this.author,
    required this.title,
    required this.imageUrl,
    required this.id,
    this.bookData,
  });

  String title;
  String author;
  @JsonKey(name: "image")
  String imageUrl;
  String id;
  BookData? bookData;

  factory Book.fromJson(Map<String, dynamic> json, String id) =>
      _$BookFromJson(json, id);

  factory Book.empty() => Book(
        author: '',
        title: '',
        imageUrl: '',
        id: '',
      );

  Map<String, dynamic> toJson() => _$BookToJson(this);

  @override
  List<Object?> get props => [
        title,
        author,
        id,
        imageUrl,
        bookData,
      ];
}
