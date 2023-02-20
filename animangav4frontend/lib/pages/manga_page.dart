import 'dart:convert';

import 'package:animangav4frontend/blocs/manga/bloc/manga_bloc.dart';
import 'package:animangav4frontend/models/manga.dart';
import 'package:animangav4frontend/pages/error_page.dart';
import 'package:animangav4frontend/repositories/mangasRepository.dart';
import 'package:animangav4frontend/services/mangas_service.dart';
import 'package:animangav4frontend/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

class MangaPage extends StatefulWidget {
  const MangaPage({Key? key}) : super(key: key);

  @override
  State<MangaPage> createState() => _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  late MangasService mangasService;
  late MangaBloc _mangaBloc;
  final box = GetStorage();

  @override
  void initState() {
    mangasService = GetIt.instance<MangaService>();
    _mangaBloc = MangaBloc(mangasService)..add(FetchManga());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => _mangaBloc),
        ],
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 249, 249, 249),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: RefreshIndicator(
            onRefresh: () async {},
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: _createBody(context),
            ),
          ),
        ));
  }

  Widget _createBody(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          BlocBuilder<MangaBloc, MangaState>(
            bloc: _mangaBloc,
            builder: (context, state) {
              if (state is MangaInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is MangaFetchError) {
                return ErrorPage(
                  message: state.message,
                  retry: () {
                    context.watch<MangaBloc>().add(const FetchManga());
                  },
                );
              } else if (state is MangaFetched) {
                return buildOne(context, state.manga);
              } else {
                return const Text('No se pudo cargar el manga');
              }
            },
          ),
        ],
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget buildOne(context, Manga manga) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.network(
                manga.posterPath,
                width: MediaQuery.of(context).size.width,
                height: 190,
              ),
              Text(manga.name),
              Text(manga.description),
              Text(manga.author),
              Text(manga.releaseDate)
            ],
          )),
    );
  }
}
