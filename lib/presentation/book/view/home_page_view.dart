import 'dart:ffi';

import 'package:book/app_routes/app_routes.dart';
import 'package:book/models/app_user.dart';
import 'package:book/models/app_user_singleton.dart';
import 'package:book/models/book.dart';
import 'package:book/styles/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  late Book book;

  bool shouldAbsorb = true;

  @override
  void initState() {
    final singleton = AppUserSingleton();

    appUser = singleton.appUser!;

    _controller = PageController(viewportFraction: 0.9, initialPage: 0);

    book = new Book(
        author: 'author',
        title: 'title',
        url:
            'https://images.unsplash.com/reserve/bOvf94dPRxWu0u3QsPjF_tree.jpg?ixlib=rb-4.0.3',
        id: 'id');
    bookList.add(book);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          itemCount: 3,
          itemBuilder: (context, index) => _buildBookItem(),
        ),
      ),
      floatingActionButton: Visibility(
        visible: appUser.isAdmin == true,
        child: FloatingActionButton(
          onPressed: () async {
            final Book? result =
                await Navigator.pushNamed<dynamic>(context, kAddNewBookPage);

            if (result != null) {
              bookList.add(result);
              setState(() {});
            }
          },
          child: Icon(CupertinoIcons.add),
        ),
      ),
    );
  }

  Widget _buildBookItem() {
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
                    image: NetworkImage(book.url), fit: BoxFit.cover),
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
