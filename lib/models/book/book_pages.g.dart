part of 'book_pages.dart';

BookPage _$BookPageFromJson(Map<String, dynamic> json) => BookPage(
      text: json['text'] as String? ?? '',
      pageNumber: (json['number'] as num).toInt(),
      bookPageImage: json['image'] == null
          ? null
          : BookPageImage.fromJson(json['image'] as Map<String, dynamic>),
      bookChapter: json['chapter'] == null
          ? null
          : BookChapters.fromJson(json['chapter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookPageToJson(BookPage instance) => <String, dynamic>{
      'number': instance.pageNumber,
      'text': instance.text,
      'url': instance.url,
      'image': instance.bookPageImage?.toJson(),
      'chapter': instance.bookChapter?.toJson(),
    };
