import 'package:book/app_routes/app_routes.dart';
import 'package:book/data/firebase_auth/firebase_auth_singleton.dart';
import 'package:book/models/app_user_singleton.dart';
import 'package:book/models/book/book.dart';
import 'package:book/presentation/book/bloc/home_page_bloc.dart';
import 'package:book/presentation/bookPages/bloc/book_bloc.dart';
import 'package:book/presentation/login/bloc/login_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import 'data/firebase_firestore/firebase_db_manager.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Permission.notification.request();
  await AppUserSingleton.instance.setUser();
  FirebaseMessaging.instance.getInitialMessage().then((message) async {
    if (message?.notification != null) {
      Map<String, dynamic> data = message!.data;

      int index = 0;
      if (data['action'] == 'pageChanged') {
        if (data['index'] != null) {
          index = int.parse(data['index']);
        }

        final bookInfo =
            await FirebaseDbManager.instance.downloadBookInfo(data['bookId']);
        Book book = new Book(
          author: bookInfo.author,
          title: bookInfo.title,
          id: bookInfo.id,
          imageUrl: bookInfo.imageUrl,
        );

        Navigator.pushNamed<dynamic>(
            navigatorKey.currentState!.context, kBookPageRoute,
            arguments: <String, dynamic>{
              'book': book,
              'index': index,
            });
      } else if (data['action'] == 'bookAdded') {
        Navigator.popUntil(
            navigatorKey.currentState!.context, (route) => route.isFirst);
      }
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    if (message.notification != null) {
      Map<String, dynamic> data = message.data;

      int index = 0;
      if (data['action'] == 'pageChanged') {
        if (data['index'] != null) {
          index = int.parse(data['index']);
        }

        final bookInfo =
            await FirebaseDbManager.instance.downloadBookInfo(data['bookId']);
        Book book = new Book(
          author: bookInfo.author,
          title: bookInfo.title,
          id: bookInfo.id,
          imageUrl: bookInfo.imageUrl,
        );

        Navigator.pushNamedAndRemoveUntil<dynamic>(
            navigatorKey.currentState!.context,
            kBookPageRoute,
            (route) => route.isFirst,
            arguments: <String, dynamic>{
              'book': book,
              'index': index,
            });
      } else if (data['action'] == 'bookAdded') {
        Navigator.popUntil(
            navigatorKey.currentState!.context, (route) => route.isFirst);
      }
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (BuildContext context) => LoginBloc()),
        BlocProvider<HomePageBloc>(
            create: (BuildContext context) => HomePageBloc()),
        BlocProvider<BookBloc>(create: (BuildContext context) => BookBloc()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        onGenerateRoute: AppRoutes.onGenerateRoutes,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],


      ),
    );
  }
}
