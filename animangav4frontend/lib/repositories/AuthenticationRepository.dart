import 'dart:convert';

import 'package:animangav4frontend/models/register.dart';
import 'package:animangav4frontend/rest/rest_client.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../models/login.dart';

@Order(-1)
@singleton
class AuthenticationRepository {
  late RestClient _client;

  AuthenticationRepository() {
    _client = GetIt.I.get<RestClient>();
    //_client = RestClient();
  }

  Future<dynamic> doLogin(String username, String password) async {
    String url = "/auth/login";

    var jsonResponse = await _client.post(
        url, LoginRequest(username: username, password: password));
    return LoginResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> doRegister(String username, String password,
      String verifyPassword, String email, String fullName) async {
    String url = '/auth/register';

    print('doRegister: ' + username);
    print('Request: ' +
        RegisterRequest(
                username: username,
                password: password,
                verifyPassword: verifyPassword,
                email: email,
                fullName: fullName,
                avatar: '')
            .username!);
    var jsonResponse = await _client.post(
        url,
        RegisterRequest(
            username: username,
            password: password,
            verifyPassword: verifyPassword,
            email: email,
            fullName: fullName,
            avatar: ''));
    print(RegisterResponse.fromJson(jsonDecode(jsonResponse)));
    return RegisterResponse.fromJson(jsonDecode(jsonResponse));
  }
}
