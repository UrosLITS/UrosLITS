import 'package:book/models/book/book.dart';
import 'package:book/models/book/book_data.dart';
import 'package:book/presentation/bookPages/bloc/book_events.dart';
import 'package:book/presentation/bookPages/bloc/book_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookBloc extends Bloc<BookEvents, BookState> {
  BookBloc() : super((InitialState())) {
    on<NextPageEvent>(_onNextPage);
    on<PreviousPageEvent>(_onPreviousPage);
    on<InitBookEvent>(_onInitBook);
  }

  late Book book;
  int currentPageIndex = 0;

  Future<void> _onNextPage(NextPageEvent event, Emitter<BookState> emit) async {
    currentPageIndex++;
    emit(DisplayBookPageState(
        bookData: book.bookData!, pageIndex: currentPageIndex));
  }

  Future<void> _onInitBook(InitBookEvent event, Emitter<BookState> emit) async {
    this.book = event.book;
    if (book.bookData == null) {
      book.bookData = BookData(chapters: [], pages: []);
    }
    this.currentPageIndex = 0;
    emit(DisplayBookPageState(
        bookData: book.bookData!, pageIndex: currentPageIndex));
  }

  Future<void> _onPreviousPage(
      PreviousPageEvent event, Emitter<BookState> emit) async {
    currentPageIndex--;
    emit(DisplayBookPageState(
        bookData: book.bookData!, pageIndex: currentPageIndex));
  }
}
