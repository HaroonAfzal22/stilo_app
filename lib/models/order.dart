import 'package:contacta_pharmacy/models/orderProduct.dart';
import 'package:contacta_pharmacy/models/prescription.dart';
import 'package:contacta_pharmacy/models/userProduct.dart';

class Order {
  int? id;
  int? orderId;
  String? date;
  String? coupanName;
  String? cardNo;
  String? discountType;
  String? discountPercentage;
  String? shippingType;
  String? shipmentAddress;
  String? pickupType;
  String? paymentId;
  String? payment;
  String? couponId;
  String? tax;
  String? total;
  String? subTotal;
  String? promoCode;
  List<OrderProduct>? products;
  List<UserProducts>? userProducts;
  List<Prescription>? recipe;
  String? status;

  Order({
    this.id,
    this.orderId,
    this.date,
    this.coupanName,
    this.cardNo,
    this.discountType,
    this.discountPercentage,
    this.shippingType,
    this.shipmentAddress,
    this.pickupType,
    this.paymentId,
    this.payment,
    this.couponId,
    this.tax,
    this.total,
    this.subTotal,
    this.promoCode,
    this.products,
    this.userProducts,
    this.recipe,
    this.status,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    date = json['date'];
    coupanName = json['coupan_name'];
    cardNo = json['card_no'];
    discountType = json['discount_type'];
    discountPercentage = json['discount_percentage'];
    shippingType = json['shipping_type'];
    shipmentAddress = json['shipment_address'];
    pickupType = json['pickup_type'];
    paymentId = json['payment_id'] is int
        ? json['payment_id'].toString()
        : json['payment_id'];
    payment = json['payment'];
    couponId = json['coupon_id'];
    tax = json['tax'];
    total = json['total'];
    subTotal = json['sub_total'];
    promoCode = json['promo_code'];
    status = json['status'];
    if (json['products'] != String) {
      products = <OrderProduct>[];
      if (json['products'] != null)
        json['products'].forEach((v) {
          products!.add(OrderProduct.fromJson(v));
        });
    }
    if (json['user_products'] != String) {
      userProducts = <UserProducts>[];
      json['user_products'].forEach((v) {
        userProducts!.add(UserProducts.fromJson(v));
      });
    }
    if (json['recipe'] != String) {
      recipe = <Prescription>[];
      json['recipe'].forEach((v) {
        recipe!.add(Prescription.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['order_id'] = orderId;
    data['date'] = date;
    data['coupan_name'] = coupanName;
    data['card_no'] = cardNo;
    data['discount_type'] = discountType;
    data['discount_percentage'] = discountPercentage;
    data['shipping_type'] = shippingType;
    data['shipment_address'] = shipmentAddress;
    data['pickup_type'] = pickupType;
    data['payment_id'] = paymentId;
    data['payment'] = payment;
    data['coupon_id'] = couponId;
    data['tax'] = tax;
    data['total'] = total;
    data['sub_total'] = subTotal;
    data['promo_code'] = promoCode;
    if (products != String) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    if (userProducts != String) {
      data['user_products'] = userProducts!.map((v) => v.toJson()).toList();
    }
    if (recipe != String) {
      data['recipe'] = recipe!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
