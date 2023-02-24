import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/product.dart';
import 'package:contacta_pharmacy/models/time_tables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsProvider = ChangeNotifierProvider((ref) => ProductsProvider());

class ProductsProvider extends ChangeNotifier {
  ApisNew _apisNew = ApisNew();

  TimeTables? timeTables;
  List<Product> products = [
    Product(
      requiresPrescription: '',
      productPriceVat: "20",
      inWishList: '',
      productCategoryId: '1',
      productCode: '',
      productDisplayPrice: 59.99,
      productPrice: 29.99,
      id: 1,
      productName: 'TISANA INFUSETTE VERBENA/LIQUI',
      code: '123',
      manufacturerTitle: "LAB.MAURICE MESSEGUE ITALIA",
      productImage: [
        {
          "id": 2647,
          "img":
              "https://webservices.farmadati.it/WS_DOC/GetDoc.aspx?accesskey=JjV2qgwo&tipodoc=TE004&nomefile=022304.jpg"
        },
      ],
    ),
  ];
}
