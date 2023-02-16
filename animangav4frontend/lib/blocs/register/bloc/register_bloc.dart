import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../services/authentication_service.dart';
import '../../authentication/authentication_bloc.dart';
import '../../authentication/authentication_event.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthenticationBloc _authenticationBloc;
  final AuthenticationService _authenticationService;

  RegisterBloc(AuthenticationBloc authenticationBloc,
      AuthenticationService authenticationService)
      : assert(authenticationBloc != null),
        assert(authenticationService != null),
        _authenticationBloc = authenticationBloc,
        _authenticationService = authenticationService,
        super(RegisterInitial()) {
    on<RegisterButtonPressed>(__onRegisterButtonPressed);
  }

  __onRegisterButtonPressed(
    RegisterButtonPressed event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      print('ButtonPressed: ' + event.username);
      final user = await _authenticationService.register(event.username,
          event.password, event.verifyPassword, event.email, event.fullName);
      if (user != null) {
        _authenticationBloc.add(UserLoggedIn(user: user));
        emit(RegisterSuccess());
      } else {
        emit(RegisterFailure(error: 'Something very weird just happened'));
      }
    } on Exception catch (e) {
      emit(RegisterFailure(error: e.toString()));
    }
  }
}
