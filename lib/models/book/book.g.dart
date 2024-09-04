// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json, String id) => Book(
      author: json['author'] as String,
      title: json['title'] as String,
      imageUrl: json['image'] as String,
      id: id,
    );

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'title': instance.title,
      'author': instance.author,
      'image': instance.imageUrl,
    };
