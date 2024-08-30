import 'package:book/data/firebase_firestore/firebase_db_manager.dart';
import 'package:book/models/book.dart';
import 'package:book/presentation/book/bloc/home_page_event.dart';
import 'package:book/presentation/book/bloc/home_page_state.dart';
import 'package:book/utils/file_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super((InitialState())) {
    on<AddNewBook>(_onBookAdded);
    on<RefreshBooks>(_onRefreshBooks);
    on<AddBookImageEvent>(_onAddBookImage);
    on<DeleteBookImage>(_onDeleteBookImage);
  }

  Future<void> _onBookAdded(
      AddNewBook event, Emitter<HomePageState> emit) async {
    emit(LoadingState());

    final urlResult =
        await FirebaseDbManager.internal().AddBookImage(event.imageFile);

    final Book? result = new Book(
        author: event.author, title: event.title, imageUrl: urlResult, id: '');

    emit(LoadedState());
    emit(SuccessfulBookAdded(book: result!));
  }

  Future<void> _onAddBookImage(
      AddBookImageEvent event, Emitter<HomePageState> emit) async {
    emit(LoadingState());

    final result = await FileUtils.getFileName(event.file);

    emit(LoadedState());
    emit(SuccessfulImageAdded(imageName: result));
  }

  Future<void> _onDeleteBookImage(
      DeleteBookImage event, Emitter<HomePageState> emit) async {
    emit(LoadingState());

    emit(LoadedState());
    emit(SuccessfulImageDeleted());
  }

  Future<void> _onRefreshBooks(
      RefreshBooks event, Emitter<HomePageState> emit) async {}
}
