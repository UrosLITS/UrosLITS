import 'dart:io';
import 'package:book/core/constants.dart';
import 'package:book/models/book/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseDbManager {
  static FirebaseDbManager? _instance;
  late FirebaseFirestore db;
  late Reference storageRef;
  late FirebaseStorage storage;

  FirebaseDbManager.internal() {
    db = FirebaseFirestore.instance;
    storage = FirebaseStorage.instance;
    storageRef = storage.ref();
  }

  factory FirebaseDbManager() {
    if (_instance == null) {
      _instance = FirebaseDbManager.internal();
    }
    return _instance!;
  }

  static FirebaseDbManager get instance => FirebaseDbManager();

  Future<String> uploadBookImage(File? imageFile) async {
    final timeStamp = DateTime.now();

    final fileRef = storageRef.child('${timeStamp.toString()}');
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

  Future<void> addBookToServer(Book book) async {
    final bookRef = db.collection("books").doc();

    await bookRef.set(book.toJson()).timeout(
      Duration(seconds: 3),
      onTimeout: () {
        throw Exception(timeoutErrorMessage);
      },
    );
  }

  Future<List<Book>> downloadBooks() async {
    final querySnapshots = await db.collection('books').get();
    final List<Book> books = [];
    for (final item in querySnapshots.docs) {
      books.add(Book.fromJson(item.data(), item.id));
    }

    return Future.value(books);
  }
}
