// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookData _$BookDataFromJson(Map<String, dynamic> json) => BookData(
      chapters: (json['chapters'] as List<dynamic>)
          .map((e) => BookChapter.fromJson(e as Map<String, dynamic>))
          .toList(),
      pages: (json['pages'] as List<dynamic>)
          .map((e) => BookPage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BookDataToJson(BookData instance) => <String, dynamic>{
      'chapters': instance.chapters,
      'pages': instance.pages,
    };
