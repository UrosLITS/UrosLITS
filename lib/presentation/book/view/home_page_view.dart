import 'dart:convert';

import 'package:book/app_routes/app_routes.dart';
import 'package:book/data/firebase_firestore/firebase_db_manager.dart';
import 'package:book/data/local_notifications.dart';
import 'package:book/models/app_user.dart';
import 'package:book/models/app_user_singleton.dart';
import 'package:book/models/book/book.dart';
import 'package:book/presentation/book/bloc/home_page_bloc.dart';
import 'package:book/presentation/common/common.dart';
import 'package:book/presentation/common/custom_dialog.dart';
import 'package:book/styles/app_styles.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  late AppUser appUser;

  @override
  void initState() {
    appUser = AppUserSingleton.instance.appUser!;
    FirebaseMessaging.instance.subscribeToTopic("books");

    LocalNotificationsService.instance.initializeLocalNotification();
    LocalNotificationsService.instance.onNotificationClick.stream
        .listen(onNotificationListener);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        LocalNotificationsService.instance.showLocalNotification(message);
      }
    });

    context.read<HomePageBloc>().add(DownloadBooksEvent());

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
        } else if (state is SuccessfulBookAddedState) {
          context.read<HomePageBloc>().add(DownloadBooksEvent());
        } else if (state is BooksDownloadedState) {
          bookList = [];
          bookList.addAll(state.bookList);
        } else if (state is ErrorHomeState) {
          CustomSnackBar.showSnackBar(
              color: Colors.red,
              content: AppLocalizations.of(context)!.error,
              context: context);
        } else if (state is DataRetrieved) {
          Navigator.pushNamed(context, kBookPageRoute, arguments: state.book);
        } else if (state is SignOutState) {
          Navigator.pushReplacementNamed(context, kLoginRoute);
        }
      },
      builder: (BuildContext context, Object? state) {
        return WillPopScope(
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () async {
                    Navigator.maybePop(context);

                    final result = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialog(
                            content: AppLocalizations.of(context)!.log_out);
                      },
                    );
                    if (result == true) {
                      context.read<HomePageBloc>().add(SignOutEvent());
                    }
                  },
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
                visible: appUser.isAdmin,
                child: FloatingActionButton(
                  onPressed: () async {
                    final Book? result = await Navigator.pushNamed<dynamic>(
                        context, kAddNewBookRoute);

                    if (result != null) {
                      context
                          .read<HomePageBloc>()
                          .add(NewBookAddedEvent(book: result));
                    }
                  },
                  child: Icon(CupertinoIcons.add),
                ),
              ),
            ),
            onWillPop: () => logOut(context));
      },
    );
  }

  void listenForStateChanges(context, state) {}

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
        onTap: () async {
          Navigator.pushNamed(context, kBookPageRoute,
              arguments: <String, dynamic>{'book': book});
        },
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

  void onNotificationListener(String? payload) async {
    if (payload != null) {
      int currentIndex = 0;
      final data = jsonDecode(payload);
      if (data['action'] == 'pageChanged') {
        final pageIndex = data['index'];
        currentIndex = int.parse(pageIndex);

        Book bookInfo =
            await FirebaseDbManager.instance.downloadBookInfo(data['bookId']);

        Book bookResult = new Book(
          author: bookInfo.author,
          title: bookInfo.title,
          id: bookInfo.id,
          imageUrl: bookInfo.imageUrl,
        );
        Navigator.pushNamedAndRemoveUntil(
            context,
            kBookPageRoute,
            arguments: <String, dynamic>{
              'book': bookResult,
              'index': currentIndex,
            },
            (route) => route.isFirst);
      } else if (data['action'] == 'bookAdded') {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }
  }

  Future<bool> logOut(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(content: AppLocalizations.of(context)!.log_out);
      },
    );
    if (result == true) {
      context.read<HomePageBloc>().add(SignOutEvent());
    } else {
      return false;
    }
    return result;
  }
}
