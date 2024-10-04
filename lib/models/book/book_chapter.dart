import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_chapter.g.dart';

class BookChapter extends Equatable {
  BookChapter({
    this.chTitle = '',
    required this.chNumber,
  });

  @JsonKey(name: "title")
  String? chTitle;
  @JsonKey(name: "number")
  int chNumber;

  @override
  List<Object?> get props => [
        chNumber,
        chTitle,
      ];

  factory BookChapter.fromJson(Map<String, dynamic> json) =>
      _$BookChaptersFromJson(json);

  Map<String, dynamic> toJson() => _$BookChaptersToJson(this);
}
