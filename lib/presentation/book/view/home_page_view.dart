import 'package:book/app_routes/app_routes.dart';
import 'package:book/models/book/book.dart';
import 'package:book/presentation/book/bloc/home_page_bloc.dart';
import 'package:book/presentation/common/common.dart';
 import 'package:book/styles/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomeBookPageView();
}

class _HomeBookPageView extends State<HomePageView> {
  late final _controller;
  late List<Book> bookList = [];

  @override
  void initState() {
    context.read<HomePageBloc>().add(DownloadBooks());

    _controller = PageController(viewportFraction: 0.9, initialPage: 0);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageState>(
      listener: (context, state) {
        if (state is LoadingState) {
          DialogUtils.showLoadingScreen(context);
        } else if (state is LoadedState) {
          Navigator.pop(context);
        } else if (state is SuccessfulBookAdded) {
          context.read<HomePageBloc>().add(DownloadBooks());
        } else if (state is BooksDownloadedState) {
          bookList.addAll(state.bookList);
        }
      },
      builder: (BuildContext context, Object? state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.exit_to_app),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(AppLocalizations.of(context)!.pick_any_book),
          ),
          body: SizedBox(
            height: 500,
            child: PageView.builder(
              pageSnapping: true,
              controller: _controller,
              itemCount: bookList.length,
              itemBuilder: (context, index) =>
                  _buildBookItem(bookList.elementAt(index)),
            ),
          ),
          floatingActionButton: Visibility(
            visible: true,
            child: FloatingActionButton(
              onPressed: () async {
                final Book? result = await Navigator.pushNamed<dynamic>(
                    context, kAddNewBookRoute);

                if (result != null) {
                  context
                      .read<HomePageBloc>()
                      .add(NewBookAdded(book: result));
                }
              },
              child: Icon(CupertinoIcons.add),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookItem(Book book) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      margin: EdgeInsets.only(right: 24),
      child: GestureDetector(
        onDoubleTap: () {
          return null;
        },
        onTap: () async {},
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                image: DecorationImage(
                    image: NetworkImage(book.imageUrl), fit: BoxFit.cover),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.1)
                      ],
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(book.title, style: AppTextStyles.bookCardTitle()),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Text(
                            AppLocalizations.of(context)!.author +
                                ": " +
                                book.author,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
