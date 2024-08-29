import 'package:book/presentation/book/bloc/home_page_event.dart';
import 'package:book/presentation/book/bloc/home_page_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super((InitialState())) {
    //on<AddBook>(_onBookAdded);
  }
}
