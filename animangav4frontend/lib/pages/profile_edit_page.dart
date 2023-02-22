import 'package:animangav4frontend/edit_bloc/edit_bloc.dart';
import 'package:animangav4frontend/models/edit_user_dto.dart';
import 'package:animangav4frontend/models/errors.dart';
import 'package:animangav4frontend/pages/navigation_bard.dart';
import 'package:animangav4frontend/services/authentication_service.dart';
import 'package:animangav4frontend/utils/styles.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ProfileEditPage extends StatefulWidget {
  final String fullName;
  final String email;
  final String id;
  const ProfileEditPage(
      {Key? key, required this.fullName, required this.email, required this.id})
      : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late JwtAuthenticationService userService;

  @override
  void initState() {
    fullNameController = TextEditingController(text: widget.fullName);
    emailController = TextEditingController(text: widget.email);
    userService = GetIt.instance<JwtAuthenticationService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => EditUserBloc(userService)),
        ],
        child: Scaffold(
            backgroundColor: Color.fromARGB(255, 248, 248, 248),
            appBar: AppBar(
              title: Text(
                "EDITAR PERFIL",
                style: AnimangaStyle.textCustom(
                    AnimangaStyle.whiteColor, AnimangaStyle.textSizeFive),
              ),
              centerTitle: true,
              backgroundColor: AnimangaStyle.blackColor,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: RefreshIndicator(
                onRefresh: () async {},
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    child: _createBody(context)))));
  }

  Widget _createBody(BuildContext context) {
    return BlocConsumer<EditUserBloc, EditUserState>(
        listenWhen: (context, state) {
      return state is EditUserSuccessState || state is EditUserErrorState;
    }, listener: (context, state) {
      if (state is EditUserSuccessState) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
        _createDialog(context);
      } else if (state is EditUserErrorState) {
        _showSnackbar(context, state.error);
      }
    }, buildWhen: (context, state) {
      return state is EditUserInitial || state is EditUserSuccessState;
    }, builder: (context, state) {
      if (state is EditUserSuccessState) {
        return buildF(context);
      }
      return buildF(context);
    });
  }

  AwesomeDialog _createDialog(context) {
    return AwesomeDialog(
      context: context,
      dialogBackgroundColor: AnimangaStyle.quaternaryColor,
      btnOkColor: AnimangaStyle.primaryColor,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Correcto',
      desc: 'Los datos se han guardado correctamente',
      titleTextStyle: AnimangaStyle.textCustom(
          AnimangaStyle.whiteColor, AnimangaStyle.textSizeFour),
      descTextStyle: AnimangaStyle.textCustom(
          AnimangaStyle.whiteColor, AnimangaStyle.textSizeThree),
      btnOkText: "Aceptar",
      btnOkOnPress: () {},
    )..show();
  }

  void _showSnackbar(BuildContext context, ErrorResponse error) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 4),
      content: SizedBox(
        height: 150,
        child: Column(
          children: [
            Text(error.mensaje),
            for (SubErrores e in error.subErrores) Text(e.mensaje)
          ],
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget buildF(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 600,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 50,
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  style: AnimangaStyle.textCustom(
                      AnimangaStyle.whiteColor, AnimangaStyle.textSizeTwo),
                  controller: fullNameController,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AnimangaStyle.greyBoxColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    hintStyle: AnimangaStyle.textCustom(
                        AnimangaStyle.formColor, AnimangaStyle.textSizeTwo),
                    hintText: 'Nombre:',
                  ),
                  onSaved: (String? value) {},
                  validator: (String? value) {
                    return (value == null) ? 'Introduzca un nombre' : null;
                  },
                ),
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  style: AnimangaStyle.textCustom(
                      AnimangaStyle.whiteColor, AnimangaStyle.textSizeTwo),
                  controller: emailController,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AnimangaStyle.greyBoxColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    hintStyle: AnimangaStyle.textCustom(
                        AnimangaStyle.formColor, AnimangaStyle.textSizeTwo),
                    hintText: 'Apellidos:',
                  ),
                  onSaved: (String? value) {},
                  validator: (String? value) {
                    return (value == null) ? 'Introduzca sus apellidos' : null;
                  },
                ),
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  style: AnimangaStyle.textCustom(
                      AnimangaStyle.whiteColor, AnimangaStyle.textSizeTwo),
                  controller: emailController,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AnimangaStyle.greyBoxColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    hintStyle: AnimangaStyle.textCustom(
                        AnimangaStyle.formColor, AnimangaStyle.textSizeTwo),
                    hintText: 'Email:',
                  ),
                  onSaved: (String? value) {},
                  validator: (String? value) {
                    return (value == null) ? 'Introduzca su email' : null;
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.fromLTRB(10, 200, 10, 8),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AnimangaStyle.primaryColor,
                      elevation: 15.0,
                    ),
                    onPressed: () {
                      final edit = EditUserDto(
                        fullName: fullNameController.text,
                        email: emailController.text,
                      );
                      if (widget.email != emailController.text) {
                        edit.email = emailController.text;
                      }
                      BlocProvider.of<EditUserBloc>(context).add(
                        EditOneUserEvent(edit, widget.id),
                      );
                    },
                    child: Text("Guardar",
                        style: AnimangaStyle.textCustom(
                            AnimangaStyle.whiteColor,
                            AnimangaStyle.textSizeThree))),
              )
            ],
          ),
        ),
      ),
    );
  }
}