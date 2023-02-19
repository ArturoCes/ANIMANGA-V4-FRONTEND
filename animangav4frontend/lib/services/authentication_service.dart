import 'dart:convert';
//import 'dart:developer';

import 'package:animangav4frontend/blocs/login/login_dto.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../config/locator.dart';
import '../models/login.dart';
import '../models/register.dart';
import '../models/user.dart';
import '../repositories/authenticationrepository.dart';
import 'localstorage_service.dart';



abstract class AuthenticationService {
  Future<User?> getCurrentUser();
  Future<User?> signInWithEmailAndPassword(LoginDto loginDto);
  Future<User?> register(String username, String password,
      String verifyPassword, String email, String fullName);
  Future<void> signOut();
}


@Order(2)

@singleton
class JwtAuthenticationService extends AuthenticationService {
  late AuthenticationRepository _authenticationRepository;
  late LocalStorageService _localStorageService;

  JwtAuthenticationService() {
    _authenticationRepository = GetIt.I.get<AuthenticationRepository>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  @override
  Future<User?> getCurrentUser() async {
    String? loggedUser = _localStorageService.getFromDisk("user");
    if (loggedUser != null) {
      var user = LoginResponse.fromJson(jsonDecode(loggedUser));
      return User(
          email: user.username ?? "",
          name: user.fullName ?? "",
          accessToken: user.token ?? "");
    }
    return null;
  }

  @override
  Future<User> signInWithEmailAndPassword(LoginDto loginDto) async {
    LoginResponse response =
        await _authenticationRepository.doLogin(loginDto);
    await _localStorageService.saveToDisk(
        'user', jsonEncode(response.toJson()));
    return User(
        email: response.username ?? "",
        name: response.fullName ?? "",
        accessToken: response.token ?? "");
  }

  @override
  Future<User> register(String username, String password, String verifyPassword,
      String email, String fullName) async {
    print('register: ' + username);
    RegisterResponse response = await _authenticationRepository.doRegister(
        username = username,
        password = password,
        verifyPassword = verifyPassword,
        email = email,
        fullName = fullName);
    await _localStorageService.saveToDisk(
        'user', jsonEncode(response.toJson()));
    return User(
        name: response.fullName ?? '',
        email: response.userName ?? '',
        accessToken: response.token ?? '');
  }

  @override
  Future<void> signOut() async {
    await _localStorageService.deleteFromDisk("user");
  }
}
