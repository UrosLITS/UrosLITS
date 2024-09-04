
import 'package:book/models/book/book_imports.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_pages.g.dart';

@JsonSerializable()
class BookPages {
  BookPages(
      {this.text = '',
      required this.pageNumber,
      this.bookPageImage,
      required this.bookChapter,
      this.dateTime,
      this.pickBook});

  @JsonKey(name: "number")
  late int pageNumber;
  String text;
  String? url;
  @JsonKey(name: "image")
  BookPageImage? bookPageImage;
  @JsonKey(name: "chapter")
  BookChapters? bookChapter;
  DateTime? dateTime;
  Book? pickBook;

  @override
  List<Object?> get props =>
      [pageNumber, text, url, bookPageImage, bookChapter, dateTime];

  factory BookPages.fromJson(Map<String, dynamic> json) =>
      _$BookPageFromJson(json);

  Map<String, dynamic> toJson() => _$BookPageToJson(this);
}
