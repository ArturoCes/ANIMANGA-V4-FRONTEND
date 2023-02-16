import 'dart:convert';

import 'package:flutter/material.dart';

class RegisterResponse {
  String? id;
  String? userName;
  String? email;
  String? avatar;
  String? fullName;
  DateTime? createdAt;
  String? token;
  String? refreshToken;

  RegisterResponse(
      {this.id,
      this.userName,
      this.email,
      this.avatar,
      this.fullName,
      this.createdAt,
      this.token,
      this.refreshToken});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    email = json['email'];
    avatar = json['avatar'];
    fullName = json['fullName'];
    createdAt = DateTime.parse(reformat(json['createdAt']));
    token = json['token'];
    refreshToken = json['refreshToken'];
  }

  reformat(String dateTime) {
    String day = dateTime.substring(0, 2);
    String month = dateTime.substring(3, 5);
    String year = dateTime.substring(6, 10);
    String rest = dateTime.substring(11);
    String newString = year + '-' + month + '-' + day + ' ' + rest;
    print(newString);
    return newString;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userName'] = userName;
    data['email'] = email;
    data['avatar'] = avatar;
    data['fullName'] = fullName;
    data['createdAt'] = createdAt.toString();
    data['token'] = token;
    data['refreshToken'] = refreshToken;
    return data;
  }
}

class RegisterRequest {
  String? username;
  String? password;
  String? verifyPassword;
  String? email;
  String? avatar;
  String? fullName;

  RegisterRequest({
    this.username,
    this.password,
    this.verifyPassword,
    this.email,
    this.avatar,
    this.fullName,
  });

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    verifyPassword = json['verifyPassword'];
    email = json['email'];
    avatar = json['avatar'];
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['verifyPassword'] = verifyPassword;
    data['email'] = email;
    data['avatar'] = avatar;
    data['fullName'] = fullName;
    return data;
  }
}
