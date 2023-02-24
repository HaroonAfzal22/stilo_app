import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/search_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productListDataProvider =
    ChangeNotifierProvider(((ref) => ProductListProvider()));

class ProductListProvider extends ChangeNotifier {
  List<ProductItem?> productList = [];
  final _apiNews = ApisNew();

  Future<List<ProductItem?>> getProductList(Map<String, dynamic> data) async {
    productList = await _apiNews.getProductList(data);
    notifyListeners();
    return productList;
  }
}
