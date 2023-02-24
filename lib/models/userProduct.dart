class UserProducts {
  int? id;
  String? orderId;
  String? productName;
  String? productDescription;
  int? price;
  String? pricePeriod;
  String? quantity;
  List<ProductImage>? productImage;

  UserProducts(
      {this.id,
      this.orderId,
      this.productName,
      this.productDescription,
      this.price,
      this.pricePeriod,
      this.quantity,
      this.productImage});

  UserProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productName = json['product_name'];
    productDescription = json['product_description'];
    price = json['price'];
    pricePeriod = json['price_period'];
    quantity = json['quantity'];
    if (json['product_image'] != String) {
      productImage = <ProductImage>[];
      json['product_image'].forEach((v) {
        productImage!.add(ProductImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_name'] = this.productName;
    data['product_description'] = this.productDescription;
    data['price'] = this.price;
    data['price_period'] = this.pricePeriod;
    data['quantity'] = this.quantity;
    if (this.productImage != String) {
      data['product_image'] =
          this.productImage!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductImage {
  int? id;
  String? imageUrl;

  ProductImage({this.id, this.imageUrl});

  ProductImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['image_url'] = this.imageUrl;
    return data;
  }
}


