import 'package:book/app_routes/app_routes.dart';
import 'package:book/models/book/book_imports.dart';
import 'package:book/presentation/bookPages/bloc/book_bloc.dart';
import 'package:book/presentation/bookPages/widgets/build_page_body.dart';
import 'package:book/presentation/common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookPageView extends StatefulWidget {
  const BookPageView({
    Key? key,
    required this.book,
  }) : super(key: key);

  final Book book;

  State<BookPageView> createState() => _BookPageView();
}

class _BookPageView extends State<BookPageView> {
  int currentIndex = 0;
  List<BookPage> bookPagesList = [];

  @override
  void initState() {
    context.read<BookBloc>().add(InitBookEvent(widget.book));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookBloc, BookState>(
      listener: (context, state) async {
        if (state is ErrorState) {
          CustomSnackBar.showSnackBar(
              color: Colors.red,
              content: AppLocalizations.of(context)!.error,
              context: context);
        } else if (state is DisplayBookPageState) {
          currentIndex = state.pageIndex;
          bookPagesList = state.bookData.pages;
        } else if (state is InitialState) {
          context.read<BookBloc>().add(InitBookEvent(widget.book));
        }
      },
      builder: (BuildContext context, Object? state) {
        if (state is DisplayBookPageState) {
          return Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.brown.withOpacity(0.8),
                  actions: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Visibility(
                        visible: bookPagesList.length > 0,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: bookPagesList.length > 0,
                      child: Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                  ],
                  title: bookPagesList.isEmpty
                      ? Text(widget.book.title)
                      : Text('Chapter title')),
              body: bookPagesList.length > 0
                  ? _buildPageBody(bookPagesList[currentIndex])
                  : Center(
                      child: Text(AppLocalizations.of(context)!.add_pages),
                    ),
              floatingActionButton: Visibility(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  // Adjust padding as needed
                  child: FloatingActionButton(
                    onPressed: () async {
                      BookPage bookPage = BookPage(
                        pageNumber: bookPagesList.length + 1,
                        text: '',
                      );

                      BookPage? result = await Navigator.pushNamed<dynamic>(
                        context,
                        kAddNewPageRoute,
                        arguments: <String, dynamic>{
                          'bookPage': bookPage,
                          'bookID': widget.book.id
                        },
                      );
                      if (result != null) {
                        context.read<BookBloc>().add(AddNewPageEvent(
                              bookPage: result,
                            ));
                      }
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              bottomSheet: bookPagesList.length > 0 ? _buildFooter() : null);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      height: 70,
      child: SafeArea(
        bottom: true,
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              child: IconButton(
                onPressed: isFirstPage
                    ? () {
                        context.read<BookBloc>().add(PreviousPageEvent());
                      }
                    : null,
                icon: Icon(CupertinoIcons.back),
              ),
            ),
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: Colors.redAccent,
              ),
              height: 50,
              width: 50,
              alignment: Alignment.center,
              child: Text(
                bookPagesList[currentIndex].pageNumber.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: isLastPage
                    ? () {
                        if (currentIndex < bookPagesList.length - 1) {
                          context.read<BookBloc>().add(NextPageEvent());
                        }
                      }
                    : null,
                icon: Icon(CupertinoIcons.forward),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get isLastPage =>
      bookPagesList[currentIndex].pageNumber < bookPagesList.length;

  bool get isFirstPage => bookPagesList[currentIndex].pageNumber > 1;

  Widget _buildPageBody(BookPage bookPage) {
    return Container(
      color: Colors.grey.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 200.0 : 20),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          (bookPage.bookPageImage?.url == null)
              ? NoImage(
                  bookPagesList: bookPagesList, currentIndex: currentIndex)
              : bookPage.bookPageImage!.height > bookPage.bookPageImage!.width
                  ? PortraitImage(
                      bookPageImage: bookPage.bookPageImage!,
                      bookPagesList: bookPagesList,
                      currentIndex: currentIndex)
                  : bookPage.bookPageImage!.width >
                          bookPage.bookPageImage!.height
                      ? LandscapeImage(
                          bookPageImage: bookPage.bookPageImage!,
                          bookPagesList: bookPagesList,
                          currentIndex: currentIndex)
                      : Spacer(),
        ],
      ),
    );
  }
}
