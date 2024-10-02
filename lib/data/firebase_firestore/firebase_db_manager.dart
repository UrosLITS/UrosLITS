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

    await fileRef.putFile(file).timeout(Duration(seconds: timeoutDuration),
        onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });

    final url = await fileRef
        .getDownloadURL()
        .timeout(Duration(seconds: timeoutDuration), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });
    return Future.value(url);
  }

  Future<void> addBookToServer(Book book) async {
    final bookRef = db.collection(booksCollection).doc();

    await bookRef.set(book.toJson()).timeout(
      Duration(seconds: timeoutDuration),
      onTimeout: () {
        throw Exception(timeoutErrorMessage);
      },
    );
  }

  Future<Book> downloadBookInfo(String bookID) async {
    final ref = db.collection(booksCollection).doc(bookID);

    final snapShot = await ref.get().timeout(Duration(seconds: timeoutDuration),
        onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });
    final result = Book.fromJson(snapShot.data()!, bookID);

    return Future.value(result);
  }

  Future<List<Book>> downloadBooks() async {
    final querySnapshots = await db
        .collection(booksCollection)
        .get()
        .timeout(Duration(seconds: timeoutDuration), onTimeout: () {
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

    final snapShoot = await booksRef
        .get()
        .timeout(Duration(seconds: timeoutDuration), onTimeout: () {
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
    final snapShoots = await chapterRefs
        .get()
        .timeout(Duration(seconds: timeoutDuration), onTimeout: () {
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
    await fileRef.putFile(file).timeout(Duration(seconds: timeoutDuration),
        onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });

    final url = await fileRef
        .getDownloadURL()
        .timeout(Duration(seconds: timeoutDuration), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });
    bookPage.bookPageImage?.url = url;
    return Future.value(true);
  }

  Future<List<BookPage>> addPagesToServer(
      List<BookPage> bookPagesList, String id) async {
    final booksRef = db.collection(pagesCollection).doc(id);
    await booksRef.set({
      collectionItems: bookPagesList.map((page) => page.toJson()).toList()
    }).timeout(Duration(seconds: timeoutDuration), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });

    return bookPagesList;
  }

  Future<List<BookChapter>> addChapterToServer(
      List<BookChapter> bookChaptersList, String id) async {
    final chapterRef = db.collection(chaptersCollection).doc(id);

    await chapterRef.set({
      collectionItems:
          bookChaptersList.map((chapter) => chapter.toJson()).toList()
    }).timeout(Duration(seconds: timeoutDuration), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });

    return bookChaptersList;
  }

  Future<List<BookPage>> updatePage(
      List<BookPage> bookPagesList, String id) async {
    final booksRef = db.collection(pagesCollection).doc(id);

    await booksRef.update({
      collectionItems: bookPagesList.map((chapter) => chapter.toJson()).toList()
    }).timeout(Duration(seconds: timeoutDuration), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });
    return bookPagesList;
  }

  Future<bool> deletePage(BookPage bookPage, String id) async {
    final pageNumberToDel = bookPage.pageNumber;
    final docRef = db.collection(pagesCollection).doc(id);

    final snapShoot = await docRef
        .get()
        .timeout(Duration(seconds: timeoutDuration), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });

    final List<dynamic>? items = snapShoot.data()?[collectionItems];

    items?.removeWhere((item) => item[numberField] == pageNumberToDel);

    if (items != null) {
      for (final item in items) {
        if (item[numberField] > pageNumberToDel) {
          item[numberField] = item[numberField] - 1;
        }
      }
    }

    if (bookPage.bookPageImage != null) {
      final imageRef = storageRef.child(bookPage.bookPageImage!.storagePath!);
      await imageRef.delete().timeout(Duration(seconds: timeoutDuration),
          onTimeout: () {
        throw Exception(timeoutErrorMessage);
      });
    }

    await docRef.update({collectionItems: items}).timeout(
        Duration(seconds: timeoutDuration), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });
    return Future.value(true);
  }

  Future<BookData> downloadBookData(String id) async {
    List<BookPage> bookPages = [];
    List<BookChapter> chapters = [];

    final booksRef = db.collection(pagesCollection).doc(id);

    final snapShoot = await booksRef
        .get()
        .timeout(Duration(seconds: timeoutDuration), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });
    final data = snapShoot.data();
    final List<dynamic>? items = data?[collectionItems] ?? [];
    if (items != null) {
      for (final item in items) {
        if (item != null) {
          bookPages.add(BookPage.fromJson(item));
        }
      }
    }

    final chapterRefs = db.collection(chaptersCollection).doc(id);
    final snapShoots = await chapterRefs
        .get()
        .timeout(Duration(seconds: timeoutDuration), onTimeout: () {
      throw Exception(timeoutErrorMessage);
    });
    final Data = snapShoots.data();
    final List<dynamic>? Items = Data?[collectionItems] ?? [];
    if (Items != null) {
      for (final item in Items) {
        if (item != null) {
          chapters.add(BookChapter.fromJson(item));
        }
      }
    }

    BookData bookData = BookData(chapters: chapters, pages: bookPages);

    return Future.value(bookData);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> downloadBooksStream() async* {
    yield* db.collection("books").snapshots();
  }
}
