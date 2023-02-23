import 'package:animangav4frontend/models/edit_user_dto.dart';
import 'package:animangav4frontend/models/user.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../repositories/user_repository.dart';

abstract class UserServiceI {
  Future<User> uploadImage(String filename, String id, String tipo);
  Future<User> userLogged();
  Future<dynamic> edit(EditUserDto editUserDto, String id);
}

@Order(6)
@singleton
class UserService extends UserServiceI{
  late UserRepository _userRepository;

  UserService() {
    _userRepository = GetIt.I.get<UserRepository>();
  }

  @override
  Future<User> uploadImage(String filename, String id, String tipo) async {
  dynamic response = await _userRepository.uploadImage(filename, id,tipo);
    return response;
  }

  @override
  Future<User> userLogged() async {
    dynamic response = await _userRepository.userLogged();
    if (response != null) {
      return response;
    } else {
      throw Exception("Upss, algo ha salido mal");
    }
  }

  @override
  Future<User> edit(EditUserDto editUserDto, String id) async {
    dynamic response = await _userRepository.edit(editUserDto, id);
    return response;
  
  }
}
