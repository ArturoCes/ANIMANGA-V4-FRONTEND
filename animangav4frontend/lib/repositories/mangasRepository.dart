import 'dart:convert';
import 'package:animangav4frontend/models/login.dart';
import 'package:animangav4frontend/rest/rest_client.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';

import '../models/manga.dart';


@Order(-1)
@singleton
class MangasRepository {
  late RestClient _client;
  final box = GetStorage();
  MangasRepository() {
    _client = GetIt.I.get<RestClient>();
    //_client = RestClient();
  }

  Future<dynamic> findAll() async {
    String url = "/manga/all";

     Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${box.read('token')}' 
     
    };

    var jsonResponse = await _client.get(url, headers: headers);
    return MangaResponse.fromJson(jsonDecode(jsonResponse));
  }
}