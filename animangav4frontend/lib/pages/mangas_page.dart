import 'dart:convert';
import 'package:animangav4frontend/blocs/mangas/mangas_bloc.dart';
import 'package:animangav4frontend/models/manga.dart';
import 'package:animangav4frontend/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class MangasPage extends StatefulWidget {
  const MangasPage({Key? key}) : super(key: key);

  @override
  _MangasPageState createState() => _MangasPageState();
}

class _MangasPageState extends State<MangasPage> {
  final mangaService = GetIt.instance<MangasService>();
  late MangasBloc _mangasbloc;


  @override
  void initState() {
    
    _mangasbloc = MangasBloc(mangaService)
      ..add(FindAllMangas());
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
              return _mangasList(context, state.mangas);
            } else {
              return const Text('Error al cargar la lista');
            }
          },
        ),
      ),
    );
  }

  Widget _mangasList(context, List<Manga> mangas) {
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
               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: (0.78) ),
              itemBuilder: (context, index) {
                
      
                
                return Center(child: _mangaItem(mangas.elementAt(index)));
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _mangaItem(Manga manga) {
    return
         Container(
             child: Text('${manga.name}'),
        

    );
  }

 
  
}