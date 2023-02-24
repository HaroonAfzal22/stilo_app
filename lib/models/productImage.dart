class ProductImage {
  int? id;
  String? productImage;

  ProductImage({this.id, this.productImage});

  ProductImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productImage = json['product_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['product_image'] = this.productImage;
    return data;
  }
}