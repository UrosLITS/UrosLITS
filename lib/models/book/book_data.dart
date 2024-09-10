import 'package:book/models/book/book_chapter.dart';
import 'package:book/models/book/book_pages.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_data.g.dart';

@JsonSerializable()
class BookData extends Equatable {
  BookData({
    required this.chapters,
    required this.pages,
  });

  List<BookChapters> chapters;
  List<BookPage> pages;

  @override
  List<Object?> get props => [
        chapters,
        pages,
      ];

  factory BookData.fromJson(Map<String, dynamic> json) =>
      _$BookDataFromJson(json);

  Map<String, dynamic> toJson() => _$BookDataToJson(this);
}
