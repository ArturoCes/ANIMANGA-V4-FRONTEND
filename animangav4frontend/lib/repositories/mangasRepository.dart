import 'dart:convert';
import 'package:animangav4frontend/models/login.dart';
import 'package:animangav4frontend/rest/rest_client.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../models/manga.dart';


@Order(-1)
@singleton
class MangasRepository {
  late RestClient _client;

  MangasRepository() {
    _client = GetIt.I.get<RestClient>();
    //_client = RestClient();
  }

  Future<dynamic> findAll() async {
    String url = "/manga/all";

    var jsonResponse = await _client.get(url, headers: {
     'Content-Type': 'application/json',
     'Accept': 'application/json',
     'Authorization': 'Bearer '
    });
    return MangaResponse.fromJson(jsonDecode(jsonResponse));
  }
}