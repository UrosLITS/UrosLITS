import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_page_image.g.dart';

@JsonSerializable()
class BookPageImage extends Equatable {
  BookPageImage(
      {required this.width,
      required this.height,
      this.filePath,
      this.url,
      this.storagePath});

  String? url;
  String? filePath;
  int width;
  int height;
  String? storagePath;

  @override
  List<Object?> get props => [
        url,
        filePath,
        width,
        height,
        storagePath,
      ];

  factory BookPageImage.fromJson(Map<String, dynamic> json) =>
      _$BookPageImageFromJson(json);

  Map<String, dynamic> toJson() => _$BookPageImageToJson(this);

  String getFileName() {
    return filePath?.split('/').last ?? url?.split("/").last ?? "noImage";
  }
}
