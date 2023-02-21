import 'dart:convert';
import 'package:animangav4frontend/blocs/mangas/mangas_bloc.dart';
import 'package:animangav4frontend/models/manga.dart';
import 'package:animangav4frontend/rest/rest_client.dart';
import 'package:animangav4frontend/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/styles.dart';

class MangasPage extends StatefulWidget {
  const MangasPage({Key? key}) : super(key: key);

  @override
  _MangasPageState createState() => _MangasPageState();
}

class _MangasPageState extends State<MangasPage> {
  late MangaService mangaService;
  late MangasBloc _mangasbloc;
  final box = GetStorage();
  @override
  void initState() {
    mangaService = GetIt.instance<MangaService>();
    _mangasbloc = MangasBloc(mangaService)..add(FindAllMangas(10));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [BlocProvider(create: (context) => _mangasbloc)],
        child: Scaffold(
            body: RefreshIndicator(
                onRefresh: () async {},
                child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: _createBody(context)))));
  }

  Widget _createBody(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: BlocBuilder<MangasBloc, MangasState>(
          bloc: _mangasbloc,
          builder: (context, state) {
            if (state is MangasInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FindAllMangasError) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is FindAllMangasSuccess) {
              return _mangasList(context, state.mangas, state.pagesize);
            } else {
              return const Text('Error al cargar la lista');
            }
          },
        ),
      ),
    );
  }

  Widget _mangasList(context, List<Manga> mangas, int pagesize) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 200),
            child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: mangas.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: (0.78)),
                itemBuilder: (context, index) {
                  if (index == mangas.length - 1 && mangas.length < pagesize) {
                    context.watch<MangasBloc>().add(FindAllMangas(index + 10));
                  }
                  return Center(child: _mangaItem(mangas.elementAt(index)));
                }),
          ),
        ],
      ),
    );
  }

  Widget _mangaItem(Manga manga) {
    return GestureDetector(
      onTap: () {
        box.write("idManga", manga.id);
        Navigator.pushNamed(context, "/detail");
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 82, 1, 68),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(2.0),
                  child: Image.network(
                    ApiConstants.imageBaseUrl + manga.posterPath,
                    /*   headers: {
                            'Authorization':
                                '${box.read('token')}'
                          },*/
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 2.5,
                    fit: BoxFit.fitWidth,
                  )),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width / 8,
              width: MediaQuery.of(context).size.width / 2.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    utf8.decode(manga.name.codeUnits),
                    style: AnimangaStyle.textCustom(
                        Color.fromARGB(255, 255, 255, 255),
                        AnimangaStyle.textSizeFour),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
