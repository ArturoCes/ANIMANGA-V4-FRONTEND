import 'package:animangav4frontend/pages/detail_page.dart';
import 'package:animangav4frontend/pages/mangas_page.dart';
import 'package:animangav4frontend/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_event.dart';
import 'blocs/authentication/authentication_state.dart';
import 'config/locator.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'services/authentication_service.dart';

Future<void> main() async {
  await GetStorage.init();
  //WidgetsFlutterBinding.ensureInitialized();
  //await SharedPreferences.getInstance();
  setupAsyncDependencies();
  configureDependencies();
  //await getIt.allReady();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Authentication Demo',
        theme: ThemeData(
            primarySwatch: Colors.teal,
            appBarTheme: AppBarTheme(backgroundColor: Colors.teal)),
        initialRoute: "/login",
        routes: {
          '/login': (context) => const LoginPage(),
          '/manga': (context) => const MangasPage(),
          '/register': (context) => RegisterPage(),
          '/detail': (context) => const DetailMangaPage(manga: manga),
        });
  }
}
