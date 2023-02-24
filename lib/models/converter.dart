import 'package:contacta_pharmacy/models/product.dart';
import 'package:contacta_pharmacy/models/productDetail.dart';

Product fromDetailToProduct(ProductDetail productDetail) {
  return Product(
    id: productDetail.id,
    productName: productDetail.productName,
    productCode: productDetail.productCode,
    requiresPrescription: productDetail.requiresPrescription ?? 'N',
    code: productDetail.code,
    manufacturerTitle: productDetail.manufacturerTitle,
    productCategoryId: productDetail.productCategoryId ?? '',
    productPriceVat: productDetail.productPriceVat,
    productPrice: productDetail.productPrice,
    productDisplayPrice: productDetail.productDisplayPrice,
    isPromotional: productDetail.isPromotional,
    productImage: productDetail.images,
    inWishList: 'N',
  );
}

Product fromMapDetailToProduct(Map<String, dynamic> productDetail) {
  return Product(
    id: int.parse(productDetail['product_id']),
    productName: productDetail['product_name'],
    productCode: productDetail['product_code'],
    requiresPrescription: productDetail['requires_prescription'] ?? 'N',
    code: productDetail['code'],
    manufacturerTitle: productDetail['manufacturer_title'],
    productCategoryId: productDetail['category'] ?? '',
    productPriceVat: productDetail['product_price_vat'],
    productPrice: double.parse(productDetail['price'].replaceAll(',', '.')),
    productDisplayPrice:
        double.parse(productDetail['price'].replaceAll(',', '.')),
    isPromotional: productDetail['is_promational'],
    productImage: productDetail['product_image'],
    inWishList: 'N',
  );
}
