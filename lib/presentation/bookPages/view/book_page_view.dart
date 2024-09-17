import 'package:book/app_routes/app_routes.dart';
import 'package:book/enums/page_mode.dart';
import 'package:book/models/book/book_imports.dart';
import 'package:book/presentation/bookPages/bloc/book_bloc.dart';
import 'package:book/presentation/bookPages/widgets/build_page_body.dart';
import 'package:book/presentation/bookPages/widgets/chapter_list_view.dart';
import 'package:book/presentation/common/common.dart';
import 'package:book/presentation/common/custom_dialog.dart';
import 'package:book/styles/app_styles.dart';
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
  List<BookChapter> bookChaptersList = [];
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
          bookChaptersList = state.bookData.chapters;
        } else if (state is InitialState) {
          context.read<BookBloc>().add(InitBookEvent(widget.book));
        }
      },
      builder: (BuildContext context, Object? state) {
        if (state is DisplayBookPageState) {
          return WillPopScope(
              child: Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    backgroundColor: Colors.brown.withOpacity(0.8),
                    actions: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Visibility(
                          visible: bookPagesList.length > 0,
                          child: IconButton(
                            onPressed: () async {
                              BookPage bookPage = BookPage(
                                  pageNumber:
                                      bookPagesList[currentIndex].pageNumber,
                                  text: bookPagesList[currentIndex].text,
                                  bookPageImage: bookPagesList[currentIndex]
                                      .bookPageImage);
                              BookPage? result =
                                  await Navigator.pushNamed<dynamic>(
                                context,
                                kAddNewPageRoute,
                                arguments: <String, dynamic>{
                                  'bookPage': bookPage,
                                  'pagesList': bookPagesList,
                                  'bookID': widget.book.id,
                                  'pageMode': PageMode.editMode,
                                  'chapterList': bookChaptersList
                                },
                              );
                              if (result != null) {
                                context
                                    .read<BookBloc>()
                                    .add(PageEditedEvent(bookPage: result));
                              } else {
                                context
                                    .read<BookBloc>()
                                    .add(InitBookEvent(widget.book));
                              }
                            },
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
                        : Text('Chapter title'),
                  ),
                  drawer: Drawer(
                    child: bookChaptersList.isNotEmpty
                        ? Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    child: Container(
                                      margin: EdgeInsets.all(48),
                                      child: Text(
                                        widget.book.title,
                                        maxLines: 5,
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.titleDrawer(),
                                      ),
                                    ),
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                widget.book.imageUrl))),
                                  ),
                                  Flexible(
                                    child: ChapterListView(
                                      bookpages: bookPagesList,
                                      bookchaptersList: bookChaptersList,
                                      onPagePressed: (pageNumber) {
                                        int pageIndex =
                                            bookPagesList.indexWhere((page) =>
                                                page.pageNumber == pageNumber);
                                        context.read<BookBloc>().add(
                                            NavigateToPageEvent(
                                                pageIndex: pageIndex));
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                left: 5,
                                top: 170,
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  widget.book.author,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.maybePop(context);
                                  },
                                  icon: Icon(Icons.arrow_back_ios),
                                ),
                              ),
                              Positioned(
                                  bottom: 35,
                                  left: 30,
                                  child: Text(
                                      AppLocalizations.of(context)!.go_back))
                            ],
                          )
                        : Container(
                            margin: EdgeInsets.only(bottom: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Container(
                                    margin: EdgeInsets.all(48),
                                    child: Text(
                                      maxLines: 5,
                                      widget.book.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(widget.book.imageUrl),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.maybePop(context);
                                  },
                                  icon: Icon(Icons.arrow_back),
                                ),
                              ],
                            ),
                          ),
                  ),
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
                          BookPage bookPage =
                              BookPage(pageNumber: bookPagesList.length + 1);

                          BookPage? result = await Navigator.pushNamed<dynamic>(
                            context,
                            kAddNewPageRoute,
                            arguments: <String, dynamic>{
                              'bookPage': bookPage,
                              'bookID': widget.book.id,
                              'pageMode': PageMode.addNewPage,
                              'chapterList': bookChaptersList,
                              'pagesList': bookPagesList
                            },
                          );
                          if (result != null) {
                            context.read<BookBloc>().add(AddNewPageEvent(
                                  bookPage: result,
                                ));
                          } else {
                            context
                                .read<BookBloc>()
                                .add(InitBookEvent(widget.book));
                          }
                        },
                        child: Icon(Icons.add),
                      ),
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endFloat,
                  bottomSheet:
                      bookPagesList.length > 0 ? _buildFooter() : null),
              onWillPop: () => onBackPressed(context));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<bool> onBackPressed(BuildContext context) async {
    bool? isOpened = scaffoldKey.currentState?.isDrawerOpen;

    if (isOpened != true) {
      final result = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialog(
                content: AppLocalizations.of(context)!.stop_reading_dialog);
          });
      return result;
    }
    return true;
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
                icon: Icon(Icons.arrow_back_ios),
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
                icon: Icon(Icons.arrow_forward_ios),
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
