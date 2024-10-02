part of 'home_page_bloc.dart';

sealed class HomePageEvent extends Equatable {}

class AddNewBookEvent extends HomePageEvent {
  AddNewBookEvent({
    required this.title,
    required this.author,
    required this.imageFile,
  });

  final String author;
  final String title;
  final File imageFile;

  @override
  List<Object?> get props => [
        title,
        author,
        imageFile,
      ];
}

class NewBookAddedEvent extends HomePageEvent {
  NewBookAddedEvent({required this.book});

  final Book book;

  @override
  List<Object?> get props => [
        book,
        Random().nextInt(10000),
      ];
}

class DeleteBookImageEvent extends HomePageEvent {
  @override
  List<Object?> get props => [];
}

class AddBookImageEvent extends HomePageEvent {
  AddBookImageEvent({required this.file});

  final File file;

  @override
  List<Object?> get props => [
        file,
        Random().nextInt(10000),
      ];
}

class GetBookDataEvent extends HomePageEvent {
  GetBookDataEvent({required this.book});

  final Book book;

  @override
  List<Object?> get props => [
        book,
        Random().nextInt(10000),
      ];
}

class SignOutEvent extends HomePageEvent {
  @override
  List<Object?> get props => [];
}

class NotificationListenerEvent extends HomePageEvent {
  NotificationListenerEvent({required this.payload});

  final String payload;

  @override
  List<Object?> get props => [payload];
}

class GetBookListEvent extends HomePageEvent {
  GetBookListEvent({required this.querySnapshot});

  final QuerySnapshot<Map<String, dynamic>> querySnapshot;

  @override
  List<Object?> get props => [querySnapshot];
}
