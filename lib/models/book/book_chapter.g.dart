// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_chapter.dart';




BookChapters _$BookChaptersFromJson(Map<String, dynamic> json) =>
    BookChapters(
      chTitle: json['title'] as String? ?? '',
      chNumber: (json['number'] as num).toInt(),
    );

Map<String, dynamic> _$BookChaptersToJson(BookChapters instance) =>
    <String, dynamic>{
      'title': instance.chTitle,
      'number': instance.chNumber,
    };
