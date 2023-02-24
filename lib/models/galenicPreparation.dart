import 'package:image_picker/image_picker.dart';

class GalenicPreparation {
  dynamic id;
  String? img;
  String? notes;
  XFile? uploadedPhoto;

  GalenicPreparation({
    required this.id,
    this.img,
    this.notes,
    this.uploadedPhoto,
  });
}
