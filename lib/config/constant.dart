import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class Constant {
  static String isDarkMode = "isdarkMode";
  static num pass_minlength = 8;
  static num pass_maxlength = 12;
  static String PREF_USER_MOBILE = "mobile";
  // static String BASE_URL = "https://staging.cpha.it/api/";
  static String BASE_URL = "https://app.cpha.it/api/";
  //static String BASE_URL_NEW = "https://apilaravel.contactapharmacy.it/api/";
  //TODO server
  static String BASE_URL_NEW = "https://stagapp.contactapharmacy.it/api/";

  //static String BASE_URL = "http://150.129.107.47/api/";
  //TODO new base url 02/05/22
  //https://contactaserver02.com/

  static String image_URL = "https://app.cpha.it/media/userimage/";
  static String productApiV = "v4";
  static String authApiV = "v2";
  static String otpApi = "V1";

  static String base64prefix = "data:image/png;base64,";

  //Farmacia di test - Pharma. 1
  /// ENV
  //static int pharmacy_id = 152;
  // static String pharmacy_name = 'Pharma.';
  static bool isCouponActive = false;
  //static bool hasGalenic = true;
  //static bool isParaPharmacy = false;

  ///DA QUI
  //static bool hasConventions = true;
  //static bool hasDigitalFlyers = true;
  //static bool hasCovidServices = true;
  // static bool hasAestheticServices = true;
  //static bool hasVeterinarySection = true;
  //static bool hasMomAndChildSection = true;
  //static bool hasGlutenFreeSection = true;

  static bool isSocialLoginActive = false;

  static BaseOptions options = BaseOptions(
      baseUrl: BASE_URL,
      receiveDataWhenStatusError: true,
      connectTimeout: 50 * 1000, // 60 seconds
      receiveTimeout: 50 * 1000 // 60 seconds
      );

  static BaseOptions optionsNew = BaseOptions(
      baseUrl: BASE_URL_NEW,
      receiveDataWhenStatusError: true,
      connectTimeout: 50 * 1000, // 60 seconds
      receiveTimeout: 50 * 1000 // 60 seconds
      );

  ///endpoints

  static String cms_intro = BASE_URL + "cms_intro";
  static String fetch_subcategories = BASE_URL_NEW + 'fetch_category';
  static String social_register = BASE_URL_NEW + "social_register";
  static String social_login = BASE_URL_NEW + "social_login";
  static String register = BASE_URL_NEW + "register";
  static String intrestList = BASE_URL_NEW + "interestList";
/*  //TODO non serve più?
  static String checkMail = BASE_URL + "check_mail";*/
  static String newPassword = BASE_URL + "newpassword";
  static String changePassword = BASE_URL_NEW + "change_password";
  //TODO nuovo
  static String login = BASE_URL_NEW + "login_api";
  static String screenList = BASE_URL + "cms_intro";
  static String bannerList = BASE_URL_NEW + "bannerList";
  static String homeList = BASE_URL_NEW + "home_listv2";
  static String homeListV3 = BASE_URL_NEW + "home_listv3";
  static String contactus = BASE_URL_NEW + "contact";
  static String followUs = BASE_URL + "follow_us";
  static String news = BASE_URL_NEW + 'news';
  static String pharmacyBanner = BASE_URL + "pharmacy_banner_list";
  static String send_OTP = BASE_URL_NEW + "send_OTP$otpApi";
  static String verify_OTP = BASE_URL_NEW + "verify_OTP$otpApi";
  static String ourTeam = BASE_URL_NEW + "our_team";
  static String flyers = BASE_URL_NEW + "digital_flay";
  static String conventions = BASE_URL_NEW + "conventions_list";
  static String productCategory = BASE_URL + "product_category";
  static String productSearch = BASE_URL_NEW + "product_search$productApiV";
  static String getProductsGmp = BASE_URL_NEW + "getProductsGmpStilo";
  // change by new developer 19_11_21
  // static String productSearch = BASE_URL + "product_searchv4";
  static String productSearchCategory = BASE_URL + "product_search_page";
  static String notificationListStatus = BASE_URL + "notification_flag_Status";
  static String rentalProduct =
      BASE_URL_NEW + "rental_product_list$productApiV";
  static String allProduct = BASE_URL_NEW + "all_product$productApiV";
  static String productBarcodeSearch =
      BASE_URL_NEW + "barcode_product_search$productApiV";
  //TODO
  static String addWishList = BASE_URL_NEW + "add_wish_list";
  static String deleteWishList = BASE_URL_NEW + "delete_wish_list";
  static String productPromotional =
      BASE_URL_NEW + "promational_product$productApiV";
  static String productSubCategory = BASE_URL_NEW + "getProductSubcategory";
  static String productFeature = BASE_URL_NEW + "feature_product$productApiV";
  static String similarProducts = BASE_URL_NEW + "simillar_productsv5";
  // static String categoryProducts = BASE_URL + "subcategory_products";
  static String categoryProducts = BASE_URL + "subcategory_productsv5";
  static String prescriptionList = BASE_URL + "prescription_list";
  static String documentList = BASE_URL_NEW + "document_list";
  static String documentDelete = BASE_URL_NEW + "delete_document";
  static String documentShare = BASE_URL + "document_share";
  static String documentAdd = BASE_URL_NEW + "add_document";
  static String documentUpdate = BASE_URL_NEW + 'update_document';
  static String promationalOffer = BASE_URL_NEW + "promational_offer";
  static String pharmacyAdvice = BASE_URL_NEW + "pharmacy_advice";
  static String pharmacyAdviceCategory =
      BASE_URL_NEW + "pharmacy_advice_category";
  static String pharmacyAdviceCat = BASE_URL_NEW + "pharmacyAdvice";
  static String productDetail = BASE_URL_NEW + "product_detail";
  static String cms = BASE_URL_NEW + "cmsv1";
  static String assets = BASE_URL + "assets";
  //TODO cosa fa???
  static String userBlock = BASE_URL + "userblock";
  //TODO check
  static String logout = BASE_URL_NEW + "logout";
  static String forgotpassword = BASE_URL_NEW + "forgotpassword";
  static String notificationStatus = BASE_URL + "notification-status";
  static String notificationlist = BASE_URL + "notificationListv1";
  static String gultan_category = BASE_URL_NEW + "gultan_category";
  static String gultan_product = BASE_URL_NEW + "gultan_product$productApiV";
  static String wish_list = BASE_URL_NEW + "wish_list";
  static String add_address = BASE_URL_NEW + "add_address";
  static String update_address = BASE_URL_NEW + "update_address";
  static String address_list = BASE_URL_NEW + "address_list";
  static String myorders_list = BASE_URL_NEW + "myorders_list";
  static String order_stats_home = BASE_URL_NEW + "order_stats";
  static String orderTracking = BASE_URL + "order_tracking_list";
  static String coupon = BASE_URL_NEW + "couponslist";
  static String servicelist = BASE_URL_NEW + "servicev1";
  static String momBabyProducts =
      BASE_URL_NEW + "mom_child_Product$productApiV";
  static String vaterinaryProduct =
      BASE_URL_NEW + "vaterinary_product$productApiV";
  static String reservationlist = BASE_URL_NEW + "appointment_reservation";

  ///deprecated sostituito da orderCustomer createOrder
  static String orderPlaced = BASE_URL_NEW + "order_placedv4";

  static String createOrder = BASE_URL_NEW + "orderCustomer";
  static String rentalPlaced = BASE_URL + "rental_placed";

  /// HEALTH SECTION BEGIN
  static String edithealth = BASE_URL_NEW + "edit_health_data";
  static String addHealth = BASE_URL_NEW + "add_health_data";
  static String addHealthChart = BASE_URL_NEW + "add_health_chart_data";
  static String editHealthChart = BASE_URL_NEW + "edit_health_chart_data";
  static String deleteHealthChart = BASE_URL_NEW + "delete_health_chart_data";
  static String health_chart_data = BASE_URL_NEW + "health_chart_data";
  static String health_data = BASE_URL_NEW + "health_data";

  /// HEALTH SECTION END
  static String add_appointment = BASE_URL + "add_appointment";
  static String therapy_report = BASE_URL + "therapy_report";
  static String therapy_time_change = BASE_URL + "therapy_time_change";
  static String drug_type = BASE_URL_NEW + "drug_typev1";
  static String therapy_list = BASE_URL_NEW + "therapy_list";
  static String therapy_status_list = BASE_URL + "therapy_status_list";
  static String therapy_status_change = BASE_URL + "therapy_change";
  static String therapy_status_change1 = BASE_URL + "therapy_status_change";
  //TODO finire
  static String available_pills = BASE_URL_NEW + 'all_available_pills';
  static String pharmacy_sift = BASE_URL_NEW + "pharmacy-shift";
  // static String therapy_insert = BASE_URL + "therapy_insert";
  static String therapy_edit = BASE_URL_NEW + "therapy_update";
  static String therapy_insert = BASE_URL_NEW + "therapy_add";
  static String my_rental_product = BASE_URL_NEW + "my_rental_productv4";
  static String therapy_delete = BASE_URL_NEW + "therapy_delete";
  static String notificationEnable = BASE_URL + "notificationDisplay";
  // static String calender = BASE_URL + "calender";
  // static String calender = BASE_URL + "calenderv5";
  static String getCalendar = BASE_URL_NEW + "get_calendar";
  static String getSlotsByDay = BASE_URL_NEW + "get_slots_by_day";
  static String createServiceReservation =
      BASE_URL_NEW + "create_service_reservation";

  //static String calenderAll = BASE_URL + "slot_listv2";
  // static String slotList = BASE_URL + "slot_list";
  //static String slotList = BASE_URL + "slot_listv1";
  //todo bug2
  static String changeProfile = BASE_URL + "change_Profilev1";
  static String event_list = BASE_URL_NEW + "event_list";
  static String status_list = BASE_URL + "status_list";
  static String all_gultan_product =
      BASE_URL_NEW + "all_gultan_product$productApiV";
  static String cancel_reservation = BASE_URL_NEW + "cancel_reservation";
  static String deleteUser = BASE_URL_NEW + "delete_user";
  static String getMe = BASE_URL_NEW + "GetMe";
  static String myordersById = BASE_URL + "myorders_id";
  static String getOrderById = BASE_URL_NEW + "get_order_by_id";
  static String appointmentById = BASE_URL_NEW + "appointment_byserviceid";
  static String review = BASE_URL + "review";
  static String conventions_count = BASE_URL + "conventions_count";
  static String documentAddMulti = BASE_URL + "document_new";
  static String getReservationById = BASE_URL_NEW + 'get_reservation_by_id';
  static String getUserMe = BASE_URL_NEW + 'getMe';
  static String updateProfile = BASE_URL_NEW + 'updateProfile';

  static String sitesList = BASE_URL_NEW + "sitesList";

  ///NUOVE APIs
  ///terapie
  static String getNextPills = BASE_URL_NEW + 'get_next_pills';
  static String changeHourForPill = BASE_URL_NEW + 'change_hour_for_pill';
  static String takePill = BASE_URL_NEW + 'take_pill';
  static String skipPill = BASE_URL_NEW + 'skip_pill';

  ///MEDCAB APIs
  static String getMedCabItems = BASE_URL_NEW + 'get_medCab_by_user';
  static String createMedCabItem = BASE_URL_NEW + 'create_medCab';
  static String updateMedCabItem = BASE_URL_NEW + 'update_medCab';
  static String deleteMedCabItem = BASE_URL_NEW + 'delete_medCab';

  ///FINE MEDCAB

  static String sendGalenicToPharmacy =
      BASE_URL_NEW + 'create_galenic_preparation_for_pharmacy';
  static String sendPrescriptionToPharmacy =
      BASE_URL_NEW + 'create_recipe_for_pharmacy';
  static String sendCustomProductToPharmacy =
      BASE_URL_NEW + 'create_user_product_for_pharmacy';

  static String getAllGalenicPreparations =
      BASE_URL_NEW + 'galenic_preparation_getAll';
  static String getAllPrescriptions = BASE_URL_NEW + 'recipe_getAll';
  static String getAllCustomProducts =
      BASE_URL_NEW + 'user_product_for_pharmacy_getAll';

  static String getGalenicPreparationById =
      BASE_URL_NEW + 'galenic_preparation_get_by_id';
  static String getPrescriptionById = BASE_URL_NEW + 'recipe_get_by_id';
  static String getCustomProductById =
      BASE_URL_NEW + 'user_product_for_pharmacy_get_by_id';

  static String deleteServiceReservation =
      BASE_URL_NEW + 'delete_service_reservation';

  static String createEventReservation =
      BASE_URL_NEW + 'create_event_reservation';
  static String getEventReservationStatus = BASE_URL_NEW + 'reservation_status';
  static String deleteEventReservation =
      BASE_URL_NEW + 'delete_event_reservation';

  static String updateFCMToken = BASE_URL_NEW + 'refresh_notification_token';

  /// notifiche
  static String getNotifications = BASE_URL_NEW + 'get_notifiche';
  static String updateNotification = BASE_URL_NEW + 'aggiorna_notifica';

  static String isSetPassword = "isSetPassword";
  static String somethingWentWrong =
      "Something went wrong, Please try again later";
  static String userBlockString = "You are blocked";

  static const List<Color> adviceColors = [
    Color(0xffFFB468),
    Color(0xff007F7A),
    Color(0xffE8505B),
    Color(0xffC550BA),
    Color(0xff4B8376),
    Color(0xffE3844C),
  ];

  static InputDecoration borderTextFieldDecoration(Color lightPrimary) {
    return InputDecoration(
      //TODO forse cambiare
      hintStyle: TextStyle(
        color: AppColors.darkGrey.withOpacity(0.7),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: lightPrimary),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}

List<String> conversionTableForBase32 = [];
