import 'package:book/presentation/book/view/home_page_view.dart';
import 'package:book/presentation/login/view/login_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const String HomeRoute = '/';
const String LoginRoute = '/Login';

class AppRoutes {
  static Route<dynamic>? onGenerateRoutes(RouteSettings setting) {
    switch (setting.name) {
      case HomeRoute:
        return _materialRoute(const HomeBookPageView());
      case LoginRoute:
        return _materialRoute(const LoginPage());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
