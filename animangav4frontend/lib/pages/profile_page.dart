import 'dart:convert';

import 'package:animangav4frontend/blocs/image/image_bloc.dart';
import 'package:animangav4frontend/blocs/profile/profile_bloc.dart';
import 'package:animangav4frontend/models/user.dart';
import 'package:animangav4frontend/pages/error_page.dart';
import 'package:animangav4frontend/pages/profile_edit_page.dart';
import 'package:animangav4frontend/services/authentication_service.dart';

import 'package:animangav4frontend/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<XFile>? _imageFileList;
  late JwtAuthenticationService userService;
  late ProfileBloc _profileBloc;
  final box = GetStorage();

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  var url = "https://i.ibb.co/RDRz7Ft/upload.png";

  @override
  void initState() {
    userService = GetIt.instance<JwtAuthenticationService>();
    _profileBloc = ProfileBloc(userService)..add(const FetchUserLogged());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _profileBloc),
        BlocProvider(create: (context) => ImagePickBloc(userService))
      ],
      child: Scaffold(
        backgroundColor: AnimangaStyle.blackColor,
        body: RefreshIndicator(
          onRefresh: () async {},
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: _createBody(context),
          ),
        ),
      ),
    );
  }

  Widget _createBody(BuildContext context) {
    return Column(
      children: [
        BlocProvider(
          create: (context) {
            return ImagePickBloc(userService);
          },
          child: BlocConsumer<ImagePickBloc, ImagePickState>(
              listenWhen: (context, state) {
                return state is ImageSelectedSuccessState;
              },
              listener: (context, state) {},
              buildWhen: (context, state) {
                return state is ImagePickInitial ||
                    state is ImageSelectedSuccessState;
              },
              builder: (context, state) {
                if (state is ImageSelectedSuccessState) {
                  return buildProfile(context, state);
                }
                return buildProfile(context, state);
              }),
        ),
        BlocBuilder<ProfileBloc, ProfileState>(
          bloc: _profileBloc,
          builder: (context, state) {
            if (state is ProfileInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoggedFetchError) {
              return ErrorPage(
                  message: state.message,
                  retry: () {
                    context.watch<ProfileBloc>().add(const FetchUserLogged());
                  });
            } else if (state is UserLoggedFetched) {
              return _userItem(state.userLogged);
            } else {
              return const Text('No se pudo cargar los datos');
            }
          },
        ),
      ],
    );
  }

  Widget _userItem(User userLogged) {
    box.write('idUser', userLogged.id);
    return Column(
      children: [
        Center(
          child: Center(
            child: Text(utf8.decode(userLogged.username!.codeUnits),
                style: AnimangaStyle.textCustom(
                    AnimangaStyle.whiteColor, AnimangaStyle.textSizeThree)),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfileEditPage(
                        fullName: userLogged.fullName!,
                        email: userLogged.createdAt!,
                        id: userLogged.id!)));
              },
              icon: const Icon(
                Icons.edit,
                color: AnimangaStyle.whiteColor,
              ),
            )
          ],
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AnimangaStyle.greyBoxColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Nombre:",
                  style: AnimangaStyle.textCustom(
                      AnimangaStyle.whiteColor, AnimangaStyle.textSizeTwo),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  utf8.decode(userLogged.fullName!.codeUnits),
                  style: AnimangaStyle.textCustom(
                      AnimangaStyle.whiteColor, AnimangaStyle.textSizeTwo),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AnimangaStyle.greyBoxColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Nombre de usuario:",
                  style: AnimangaStyle.textCustom(
                      AnimangaStyle.whiteColor, AnimangaStyle.textSizeTwo),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  utf8.decode(userLogged.username!.codeUnits),
                  style: AnimangaStyle.textCustom(
                      AnimangaStyle.whiteColor, AnimangaStyle.textSizeTwo),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AnimangaStyle.greyBoxColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Fecha de creación:",
                  style: AnimangaStyle.textCustom(
                      AnimangaStyle.whiteColor, AnimangaStyle.textSizeTwo),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(utf8.decode(userLogged.createdAt!.codeUnits),
                    style: AnimangaStyle.textCustom(
                        AnimangaStyle.whiteColor, AnimangaStyle.textSizeTwo)),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: AnimangaStyle.greyBoxColor,
              shape: RoundedRectangleBorder(
                side:
                    const BorderSide(color: AnimangaStyle.formColor, width: 2),
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 15.0,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/changepassword');
            },
            child: Text(
              "Cambiar contraseña",
              style: AnimangaStyle.textCustom(
                  AnimangaStyle.whiteColor, AnimangaStyle.textSizeTwo),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(8, 50, 8, 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: AnimangaStyle.redColor,
              elevation: 15.0,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        backgroundColor: AnimangaStyle.quaternaryColor,
                        title: const Text(
                          "Cerrar sesión",
                          style: TextStyle(
                            color: AnimangaStyle.whiteColor,
                          ),
                        ),
                        content: const Text(
                          '¿Estas seguro que quieres salir?',
                          style: TextStyle(
                            color: AnimangaStyle.whiteColor,
                          ),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text(
                                  'No',
                                  style: TextStyle(
                                    color: AnimangaStyle.whiteColor,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => {
                                  box.erase(),
                                  Navigator.pushNamed(context, '/login'),
                                },
                                child: const Text(
                                  'Si',
                                  style: TextStyle(
                                    color: AnimangaStyle.whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ));
            },
            child: Text(
              "Cerrar sesión",
              style: AnimangaStyle.textCustom(
                  AnimangaStyle.whiteColor, AnimangaStyle.textSizeThree),
            ),
          ),
        ),
      ],
    );
  }

  Widget avatar(String avatarUrl) {
    if (avatarUrl.isEmpty) {
      return Container(
          width: 130,
          height: 130,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/upload.png"))));
    } else {
      return Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    box.read("avatar")!,
                    /*  headers: {
                            'Authorization':
                                'Bearer ${PreferenceUtils.getString('token')}'
                          }, */
                  ))));
    }
  }

  Widget buildProfile(BuildContext context, state) {
    return SizedBox(
      height: 180,
      child: Column(
        children: [
          Center(
            child: Text("MI PERFIL",
                style: AnimangaStyle.textCustom(
                    AnimangaStyle.whiteColor, AnimangaStyle.textSizeFive)),
          ),
          GestureDetector(
              onTap: () {
                BlocProvider.of<ImagePickBloc>(context)
                    .add(const SelectImageEvent(ImageSource.gallery));
              },
              child: avatar(box.read('image'))),
        ],
      ),
    );
  }
}
