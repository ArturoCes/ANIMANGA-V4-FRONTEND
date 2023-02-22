import 'dart:convert';

import 'package:animangav4frontend/blocs/login/login_dto.dart';
import 'package:animangav4frontend/blocs/register/bloc/register_dto.dart';
import 'package:animangav4frontend/models/edit_user_dto.dart';
import 'package:animangav4frontend/models/user.dart';
import 'package:animangav4frontend/rest/rest_client.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';

import '../models/login.dart';

@Order(-1)
@singleton
class AuthenticationRepository {
  late RestClient _client;
  final box = GetStorage();
  AuthenticationRepository() {
    _client = GetIt.I.get<RestClient>();
  }

  Future<dynamic> doLogin(LoginDto loginDto) async {
    String url = "/auth/login";

    var jsonResponse = await _client.post(url, loginDto);
    return LoginResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> doRegister(RegisterDto registerDto) async {
    String url = '/auth/register';

    var jsonResponse = await _client.post(url, registerDto);
    return LoginResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> uploadImage(String filename, String id) async {
    String url = "/user/image";
    Map<String, String> headers = {
      'Authorization': 'Bearer ${box.read('token')}'
    };
    var jsonResponse = await _client.get(url, headers: headers);
    return User.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> userLogged() async {
    String url = "/me";
    Map<String, String> headers = {
      'Authorization': 'Bearer ${box.read('token')}'
    };

    var jsonResponse = await _client.get(url, headers: headers);

    return User.fromJson(json.decode(jsonResponse));
  }

  Future<User> edit(EditUserDto editUserDto, String id) async {
    String url = "/user";

    Map<String, String> headers = {
      'Authorization': 'Bearer ${box.read('token')}'
    };
    var jsonResponse = await _client.get(url, headers: headers);
    return User.fromJson(json.decode(jsonResponse.body));
  }
}
