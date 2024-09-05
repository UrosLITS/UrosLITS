import 'package:book/presentation/bookPages/bloc/book_events.dart';
import 'package:book/presentation/bookPages/bloc/book_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookBloc extends Bloc<BookEvents, BookState> {
  BookBloc() : super((InitialState())) {
    on<NextPageEvent>(_onNextPage);
    on<PreviousPageEvent>(_onPreviousPage);
  }

  Future<void> _onNextPage(NextPageEvent event, Emitter<BookState> emit) async {
    emit(NextPage());
  }

  Future<void> _onPreviousPage(
      PreviousPageEvent event, Emitter<BookState> emit) async {
    emit(PreviousPage());
  }
}
