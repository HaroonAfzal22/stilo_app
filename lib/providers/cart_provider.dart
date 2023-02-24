import 'dart:convert';
import 'dart:io';

import 'package:contacta_pharmacy/models/cartItem.dart';
import 'package:contacta_pharmacy/models/customProduct.dart';
import 'package:contacta_pharmacy/models/galenicPreparation.dart';
import 'package:contacta_pharmacy/models/prescription.dart';
import 'package:contacta_pharmacy/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../apis/apisNew.dart';
import 'auth_provider.dart';

final cartProvider = ChangeNotifierProvider((ref) {
  final userId = ref.watch(authProvider).user?.wpId;
  return CartProvider(userId);
});

class CartProvider extends ChangeNotifier {
  CartProvider(this.userId);

  final int? userId;
  List<CartItem> cart = [];
  List<String> coupons = [];
  List<Prescription> prescriptions = [];
  List<CustomProduct> customProducts = [];
  final ApisNew _apisNew = ApisNew();

  void addToCart(Product product, int quantity) async {
    final index = isInCart(product);
    //TODO semplificare logica
    if (index != -1) {
      cart[index].quantity += quantity;
      notifyListeners();
    } else {
      cart.add(CartItem(item: product, quantity: quantity));
      notifyListeners();
    }
  }

  int get size {
    int sum = 0;
    for (var element in cart) {
      sum += element.quantity;
    }
    return sum;
  }

  //TODO finire
  void increaseQty() {}

  void decreaseQty() {}

  void addPrescriptionToCart(Prescription prescription) {
    prescriptions.add(prescription);
    notifyListeners();
  }

  void addCustomProductToCart(CustomProduct customProduct) {
    customProducts.add(customProduct);
    notifyListeners();
  }

  void removeCustomProductFromCart(dynamic id) {
    customProducts.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void removePrescriptionFromCart(dynamic id) {
    prescriptions.removeWhere((item) => item.id == id);
    notifyListeners();
  }

/*  void addGalenicToCart(GalenicPreparation galenicPreparation) {
    galenicPreparations.add(galenicPreparation);
    notifyListeners();
  }

  void removeGalenicPreparationFromCart(dynamic id) {
    galenicPreparations.removeWhere((item) => item.id == id);
    notifyListeners();
  }*/

  void emptyCart() {
    cart = [];
    prescriptions = [];
    customProducts = [];
    notifyListeners();
  }

  void removeItemFromCart(Product product, int quantity) {
    cart.removeWhere((item) => item.item.id == product.id);
    notifyListeners();
  }

  double getTotalAmount() {
    double sum = 0;
    for (var element in cart) {
      if (element.item.isPromotional == 'Y' &&
          element.item.promotionalPrice != null) {
        sum += element.item.promotionalPrice! * element.quantity;
      } else {
        sum += element.item.productPrice! * element.quantity;
      }
    }
    return sum;
  }

  int isInCart(Product product) {
    return cart.indexWhere((element) => element.item.id == product.id);
  }

  List<dynamic> convertListForOrder() {
    List<Map<String, dynamic>> list = [];
    for (var element in cart) {
      var x = {
        'product_id': element.item.id,
        'quantity': element.quantity,
        'price': element.item.isPromotional == 'Y' &&
                element.item.promotionalPrice != null
            ? element.item.promotionalPrice
            : element.item.productPrice
      };
      list.add(x);
    }

    return list;
  }

  List<dynamic> convertPrescriptionsForOrder() {
    List<Map<String, dynamic>> list = [];

    for (var element in prescriptions) {
      String? convertedImage;
      if (element.uploadedPhoto != null) {
        final bytes = File(element.uploadedPhoto!.path).readAsBytesSync();
        convertedImage = base64Encode(bytes);
      }
      var x = {
        'number': element.number,
        'cadico_tax': element.cadicoTax,
        'drug_preference': element.drugPreference,
        'notes': element.notes,
        'type': element.type,
        'recipe_pin': element.recipePin,
        'recipe_image': convertedImage,
      };
      list.add(x);
    }

    //list.clear(); //TODO temp perchè non funziona

    return list;
  }

  List<dynamic> convertCustomProductsForOrder() {
    List<Map<String, dynamic>> list = [];
    String? convertedImage;
    for (var element in customProducts) {
      if (element.uploadedPhoto != null && element.uploadedPhoto!.isNotEmpty) {
        final bytes = File(element.uploadedPhoto![0].path).readAsBytesSync();
        convertedImage = base64Encode(bytes);
      }
      var x = {
        'productName': element.productName,
        'notes': element.notes,
        'img': convertedImage,
      };
      list.add(x);
    }

    return list;
  }
}
