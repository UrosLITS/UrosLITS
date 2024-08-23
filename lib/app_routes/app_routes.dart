import 'package:book/presentation/book/view/home_page_view.dart';
import 'package:book/presentation/login/view/login_page_view.dart';
import 'package:book/presentation/register/view/register_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const String homeRoute = '/';
const String loginRoute = '/Login';
const String registerRoute = '/Register';

class AppRoutes {
  static Route<dynamic>? onGenerateRoutes(RouteSettings setting) {
    switch (setting.name) {
      case homeRoute:
        return _materialRoute(const HomePageView());
      case loginRoute:
        return _materialRoute(const LoginPage());
      case registerRoute:
        return _materialRoute(const RegisterPageView());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
