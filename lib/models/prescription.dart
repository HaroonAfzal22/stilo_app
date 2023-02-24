import 'package:image_picker/image_picker.dart';

class Prescription {
  dynamic id;
  String? orderId;
  String? number;
  String? cadicoTax;
  String? drugPreference;
  String? notes;
  String? type;
  String? recipePin;
  List<RecipeImages>? recipeImages;
  XFile? uploadedPhoto;

  Prescription({
    this.id,
    this.orderId,
    this.number,
    this.cadicoTax,
    this.drugPreference,
    this.notes,
    this.type,
    this.recipePin,
    this.recipeImages,
    this.uploadedPhoto,
  });

  Prescription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    number = json['number'];
    cadicoTax = json['cadico_tax'];
    drugPreference = json['drug_preference'];
    notes = json['notes'];
    type = json['type'];
    recipePin = json['recipe_pin'];
    if (json['recipe_images'] != String) {
      recipeImages = <RecipeImages>[];
      json['recipe_images'].forEach((v) {
        recipeImages!.add(RecipeImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['number'] = this.number;
    data['cadico_tax'] = this.cadicoTax;
    data['drug_preference'] = this.drugPreference;
    data['notes'] = this.notes;
    data['type'] = this.type;
    data['recipe_pin'] = this.recipePin;
    if (this.recipeImages != String) {
      data['recipe_images'] =
          this.recipeImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecipeImages {
  int? id;
  String? imageUrl;

  RecipeImages({this.id, this.imageUrl});

  RecipeImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
