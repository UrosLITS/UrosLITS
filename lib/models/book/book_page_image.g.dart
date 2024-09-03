// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_page_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookPageImage _$BookPageImageFromJson(Map<String, dynamic> json) =>
    BookPageImage(
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      filePath: json['filePath'] as String?,
      url: json['url'] as String?,
      storagePath: json['storagePath'] as String?,
    );

Map<String, dynamic> _$BookPageImageToJson(BookPageImage instance) =>
    <String, dynamic>{
      'url': instance.url,
      'filePath': instance.filePath,
      'width': instance.width,
      'height': instance.height,
      'storagePath': instance.storagePath,
    };
