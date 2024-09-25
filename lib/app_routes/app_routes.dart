import 'package:book/enums/page_mode.dart';
import 'package:book/models/book/book_imports.dart';
import 'package:book/presentation/book/view/add_new_book.dart';
import 'package:book/presentation/book/view/home_page_view.dart';
import 'package:book/presentation/bookPages/view/add_edit_new_page.dart';
import 'package:book/presentation/bookPages/view/book_page_view.dart';
import 'package:book/presentation/login/view/login_page_view.dart';
import 'package:book/presentation/register/view/register_page_view.dart';
import 'package:flutter/material.dart';

const String kHomeRoute = '/';
const String kLoginRoute = '/Login';
const String kRegisterRoute = '/Register';
const String kAddNewBookRoute = '/AddNewBook';
const String kBookPageRoute = '/BookPageView';
const String kAddNewPageRoute = '/AddNewPage';

class AppRoutes {
  static Route<dynamic>? onGenerateRoutes(RouteSettings setting) {
    switch (setting.name) {
      case kHomeRoute:
        return _materialRoute(const HomePageView());
      case kLoginRoute:
        return _materialRoute(const LoginPage());
      case kRegisterRoute:
        return _materialRoute(const RegisterPageView());
      case kAddNewBookRoute:
        return _materialRoute(const AddNewBook());
      case kBookPageRoute:
        return _materialRoute(BookPageView(
            book: (setting.arguments as Map<String, dynamic>)['book'] as Book,
            pageIndex:
                (setting.arguments as Map<String, dynamic>)['index'] as int?));
      case kAddNewPageRoute:
        return _materialRoute(AddEditNewPage(
          bookPage: (setting.arguments as Map<String, dynamic>)['bookPage']
              as BookPage,
          bookID:
              (setting.arguments as Map<String, dynamic>)['bookID'] as String,
          pageMode: (setting.arguments as Map<String, dynamic>)['pageMode']
              as PageMode,
          bookChapterList: (setting.arguments
              as Map<String, dynamic>)['chapterList'] as List<BookChapter>,
          bookPageList: (setting.arguments as Map<String, dynamic>)['pagesList']
              as List<BookPage>,
        ));
    }

    return null;
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
