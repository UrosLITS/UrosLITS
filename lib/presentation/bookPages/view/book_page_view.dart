import 'package:book/app_routes/app_routes.dart';
import 'package:book/enums/page_mode.dart';
import 'package:book/models/app_user.dart';
import 'package:book/models/app_user_singleton.dart';
import 'package:book/models/book/book_imports.dart';
import 'package:book/presentation/bookPages/bloc/book_bloc.dart';
import 'package:book/presentation/bookPages/widgets/build_page_body.dart';
import 'package:book/presentation/bookPages/widgets/chapter_list_view.dart';
import 'package:book/presentation/common/common.dart';
import 'package:book/presentation/common/custom_dialog.dart';
import 'package:book/styles/app_colors.dart';
import 'package:book/styles/app_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookPageView extends StatefulWidget {
  const BookPageView({
    Key? key,
    required this.book,
    this.pageIndex,
  }) : super(key: key);

  final Book book;
  final int? pageIndex;

  State<BookPageView> createState() => _BookPageView();
}

class _BookPageView extends State<BookPageView> {
  int currentIndex = 0;
  List<BookPage> bookPagesList = [];
  List<BookChapter> bookChaptersList = [];
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isMessageReceived = false;
  late AppUser appUser;

  @override
  void initState() {
    appUser = AppUserSingleton.instance.appUser!;

    if (widget.pageIndex != null) {
      isMessageReceived = true;
    }
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
          widget.book.bookData = state.bookData;
          currentIndex = state.pageIndex;
          if (isMessageReceived) {
            currentIndex = widget.pageIndex!;
            isMessageReceived = false;
          }
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
                          visible: bookPagesList.length > 0 && appUser.isAdmin,
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
                                context.read<BookBloc>().add(PageEditedEvent(
                                    bookPage: result,
                                    body: AppLocalizations.of(context)!
                                        .message_body_edit(
                                            widget.book.author,
                                            widget.book.title,
                                            bookPage.pageNumber),
                                    title: AppLocalizations.of(context)!
                                        .message_title_edit));
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
                        visible: bookPagesList.length > 0 && appUser.isAdmin,
                        child: Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: IconButton(
                            onPressed: () async {
                              final result = await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext) {
                                    return CustomDialog(
                                        content: AppLocalizations.of(context)!
                                            .delete_page);
                                  });

                              if (result == true) {
                                context.read<BookBloc>().add(DeletePageEvent(
                                      body: AppLocalizations.of(context)!
                                          .message_body_delete(
                                        widget.book.author,
                                        widget.book.title,
                                      ),
                                      title: AppLocalizations.of(context)!
                                          .message_title_delete,
                                    ));
                              } else {
                                context
                                    .read<BookBloc>()
                                    .add(InitBookEvent(widget.book));
                              }
                            },
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
                        : Text(
                            bookPagesList[currentIndex].bookChapter!.chTitle!),
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
                                bottom: 20,
                                left: 20,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.maybePop(context);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.go_back,
                                    style: TextStyle(
                                        color: AppColors.black,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Stack(
                            children: [
                              Column(
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
                                        image:
                                            NetworkImage(widget.book.imageUrl),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
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
                                bottom: 20,
                                left: 20,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.maybePop(context);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.go_back,
                                    style: TextStyle(
                                        color: AppColors.black,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              )
                            ],
                          ),
                  ),
                  body: bookPagesList.length > 0
                      ? _buildPageBody(bookPagesList[currentIndex])
                      : Center(
                          child: Text(AppLocalizations.of(context)!.add_pages),
                        ),
                  floatingActionButton: Visibility(
                    visible: appUser.isAdmin,
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
                                  title: AppLocalizations.of(context)!
                                      .message_title_add,
                                  body: AppLocalizations.of(context)!
                                      .message_body_add(
                                    widget.book.author,
                                    widget.book.title,
                                    result.pageNumber,
                                  ),
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
              onWillPop: () async {
                return await onBackPressed(context);
              });
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
                onPressed: isNotFirstPage
                    ? () {
                        context
                            .read<BookBloc>()
                            .add(PreviousPageEvent(currentIndex: currentIndex));
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
                onPressed: isNotLastPage
                    ? () {
                        if (currentIndex < bookPagesList.length - 1) {
                          context
                              .read<BookBloc>()
                              .add(NextPageEvent(currentIndex: currentIndex));
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

  bool get isNotLastPage =>
      bookPagesList[currentIndex].pageNumber < bookPagesList.length;

  bool get isNotFirstPage => bookPagesList[currentIndex].pageNumber > 1;

  Widget _buildPageBody(BookPage bookPage) {
    return Container(
        color: Colors.grey.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 200.0 : 20),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity! < 0 && isNotLastPage) {
              context
                  .read<BookBloc>()
                  .add(SwipeLeftEvent(currentIndex: currentIndex));
            } else if (details.primaryVelocity! > 0 && isNotFirstPage) {
              context
                  .read<BookBloc>()
                  .add(SwipeRightEvent(currentIndex: currentIndex));
            } else if (details.primaryVelocity == 0) {
              return;
            } else {
              final snackbar1 = SnackBar(
                  content: Text(
                      AppLocalizations.of(context)!.no_more_pages_for_swipe));
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(snackbar1);
              return;
            }
          },
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              (bookPage.bookPageImage?.url == null)
                  ? NoImage(
                      bookPagesList: bookPagesList, currentIndex: currentIndex)
                  : bookPage.bookPageImage!.height >
                          bookPage.bookPageImage!.width
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
        ));
  }
}
