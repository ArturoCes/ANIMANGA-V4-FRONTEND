import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_event.dart';
import 'blocs/authentication/authentication_state.dart';
import 'config/locator.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'services/authentication_service.dart';

void main() {
  setupAsyncDependencies();
  configureDependencies();

  runApp(BlocProvider<AuthenticationBloc>(
    create: (context) {
      final authService = getIt<JwtAuthenticationService>();
      return AuthenticationBloc(authService)..add(AppLoaded());
    },
    child: animangaFrontendv4(),
  ));
}

class animangaFrontendv4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication Demo',
      theme: ThemeData(
          primarySwatch: Colors.teal,
          appBarTheme: AppBarTheme(backgroundColor: Colors.teal)),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return HomePage(
              user: state.user,
            );
          }
          return LoginPage();
        },
      ),
    );
  }
}
