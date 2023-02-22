import 'package:animangav4frontend/services/authentication_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImagePickBloc extends Bloc<ImagePickEvent, ImagePickState> {
  final JwtAuthenticationService userService;
  final box = GetStorage();

  ImagePickBloc(this.userService) : super(ImagePickInitial()) {
    on<SelectImageEvent>(_onSelectImage);
  }

  void _onSelectImage(
      SelectImageEvent event, Emitter<ImagePickState> emit) async {
    final ImagePicker _picker = ImagePicker();

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: event.source,
      );
      if (pickedFile != null) {
        final user = await userService.uploadImage(
            pickedFile.path, box.read("idUser") ?? "");
        box.write('image', user.image);
        emit(ImageSelectedSuccessState(pickedFile));
      } else {
        emit(const ImageSelectedErrorState('Error in image selection'));
      }
    } catch (e) {
      emit(const ImageSelectedErrorState('Error in image selection'));
    }
  }
}