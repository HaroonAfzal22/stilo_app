class ProductItem {
  int? id;
  String? drugType;
  List<ProductImage>? productImage;

  ProductItem({this.id, this.drugType, this.productImage});

  ProductItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    drugType = json['drug_type'];
    if (json['product_image'] != null) {
      productImage = <ProductImage>[];
      json['product_image'].forEach((v) {
        productImage!.add(ProductImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['drug_type'] = drugType;
    if (productImage != null) {
      data['product_image'] = productImage!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductImage {
  int? id;
  String? img;

  ProductImage({this.id, this.img});

  ProductImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['img'] = img;
    return data;
  }
}
