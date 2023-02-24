import 'package:image_picker/image_picker.dart';

class CustomProduct {
  dynamic id;
  String? img;
  String? productName;
  String? notes;
  List<XFile>? uploadedPhoto;

  CustomProduct({
    this.id,
    this.img,
    this.productName,
    this.notes,
    this.uploadedPhoto,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'img': img,
      'productName': productName,
      'notes': notes,
      'uploadedPhoto': uploadedPhoto,
    };
  }

  factory CustomProduct.fromMap(Map<String, dynamic> map) {
    return CustomProduct(
      id: map['id'],
      img: map['img'],
      productName: map['productName'],
      notes: map['notes'],
      uploadedPhoto: map['uploadedPhoto'],
    );
  }
}
