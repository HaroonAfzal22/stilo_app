class Product {
  int? id;
  String productName;
  String? productCode;
  String? requiresPrescription;
  String? code;
  String? manufacturerTitle;
  String productCategoryId;
  String? productPriceVat;
  double? productPrice;
  double? productDisplayPrice;
  double? promotionalPrice;
  String? inWishList;
  String? isPromotional;

  List<dynamic>? productImage;
  String? singleImage;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'productCode': productCode,
      'requiresPrescription': requiresPrescription,
      'code': code,
      'manufacturerTitle': manufacturerTitle,
      'productCategoryId': productCategoryId,
      'productPriceVat': productPriceVat,
      'productPrice': productPrice,
      'productDisplayPrice': productDisplayPrice,
      'inWishList': inWishList,
      'productImage': productImage,
    };
  }

  List<Map<String, dynamic>> get images {
    List<Map<String, dynamic>> res = [];
    if (productImage == null || productImage != null && productImage!.isEmpty) {
      return res;
    }
    if (productImage != null && productImage!.isNotEmpty) {
      res.add(productImage![0]);
    }
    return res;
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      productName: map['product_name'],
      productCode: map['product_code'],
      requiresPrescription: map['requires_prescription'],
      code: map['code'],
      manufacturerTitle: map['manufacturer_title'],
      productCategoryId: map['product_category_id'],
      productPriceVat: map['product_price_vat'],
      productPrice: double.tryParse(map['product_price']?.replaceAll(',', '.')),
      productDisplayPrice: map['product_display_price'] != null
          ? double.tryParse(map['product_display_price'])
          : null,
      inWishList: map['in_wish_list'],
      isPromotional: map['is_promational'],
      productImage: map['prodcut_image'],
      singleImage: map['product_image'],
      promotionalPrice: map['promotional_price'] != null
          ? double.tryParse(map['promotional_price']?.replaceAll(',', '.'))
          : 0,
    );
  }

  Product({
    required this.id,
    required this.productName,
    required this.productCode,
    required this.requiresPrescription,
    required this.code,
    required this.manufacturerTitle,
    required this.productCategoryId,
    required this.productPriceVat,
    required this.productPrice,
    required this.productDisplayPrice,
    required this.inWishList,
    required this.productImage,
    this.isPromotional,
    this.singleImage,
    this.promotionalPrice,
  });
}
