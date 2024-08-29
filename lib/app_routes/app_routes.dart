import 'package:book/presentation/book/add_new_book_page.dart';
import 'package:book/presentation/book/view/home_page_view.dart';
import 'package:book/presentation/login/view/login_page_view.dart';
import 'package:book/presentation/register/view/register_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const String kHomeRoute = '/';
const String kLoginRoute = '/Login';
const String kRegisterRoute = '/Register';
const String kAddNewBookPage = '/AddNewBookPage';

class AppRoutes {
  static Route<dynamic>? onGenerateRoutes(RouteSettings setting) {
    switch (setting.name) {
      case kHomeRoute:
        return _materialRoute(const HomePageView());
      case kLoginRoute:
        return _materialRoute(const LoginPage());
      case kRegisterRoute:
        return _materialRoute(const RegisterPageView());
      case kAddNewBookPage:
        return _materialRoute(const AddNewBookPage());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
