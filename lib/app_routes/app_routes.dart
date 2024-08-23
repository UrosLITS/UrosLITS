import 'package:book/presentation/book/view/home_page_view.dart';
import 'package:book/presentation/login/view/login_page_view.dart';
import 'package:book/presentation/register/view/register_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const String HomeRoute = '/';
const String LoginRoute = '/Login';
const String RegisterRoute = '/Register';

class AppRoutes {
  static Route<dynamic>? onGenerateRoutes(RouteSettings setting) {
    switch (setting.name) {
      case HomeRoute:
        return _materialRoute(const HomePageView());
      case LoginRoute:
        return _materialRoute(const LoginPage());
      case RegisterRoute:
        return _materialRoute(const RegisterPageView());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
