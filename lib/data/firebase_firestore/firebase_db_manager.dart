import 'dart:io';

import 'package:book/core/constants.dart';
import 'package:book/models/book/book_imports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseDbManager {
  static FirebaseDbManager? _instance;
  late FirebaseFirestore db;
  late Reference storageRef;
  late FirebaseStorage storage;

  FirebaseDbManager._internal() {
    db = FirebaseFirestore.instance;
    storage = FirebaseStorage.instance;
    storageRef = storage.ref();
  }

  factory FirebaseDbManager() {
    if (_instance == null) {
      _instance = FirebaseDbManager._internal();
    }
    return _instance!;
  }

  static FirebaseDbManager get instance => FirebaseDbManager();

  Future<String> uploadBookImage(File? imageFile, String bookTitle) async {
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
    final bookRef = db.collection(booksCollection).doc();

    await bookRef.set(book.toJson()).timeout(
      Duration(seconds: 3),
      onTimeout: () {
        throw Exception(timeoutErrorMessage);
      },
    );
  }

  Future<List<Book>> downloadBooks() async {
    final querySnapshots = await db
        .collection(booksCollection)
        .get()
        .timeout(Duration(seconds: 3), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });

    final List<Book> books = [];
    for (final item in querySnapshots.docs) {
      books.add(Book.fromJson(item.data(), item.id));
    }

    return Future.value(books);
  }

  Future<BookData> getBookData(String bookID) async {
    List<BookPage> bookPagesList = [];
    List<BookChapter> bookChaptersList = [];

    final booksRef = db.collection(pagesCollection).doc(bookID);

    final snapShoot =
        await booksRef.get().timeout(Duration(seconds: 3), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });
    final data = snapShoot.data();
    final List<dynamic>? items = data?[collectionItems] ?? [];
    if (items != null) {
      for (final item in items) {
        if (item != null) {
          bookPagesList.add(BookPage.fromJson(item));
        }
      }
    }

    final chapterRefs = db.collection(chaptersCollection).doc(bookID);
    final snapShoots =
        await chapterRefs.get().timeout(Duration(seconds: 3), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });
    final chaptersData = snapShoots.data();
    final List<dynamic>? chapterItems = chaptersData?[collectionItems] ?? [];
    if (chapterItems != null) {
      for (final item in chapterItems) {
        if (item != null) {
          bookChaptersList.add(BookChapter.fromJson(item));
        }
      }
    }

    BookData bookData =
        BookData(chapters: bookChaptersList, pages: bookPagesList);

    return Future.value(bookData);
  }

  Future<bool> addImageToServer(
      BookPage bookPage, File imageFile, String id) async {
    final timeStamp = DateTime.now();
    final fileRef = storageRef.child("${id}/${timeStamp.toString()}");
    final storagePath = fileRef.fullPath;
    bookPage.bookPageImage?.storagePath = storagePath;
    File file = File(imageFile.path);
    await fileRef.putFile(file).timeout(Duration(seconds: 3), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });

    final url = await fileRef.getDownloadURL().timeout(Duration(seconds: 3),
        onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });
    bookPage.bookPageImage?.url = url;
    return Future.value(true);
  }

  Future<List<BookPage>> addPagesToServer(
      List<BookPage> bookPagesList, String id) async {
    final booksRef = db.collection("pages").doc(id);
    await booksRef.set({
      "items": bookPagesList.map((page) => page.toJson()).toList()
    }).timeout(Duration(seconds: 3), onTimeout: () {
      throw Exception("Cant reach server");
    });

    return bookPagesList;
  }

  Future<List<BookChapter>> addChapterToServer(
      List<BookChapter> bookChaptersList, String id) async {
    final chapterRef = db.collection("chapters").doc(id);

    await chapterRef.set({
      "items": bookChaptersList.map((chapter) => chapter.toJson()).toList()
    }).timeout(Duration(seconds: 3), onTimeout: () {
      throw Exception("Cant reach server");
    });
    return bookChaptersList;
  }

  Future<List<BookPage>> updatePage(
      List<BookPage> bookPagesList, String id) async {
    final booksRef = db.collection("pages").doc(id);

    await booksRef.update({
      "items": bookPagesList.map((chapter) => chapter.toJson()).toList()
    }).timeout(Duration(seconds: 3), onTimeout: () {
      throw Exception("Cant reach server");
    });
    return bookPagesList;
  }
}
