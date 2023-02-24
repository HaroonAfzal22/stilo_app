class OrderProduct {
  String? id;
  String? productName;
  String? productDescription;
  String? instruction;
  String? warning;
  String? rentalQuantity;
  double? productDisplayPrice;
  String? forRent;
  String? isGultan;
  String? isPromational;
  String? productCode;
  String? requiresPrescription;
  String? productPriceVat;
  String? product;
  String? code;
  String? period;
  String? minPeriod;
  String? instructionFile;
  List<ProductImage>? productImage;
  double? price;
  String? pricePeriod;
  String? category;
  String? dedline;
  String? producer;
  String? qty;

  OrderProduct(
      {this.id,
      this.productName,
      this.productDescription,
      this.instruction,
      this.warning,
      this.rentalQuantity,
      this.productDisplayPrice,
      this.forRent,
      this.isGultan,
      this.isPromational,
      this.productCode,
      this.requiresPrescription,
      this.productPriceVat,
      this.product,
      this.code,
      this.period,
      this.minPeriod,
      this.instructionFile,
      this.productImage,
      this.price,
      this.pricePeriod,
      this.category,
      this.dedline,
      this.producer,
      this.qty});

  OrderProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    productDescription = json['product_description'];
    instruction = json['instruction'];
    warning = json['warning'];
    rentalQuantity = json['rental_quantity'];
    productDisplayPrice = double.tryParse(json['product_display_price']);
    forRent = json['for_rent'];
    isGultan = json['is_gultan'];
    isPromational = json['is_promational'];
    productCode = json['product_code'];
    requiresPrescription = json['requires_prescription'];
    productPriceVat = json['product_price_vat'];
    product = json['product'];
    code = json['code'];
    period = json['period'];
    minPeriod = json['min_period'];
    instructionFile = json['instruction_file'];
    if (json['product_image'] is String) {
      productImage = [ProductImage(id: 1, productImage: json['product_image'])];
    } else {
      productImage = <ProductImage>[];
      if (json['product_image'] != null) {
        json['product_image'].forEach((v) {
          productImage!.add(ProductImage.fromJson(v));
        });
      } else {
        productImage = <ProductImage>[];
      }
    }
    price = json['price'] is String
        ? double.tryParse(json['price'])
        : json['price'].toDouble();
    pricePeriod = json['price_period'];
    category = json['category'];
    dedline = json['dedline'];
    producer = json['producer'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['product_name'] = productName;
    data['product_description'] = productDescription;
    data['instruction'] = instruction;
    data['warning'] = warning;
    data['rental_quantity'] = rentalQuantity;
    data['product_display_price'] = productDisplayPrice;
    data['for_rent'] = forRent;
    data['is_gultan'] = isGultan;
    data['is_promational'] = isPromational;
    data['product_code'] = productCode;
    data['requires_prescription'] = requiresPrescription;
    data['product_price_vat'] = productPriceVat;
    data['product'] = product;
    data['code'] = code;
    data['period'] = period;
    data['min_period'] = minPeriod;
    data['instruction_file'] = instructionFile;
    if (productImage != String) {
      data['product_image'] = productImage!.map((v) => v.toJson()).toList();
    }
    data['price'] = price;
    data['price_period'] = pricePeriod;
    data['category'] = category;
    data['dedline'] = dedline;
    data['producer'] = producer;
    data['qty'] = qty;
    return data;
  }
}

class ProductImage {
  int? id;
  String? productImage;

  ProductImage({this.id, this.productImage});

  ProductImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productImage = json['product_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_image'] = productImage;
    return data;
  }
}
