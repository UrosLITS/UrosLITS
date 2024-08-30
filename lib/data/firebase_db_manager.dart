import 'dart:io';
import 'package:book/core/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseDbManager {
  static final db = FirebaseFirestore.instance;
  static final storage = FirebaseStorage.instance.ref();

  static Future<String> AddBookImage(File? imageFile) async {
    final timeStamp = DateTime.now();

    final fileRef = storage.child('${timeStamp.toString()}');
    File file = File(imageFile!.path);

    await fileRef.putFile(file).timeout(Duration(seconds: 3), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });

    final url = await fileRef.getDownloadURL().timeout(Duration(seconds: 3),
        onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });
    return Future.value(url);
  }
}
