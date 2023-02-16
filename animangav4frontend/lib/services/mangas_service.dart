import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../models/manga.dart';
import '../repositories/mangasRepository.dart';
import 'localstorage_service.dart';

//import '../exceptions/exceptions.dart';

abstract class MangasService {
  Future<List<Manga>> findAll();
}
//@Singleton(as: AuthenticationService)
@singleton
class MangaService extends MangasService {
  late MangasRepository _mangasRepository;
  late LocalStorageService _localStorageService;

  MangaService() {
    _mangasRepository = GetIt.I.get<MangasRepository>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  @override
  Future<List<Manga>> findAll() async {
    dynamic response = await _mangasRepository.findAll();
    if (response.statusCode == 200) {
      return MangaResponse.fromJson(json.decode(response.body)).content;
    } else {
      throw Exception('Error al cargar los Mangas');
    }
  } 
}