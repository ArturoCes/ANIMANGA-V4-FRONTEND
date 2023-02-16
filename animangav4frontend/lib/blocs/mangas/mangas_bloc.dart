import 'package:animangav4frontend/services/services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/manga.dart';

part 'mangas_event.dart';
part 'mangas_state.dart';

class MangasBloc extends Bloc<MangasEvent, MangasState> {
  final MangasService _mangasService;
  MangasBloc(MangasService mangaService) 
    : assert(mangaService != null),
        _mangasService = mangaService,
   super(MangasInitial()) {
    on<FindAllMangas>(_findAllMangas);
  }

  _findAllMangas(FindAllMangas event, Emitter<MangasState> emit) async {
    try {
      final mangas = await _mangasService.findAll();
      emit(FindAllMangasSuccess(mangas));
      return;
    } on Exception catch (e) {
      emit(FindAllMangasError(e.toString()));
    }
  }

}
