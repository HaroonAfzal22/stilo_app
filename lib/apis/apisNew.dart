import 'package:contacta_pharmacy/models/medcab_item.dart';
import 'package:contacta_pharmacy/models/notification.dart';
import 'package:contacta_pharmacy/models/search_list.dart';
import 'package:contacta_pharmacy/models/time_tables.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constant.dart';
import '../models/contacts.dart';
import '../models/news.dart';
import '../models/order.dart';
import '../models/pill.dart';
import '../models/product.dart';
import '../models/productDetail.dart';
import '../models/sede.dart';
import '../models/therapy.dart';

class ApisNew {
  Dio dio = Dio();
  Dio dioAuth = Dio();

  ApisNew() {
    _initOption();
  }

  _initOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("bearer_token");
    if (token != null) {
      if (token.isNotEmpty) {
        var options = BaseOptions(headers: {"Authorization": "Bearer $token"});
        dioAuth.options = options;
      }
    }
  }

  Future<dynamic> getOrders(Map<String, dynamic> data) async {
    return await dio.get(Constant.myorders_list, queryParameters: data);
  }

  Future<dynamic> getReservations(Map<String, dynamic> data) async {
    return await dio.get(Constant.reservationlist, queryParameters: data);
  }

  Future<dynamic> getProductSubCategories(Map<String, dynamic> data) async {
    List<Product> products = [];
    final Response result =
        await dio.get(Constant.productSubCategory, queryParameters: data);
    products.addAll(result.data
        .map<Product>(
          (element) => Product.fromMap(element),
        )
        .toList());
    return products;
  }

  Future<TimeTables?> getTimeTables(Map<String, dynamic> data) async {
    TimeTables? timeTables;
    try {
      Response timeTablesData =
          await dio.get(Constant.homeList, queryParameters: data);
      timeTables = TimeTables.fromJson(timeTablesData.data);
    } on DioError catch (e) {
      if (e.response != null) {
      } else {}
    }
    return timeTables;
  }

  Future<TimeTables?> getTimeTablesV3(Map<String, dynamic> data) async {
    TimeTables? timeTables;
    try {
      Response timeTablesData =
          await dio.get(Constant.homeListV3, queryParameters: data);
      timeTables = TimeTables.fromJson(timeTablesData.data);
    } on DioError catch (e) {
      if (e.response != null) {
      } else {}
    }
    return timeTables;
  }

  Future<dynamic> fetchSubCategories() async {
    return await dio.get(Constant.fetch_subcategories);
  }

  Future<dynamic> fetchPromoProducts(Map<String, dynamic> data) async {
    return await dio.get(Constant.productPromotional, queryParameters: data);
  }

  Future<dynamic> fetchFeatureProducts(Map<String, dynamic> data) async {
    return await dio.get(Constant.productFeature, queryParameters: data);
  }

  Future<ProductDetail?> getProductDetail(Map<String, dynamic> data) async {
    final result = await dio.get(Constant.productDetail, queryParameters: data);
    if (result.data == 'Not found!') {
      return null;
    } else {
      return ProductDetail.fromMap(result.data[0]);
    }
  }

  Future<dynamic> getPharmacyAdvices(Map<String, dynamic> data) async {
    return await dio.get(Constant.pharmacyAdvice, queryParameters: data);
  }

  Future<dynamic> getPharmacyAdviceCategories(Map<String, dynamic> data) async {
    return await dio.get(Constant.pharmacyAdviceCategory,
        queryParameters: data);
  }

  Future<dynamic> getAdviceForCategory(Map<String, dynamic> data) async {
    return await dio.get(Constant.pharmacyAdviceCat, queryParameters: data);
  }

  Future<dynamic> getGlutenFreeCategories(Map<String, dynamic> data) async {
    return await dio.get(Constant.gultan_category, queryParameters: data);
  }

  Future<List<Product>> searchProducts(Map<String, dynamic> data) async {
    List<Product> products = [];
    final Response result =
        await dio.get(Constant.productSearch, queryParameters: data);
    products.addAll(result.data
        .map<Product>(
          (element) => Product.fromMap(element),
        )
        .toList());
    return products;
  }

  Future<List<Product>> getProductsGmp(Map<String, dynamic> data) async {
    List<Product> products = [];
    final Response result =
        await dio.get(Constant.getProductsGmp, queryParameters: data);
    products.addAll(result.data
        .map<Product>(
          (element) => Product.fromMap(element),
        )
        .toList());
    return products;
  }

  Future<List<Product>> searchAllProducts(Map<String, dynamic> data) async {
    List<Product> products = [];
    final Response result =
        await dio.get(Constant.allProduct, queryParameters: data);

    products.addAll(result.data
        .map<Product>(
          (element) => Product.fromMap(element),
        )
        .toList());

    return products;
  }

  Future<List<Product>> searchGlutenFreeProducts(
      Map<String, dynamic> data) async {
    List<Product> glutenFreeProducts = [];
    final Response result =
        await dio.get(Constant.gultan_product, queryParameters: data);
    glutenFreeProducts.addAll(result.data
        .map<Product>(
          (element) => Product.fromMap(element),
        )
        .toList());
    return glutenFreeProducts;
  }

  Future<List<Product>> getMomAndBabyProducts(Map<String, dynamic> data) async {
    List<Product> products = [];
    final Response result =
        await dio.get(Constant.momBabyProducts, queryParameters: data);

    products.addAll(result.data
        .map<Product>(
          (element) => Product.fromMap(element),
        )
        .toList());
    return products;
  }

  Future<List<Product>> getVeterinaryProducts(Map<String, dynamic> data) async {
    List<Product> products = [];
    final Response result =
        await dio.get(Constant.vaterinaryProduct, queryParameters: data);

    products.addAll(result.data
        .map<Product>(
          (element) => Product.fromMap(element),
        )
        .toList());
    return products;
  }

  Future<dynamic> getWishList(Map<String, dynamic> data) async {
    return await dio.get(Constant.wish_list, queryParameters: data);
  }

  Future<dynamic> getAddressesList(Map<String, dynamic> data) async {
    return await dio.get(Constant.address_list, queryParameters: data);
  }

  Future<Contact> getContact(Map<String, dynamic> data) async {
    final result = await dio.get(Constant.contactus, queryParameters: data);
    return Contact.fromJson(result.data);
  }

  Future<dynamic> createTherapy(Map<String, dynamic> data) async {
    return await dio.post(Constant.therapy_insert, data: data);
  }

  Future<List<ProductItem?>> getProductList(Map<String, dynamic> data) async {
    List<ProductItem?> productList = [];
    try {
      Response productListData =
          await dio.get(Constant.drug_type, queryParameters: data);
      if (productListData.data != null) {
        for (var pr in productListData.data) {
          productList.add(ProductItem.fromJson(pr));
        }
      }
    } on DioError catch (e) {
      print(e);
    }
    return productList;
  }

  Future<dynamic> getTherapies(Map<String, dynamic> data) async {
    List<Therapy> therapies = [];
    final Response result =
        await dio.get(Constant.therapy_list, queryParameters: data);
    therapies.addAll(result.data
        .map<Therapy>(
          (element) => Therapy.fromMap(element),
        )
        .toList());
    return therapies;
  }

  Future<dynamic> getAvailablePills(Map<String, dynamic> data) async {
    return await dio.get(Constant.available_pills, queryParameters: data);
  }

  Future<void> updateAddress(Map<String, dynamic> data) async {
    final result = await dio.post(Constant.update_address, data: data);
  }

  Future<List<News>> getNews(Map<String, dynamic> data) async {
    List<News> news = [];
    final Response result = await dio.get(Constant.news, queryParameters: data);

    news.addAll(result.data
        .map<News>(
          (element) => News.fromJson(element),
        )
        .toList());
    return news;
  }

  Future<void> createAddress(Map<String, dynamic> data) async {
    final result = await dio.post(Constant.add_address, data: data);
  }

  Future<dynamic> getEventsList(Map<String, dynamic> data) async {
    return await dio.get(Constant.event_list, queryParameters: data);
  }

  Future<dynamic> getSimilarProduct(Map<String, dynamic> data) async {
    return await dio.get(Constant.similarProducts, queryParameters: data);
  }

  Future<dynamic> signUp(Map<String, dynamic> data) async {
    return await dio.post(
      Constant.register,
      data: data,
    );
  }

  Future<dynamic> login(Map<String, dynamic> data) async {
    return await dio.post(Constant.login, data: data);
  }

  Future<dynamic> logout(Map<String, dynamic> data) async {
    return await dio.post(Constant.logout, data: data);
  }

  Future<dynamic> getRentalList(Map<String, dynamic> data) async {
    return await dio.get(Constant.my_rental_product, queryParameters: data);
  }

  Future<dynamic> getTeamData(Map<String, dynamic> data) async {
    return await dio.get(Constant.ourTeam, queryParameters: data);
  }

  Future<dynamic> getFlyers(Map<String, dynamic> data) async {
    return await dio.get(Constant.flyers, queryParameters: data);
  }

  Future<dynamic> getOffers(Map<String, dynamic> data) async {
    return await dio.get(Constant.promationalOffer, queryParameters: data);
  }

  Future<dynamic> cms(Map<String, dynamic> data) async {
    return await dio.post(Constant.cms, data: data);
  }

  Future<dynamic> getShifts(Map<String, dynamic> data) async {
    return await dio.get(Constant.pharmacy_sift, queryParameters: data);
  }

  Future<dynamic> getCouponList(Map<String, dynamic> data) async {
    return await dio.get(Constant.coupon, queryParameters: data);
  }

  Future<List<Product>> getRentalProducts(Map<String, dynamic> data) async {
    List<Product> products = [];
    final Response result = await dio.post(Constant.rentalProduct, data: data);

    products.addAll(result.data
        .map<Product>(
          (element) => Product.fromMap(element),
        )
        .toList());
    return products;
  }

  Future<dynamic> getServicesByType(Map<String, dynamic> data) async {
    return await dio.get(Constant.servicelist, queryParameters: data);
  }

  Future<dynamic> addToWishList(Map<String, dynamic> data) async {
    return await dio.get(Constant.addWishList, queryParameters: data);
  }

  Future<dynamic> removeFromWishList(Map<String, dynamic> data) async {
    return await dio.get(Constant.deleteWishList, queryParameters: data);
  }

  Future<dynamic> getInterestsList(Map<String, dynamic> data) async {
    return await dio.get(Constant.intrestList, queryParameters: data);
  }

  Future<dynamic> addToCart(Map<String, dynamic> data) async {
    return await dio.get(
      "https://stagapp.contactapharmacy.it/api/wp_addto_cart/${data['product_id']}/${data['user_id']}/",
    );
  }

  Future<dynamic> removeToCart(Map<String, dynamic> data) async {
    return await dio.get(
      "https://stagapp.contactapharmacy.it/api/wp_rmto_cart/${data['product_id']}/${data['user_id']}/",
    );
  }

  Future<dynamic> placeOrder(Map<String, dynamic> data) async {
    return await dio.post(Constant.orderPlaced, data: data);
  }

  Future<Order?> getOrderById(Map<String, dynamic> data) async {
    final result = await dio.get(Constant.getOrderById, queryParameters: data);
    if (result.statusCode == 200) {
      return Order.fromJson(result.data);
    }
    return null;
  }

  Future<dynamic> getConventions(Map<String, dynamic> data) async {
    return await dio.get(Constant.conventions, queryParameters: data);
  }

  Future<dynamic> socialRegister(Map<String, dynamic> data) async {
    return await dio.post(Constant.social_register, data: data);
  }

  Future<dynamic> socialLogin(Map<String, dynamic> data) async {
    return await dio.post(Constant.social_login);
  }

  Future<Response?> sendOTP(Map<String, dynamic> data) async {
    try {
      final Response result = await dio.post(Constant.send_OTP, data: data);
      return result;
    } catch (e) {
      return null;
    }
  }

  Future<Response> verifyOTP(Map<String, dynamic> data) async {
    return await dio.post(Constant.verify_OTP, data: data);
  }

  Future<dynamic> addDocument(Map<String, dynamic> data) async {
    return await dio.post(Constant.documentAdd, data: data);
  }

  Future<dynamic> deleteDocument(Map<String, dynamic> data) async {
    return await dio.delete(Constant.documentDelete, data: data);
  }

  Future<dynamic> updateDocument(Map<String, dynamic> data) async {
    return await dio.post(Constant.documentUpdate, data: data);
  }

  Future<dynamic> getDocuments(Map<String, dynamic> data) async {
    return await dio.get(Constant.documentList, queryParameters: data);
  }

  Future<dynamic> getCalendar(Map<String, dynamic> data) async {
    return await dio.get(Constant.getCalendar, queryParameters: data);
  }

  Future<dynamic> getSlotsByDay(Map<String, dynamic> data) async {
    return await dio.get(Constant.getSlotsByDay, queryParameters: data);
  }

  Future<dynamic> createServiceReservation(Map<String, dynamic> data) async {
    return await dio.post(Constant.createServiceReservation, data: data);
  }

  Future<dynamic> getBannerList(Map<String, dynamic> data) async {
    return await dio.get(Constant.bannerList, queryParameters: data);
  }

  Future<dynamic> getReservationById(Map<String, dynamic> data) async {
    return await dio.get(Constant.getReservationById, queryParameters: data);
  }

  Future<dynamic> getUserMe(Map<String, dynamic> data) async {
    return await dio.get(Constant.getUserMe, queryParameters: data);
  }

  Future<dynamic> getStats(Map<String, dynamic> data) async {
    return await dio.get(Constant.order_stats_home, queryParameters: data);
  }

  Future<Response> createOrder(Map<String, dynamic> data) async {
    return await dio.post(Constant.createOrder, data: data);
  }

  Future<List<Product>> getAllGlutenFreeProducts(
      Map<String, dynamic> data) async {
    List<Product> products = [];
    final Response result =
        await dio.get(Constant.all_gultan_product, queryParameters: data);
    products.addAll(result.data
        .map<Product>(
          (element) => Product.fromMap(element),
        )
        .toList());
    return products;
  }

  Future<dynamic> cancelReservation(Map<String, dynamic> data) async {
    return await dio.post(Constant.cancel_reservation, data: data);
  }

  Future<dynamic> deleteUser(Map<String, dynamic> data) async {
    return await dio.post(Constant.deleteUser, data: data);
  }

  Future<dynamic> appointmentById(Map<String, dynamic> data) async {
    return await dio.get(Constant.appointmentById, queryParameters: data);
  }

  Future<dynamic> getAllPrescriptions(Map<String, dynamic> data) async {
    return await dio.get(Constant.getAllPrescriptions, queryParameters: data);
  }

  Future<dynamic> getAllGalenicPreparations(Map<String, dynamic> data) async {
    return dio.get(Constant.getAllGalenicPreparations, queryParameters: data);
  }

  Future<dynamic> getAllProductFromPhoto(Map<String, dynamic> data) async {
    return dio.get(Constant.getAllCustomProducts, queryParameters: data);
  }

  Future<List<MedCabItem>> getMedCabItems(Map<String, dynamic> data) async {
    List<MedCabItem> items = [];
    final Response result =
        await dio.get(Constant.getMedCabItems, queryParameters: data);
    items.addAll(result.data
        .map<MedCabItem>(
          (element) => MedCabItem.fromMap(element),
        )
        .toList());
    return items;
  }

  Future<dynamic> createMedCabItem(Map<String, dynamic> data) async {
    final result = await dio.post(Constant.createMedCabItem, data: data);
  }

  Future<dynamic> updateMedCabItem(Map<String, dynamic> data) async {
    final result = await dio.post(Constant.updateMedCabItem, data: data);
  }

  Future<dynamic> deleteMedCabItem(Map<String, dynamic> data) async {
    final result = await dio.post(Constant.deleteMedCabItem, data: data);
  }

  Future<dynamic> sendGalenicPreparationToPharmacy(
      Map<String, dynamic> data) async {
    return await dio.post(Constant.sendGalenicToPharmacy, data: data);
  }

  Future<Response> sendPrescriptionToPharmacy(Map<String, dynamic> data) async {
    return await dio.post(Constant.sendPrescriptionToPharmacy, data: data);
  }

  Future<dynamic> sendCustomProductToPharmacy(Map<String, dynamic> data) async {
    return await dio.post(Constant.sendCustomProductToPharmacy, data: data);
  }

  Future<dynamic> createEventReservation(Map<String, dynamic> data) async {
    return await dio.post(Constant.createEventReservation, data: data);
  }

  Future<dynamic> getEventReservationStatus(Map<String, dynamic> data) async {
    return await dio.get(Constant.getEventReservationStatus,
        queryParameters: data);
  }

  Future<dynamic> deleteEventReservation(Map<String, dynamic> data) async {
    return await dio.post(Constant.deleteEventReservation, data: data);
  }

  Future<Product?> productBarcodeSearch(Map<String, dynamic> data) async {
    final result =
        await dio.get(Constant.productBarcodeSearch, queryParameters: data);
    if (result.statusCode == 200) {
      if (result.data["code"] != "404") {
        return Product.fromMap(result.data);
      }
    }
    return null;
  }

  Future<dynamic> deleteServiceReservation(Map<String, dynamic> data) async {
    return await dio.post(Constant.deleteServiceReservation, data: data);
  }

  Future<dynamic> recoverPassword(Map<String, dynamic> data) async {
    final result =
        await dio.get(Constant.forgotpassword, queryParameters: data);
    return result;
  }

  Future<dynamic> changePassword(Map<String, dynamic> data) async {
    return await dio.post(Constant.changePassword, data: data);
  }

  Future<dynamic> updateProfile(Map<String, dynamic> data) async {
    return await dio.post(Constant.updateProfile, data: data);
  }

  Future<List<Pill>> getNextPills(Map<String, dynamic> data) async {
    List<Pill> pills = [];
    final result = await dio.get(Constant.getNextPills, queryParameters: data);
    pills.addAll(result.data
        .map<Pill>(
          (element) => Pill.fromJson(element),
        )
        .toList());
    return pills;
  }

  Future<dynamic> changeHourForPill(Map<String, dynamic> data) async {
    return dio.post(Constant.changeHourForPill, data: data);
  }

  Future<dynamic> takePill(Map<String, dynamic> data) async {
    return dio.post(Constant.takePill, data: data);
  }

  Future<dynamic> skipPill(Map<String, dynamic> data) async {
    return dio.post(Constant.skipPill, data: data);
  }

  Future<dynamic> deleteTherapy(Map<String, dynamic> data) async {
    return dio.delete(Constant.therapy_delete, data: data);
  }

  Future<dynamic> updateTherapy(Map<String, dynamic> data) async {
    return dio.post(Constant.therapy_edit, data: data);
  }

  Future<dynamic> updateFCMToken(Map<String, dynamic> data) async {
    return dio.post(Constant.updateFCMToken, data: data);
  }

  Future<dynamic> getNotifications(Map<String, dynamic> data) async {
    List<PharmaNotification> notifications = [];
    final result =
        await dio.get(Constant.getNotifications, queryParameters: data);
    notifications.addAll(result.data
        .map<PharmaNotification>(
          (element) => PharmaNotification.fromMap(element),
        )
        .toList());
    return notifications;
  }

  Future<dynamic> updateNotification(Map<String, dynamic> data) async {
    return await dio.post(Constant.updateNotification, data: data);
  }

  Future<List<Site>> getSedi(Map<String, dynamic> data) async {
    List<Site> sedi = [];
    final result = await dio.get(Constant.sitesList, queryParameters: data);
    sedi.addAll(result.data
        .map<Site>(
          (element) => Site.fromMap(element),
        )
        .toList());
    return sedi;

    // return const [
    //   Sede(
    //       id: '1',
    //       name: 'Farmacia Senato',
    //       address: 'Via Senato 2, 20121 Milano'),
    //   Sede(
    //       id: '2',
    //       name: 'Farmacia Cairoli',
    //       address: 'Via San Giovanni sul Muro 9, 20121 Milano'),
    //   Sede(
    //       id: '3',
    //       name: 'Farmacia Umanitaria',
    //       address: 'Via Maiocchi 14 20129 Milano'),
    //   Sede(
    //       id: '4',
    //       name: 'Farmacia Igea',
    //       address: 'Via Gustavo Modena 25, 20129 Milano'),
    //   Sede(
    //       id: '5',
    //       name: 'Farmacia Ravizza',
    //       address: 'Via Marghera 18 ang Via Ravizza, 20149 Milano'),
    //   Sede(
    //       id: '6',
    //       name: 'Farmacia Sant\'Adele',
    //       address: 'Via Carlo Porta 4 20094 Milano'),
    //   Sede(
    //       id: '7',
    //       name: 'Farmacia F.lli Stilo Canossa',
    //       address: 'Corso Sempione 67, 20149 Milano'),
    // ];
  }
}
