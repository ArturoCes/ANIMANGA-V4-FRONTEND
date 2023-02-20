import 'package:animangav4frontend/blocs/login/login_event.dart';
import 'package:animangav4frontend/blocs/login/login_state.dart';
import 'package:animangav4frontend/services/authentication_service.dart';
import 'package:bloc/bloc.dart';
import 'package:get_storage/get_storage.dart';

import '../../exceptions/authentication_exception.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationService _authenticationService;
  final box = GetStorage();
  LoginBloc(AuthenticationService authenticationService)
      : assert(authenticationService != null),
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
      final user = await _authenticationService
          .signInWithEmailAndPassword(event.loginDto);
      if (user != null) {
        box.write('token', user.token);
        emit(LoginSuccess());
      }
    } on Exception catch (err) {
      emit(LoginFailure(error: 'An unknown error occurred ${err.toString()}'));
    }
  }
}
