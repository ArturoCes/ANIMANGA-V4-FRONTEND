import 'package:animangav4frontend/models/edit_user_dto.dart';
import 'package:animangav4frontend/models/errors.dart';
import 'package:animangav4frontend/models/user.dart';
import 'package:animangav4frontend/services/authentication_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_event.dart';
part 'edit_state.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  final AuthenticationService _userService;

  EditUserBloc(JwtAuthenticationService userService)
      : assert(userService != null),
        _userService = userService,
        super(EditUserInitial()) {
    on<EditOneUserEvent>(_editProfile);
  }

  void _editProfile(EditOneUserEvent event, Emitter<EditUserState> emit) async {
    try {
      var user = await _userService.edit(event.editUserDto, event.id);

      emit(EditUserSuccessState(user as User));
    } on ErrorResponse catch (e) {
      emit(EditUserErrorState(e));
    }
  }
}
