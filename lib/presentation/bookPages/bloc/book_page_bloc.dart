import 'package:book/presentation/bookPages/bloc/book_page_events.dart';
import 'package:book/presentation/bookPages/bloc/book_page_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookPagesBloc extends Bloc<BookPagesEvents, BookPagesState> {
  BookPagesBloc() : super((InitialState())) {
    on<NextPageEvent>(_onNextPage);
    on<PreviousPageEvent>(_onPreviousPage);
  }

  Future<void> _onNextPage(
      NextPageEvent event, Emitter<BookPagesState> emit) async {
    emit(NextPage(currentIndex: event.currentIndex + 1));
  }

  Future<void> _onPreviousPage(
      PreviousPageEvent event, Emitter<BookPagesState> emit) async {
    try {
      emit(PreviousPage(currentIndex: event.currentIndex - 1));
    } on Exception catch (e) {
      emit(ErrorState(error: e));
    }
  }
}
