import 'dart:io';

class FileUtils {
  static Future<String> getFileName(File file) async {
    final result = await file.path.split('/').last;

    return result;
  }
}
