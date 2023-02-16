import 'package:animangav4frontend/blocs/authentication/authentication_bloc.dart';
import 'package:animangav4frontend/blocs/authentication/authentication_event.dart';
import 'package:animangav4frontend/blocs/login/login_event.dart';
import 'package:animangav4frontend/blocs/login/login_state.dart';
import 'package:animangav4frontend/services/authentication_service.dart';
import 'package:bloc/bloc.dart';

import '../../exceptions/authentication_exception.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc _authenticationBloc;
  final AuthenticationService _authenticationService;

  LoginBloc(AuthenticationBloc authenticationBloc,
      AuthenticationService authenticationService)
      : assert(authenticationBloc != null),
        assert(authenticationService != null),
        _authenticationBloc = authenticationBloc,
        _authenticationService = authenticationService,
        super(LoginInitial()) {
    on<LoginInWithUsernameButtonPressed>(__onLogingInWithEmailButtonPressed);
  }

  __onLogingInWithEmailButtonPressed(
    LoginInWithUsernameButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final user = await _authenticationService.signInWithEmailAndPassword(
          event.username, event.password);
      if (user != null) {
        _authenticationBloc.add(UserLoggedIn(user: user));
        emit(LoginSuccess());
        emit(LoginInitial());
      } else {
        emit(LoginFailure(error: 'Something very weird just happened'));
      }
    } on AuthenticationException catch (e) {
      emit(LoginFailure(error: e.message));
    } on Exception catch (err) {
      emit(LoginFailure(error: 'An unknown error occurred ${err.toString()}'));
    }
  }
}
