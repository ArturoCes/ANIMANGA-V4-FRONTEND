import 'dart:convert';

import 'package:animangav4frontend/models/category.dart';
import 'package:animangav4frontend/models/manga.dart';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../utils/styles.dart';

class DetailMangaPage extends StatefulWidget {
  final Manga manga;
  const DetailMangaPage({required this.manga, Key? key}) : super(key: key);

  @override
  State<DetailMangaPage> createState() => _DetailMangaPageState();
}

class _DetailMangaPageState extends State<DetailMangaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "DETALLES",
          style: AnimangaStyle.textCustom(
              AnimangaStyle.whiteColor, AnimangaStyle.textSizeFive),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 250, 250, 250),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'NOMBRE: ',
                    style: AnimangaStyle.textCustom(
                      AnimangaStyle.whiteColor,
                      AnimangaStyle.textSizeThree,
                    ),
                  ),
                  Text(
                    utf8.decode(widget.manga.name.codeUnits),
                    style: AnimangaStyle.textCustom(
                      AnimangaStyle.whiteColor,
                      AnimangaStyle.textSizeTwo,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'AUTOR: ',
                    style: AnimangaStyle.textCustom(
                      AnimangaStyle.whiteColor,
                      AnimangaStyle.textSizeThree,
                    ),
                  ),
                  Text(
                    utf8.decode(widget.manga.author.codeUnits),
                    style: AnimangaStyle.textCustom(
                      AnimangaStyle.whiteColor,
                      AnimangaStyle.textSizeTwo,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'FECHA DE PUBLICACIÓN: ',
                    style: AnimangaStyle.textCustom(
                      AnimangaStyle.whiteColor,
                      AnimangaStyle.textSizeThree,
                    ),
                  ),
                  Text(
                    Jiffy(widget.manga.releaseDate).yMMMd,
                    style: AnimangaStyle.textCustom(
                      AnimangaStyle.whiteColor,
                      AnimangaStyle.textSizeTwo,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Text(
                      'CATEGORIAS ',
                      style: AnimangaStyle.textCustom(
                        AnimangaStyle.whiteColor,
                        AnimangaStyle.textSizeFour,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: categories(context, widget.manga.categories),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Text(
                  "DESCRIPCIÓN",
                  style: AnimangaStyle.textCustom(
                    AnimangaStyle.whiteColor,
                    AnimangaStyle.textSizeFour,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  utf8.decode(widget.manga.description.codeUnits),
                  style: AnimangaStyle.textCustom(
                    AnimangaStyle.whiteColor,
                    AnimangaStyle.textSizeTwo,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget categories(context, List<dynamic> categoryList) {
    if (categoryList.isEmpty) {
      return Text(
        "Sin definir",
        style: AnimangaStyle.textCustom(
          AnimangaStyle.whiteColor,
          AnimangaStyle.textSizeTwo,
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: false,
        scrollDirection: Axis.horizontal,
        itemCount: widget.manga.categories.length,
        itemBuilder: (context, index) {
          categoryList = widget.manga.categories;
          return oneCategory(context, categoryList.elementAt(index));
        },
      );
    }
  }

  Widget oneCategory(context, Category category) {
    return Container(
        width: 60,
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.only(top: 6),
        decoration: BoxDecoration(
            border: Border.all(color: AnimangaStyle.whiteColor),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          utf8.decode(category.name!.codeUnits),
          style: AnimangaStyle.textCustom(
              AnimangaStyle.whiteColor, AnimangaStyle.textSizeTwo),
          textAlign: TextAlign.center,
        ));
  }
}
