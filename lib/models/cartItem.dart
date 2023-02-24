import 'package:contacta_pharmacy/models/product.dart';

class CartItem {
  Product item;
  int quantity;

  CartItem({
    required this.item,
    required this.quantity,
  });
}
