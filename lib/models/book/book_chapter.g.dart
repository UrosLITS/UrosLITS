// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_chapter.dart';

BookChapter _$BookChaptersFromJson(Map<String, dynamic> json) => BookChapter(
      chTitle: json['title'] as String? ?? '',
      chNumber: (json['number'] as num).toInt(),
    );

Map<String, dynamic> _$BookChaptersToJson(BookChapter instance) =>
    <String, dynamic>{
      'title': instance.chTitle,
      'number': instance.chNumber,
    };
