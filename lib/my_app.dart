import 'dart:io';

import 'package:contacta_pharmacy/config/permissionConfig.dart';
import 'package:contacta_pharmacy/models/flavor.dart';
import 'package:contacta_pharmacy/providers/app_provider.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/theme/theme.dart';
import 'package:contacta_pharmacy/translations/delegate.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_connection/no_connection_screen.dart';
import 'package:contacta_pharmacy/ui/screens/about_us_screen.dart';
import 'package:contacta_pharmacy/ui/screens/advice/advice_category_screen.dart';
import 'package:contacta_pharmacy/ui/screens/advice/advice_detail.dart';
import 'package:contacta_pharmacy/ui/screens/advice/advices_screen.dart';
import 'package:contacta_pharmacy/ui/screens/available_pills.dart';
import 'package:contacta_pharmacy/ui/screens/cart/cart_screen.dart';
import 'package:contacta_pharmacy/ui/screens/conventions_screen.dart';
import 'package:contacta_pharmacy/ui/screens/coupons_screen.dart';
import 'package:contacta_pharmacy/ui/screens/covid_19_screen.dart';
import 'package:contacta_pharmacy/ui/screens/digital_flyers_screen.dart';
import 'package:contacta_pharmacy/ui/screens/documents/create_document_screen.dart';
import 'package:contacta_pharmacy/ui/screens/documents/item_deleted.dart';
import 'package:contacta_pharmacy/ui/screens/documents/saved_documents_screen.dart';
import 'package:contacta_pharmacy/ui/screens/documents/show_document_detail.dart';
import 'package:contacta_pharmacy/ui/screens/health_folder/health_folder.dart';
import 'package:contacta_pharmacy/ui/screens/home_screen.dart';
import 'package:contacta_pharmacy/ui/screens/login/login_screen.dart';
import 'package:contacta_pharmacy/ui/screens/login/pre_login_screen.dart';
import 'package:contacta_pharmacy/ui/screens/login/recover_password_screen.dart';
import 'package:contacta_pharmacy/ui/screens/main_screen.dart';
import 'package:contacta_pharmacy/ui/screens/medcab/insert_product_medcab.dart';
import 'package:contacta_pharmacy/ui/screens/medcab/med_cab_screen.dart';
import 'package:contacta_pharmacy/ui/screens/medcab/medcab_edit_item.dart';
import 'package:contacta_pharmacy/ui/screens/news/news_detail_screen.dart';
import 'package:contacta_pharmacy/ui/screens/news/news_screen.dart';
import 'package:contacta_pharmacy/ui/screens/notifications/notification_detail.dart';
import 'package:contacta_pharmacy/ui/screens/notifications/notifications_screen.dart';
import 'package:contacta_pharmacy/ui/screens/onboarding_screen.dart';
import 'package:contacta_pharmacy/ui/screens/orders/my_orders_screen.dart';
import 'package:contacta_pharmacy/ui/screens/orders/order_detail_screen.dart';
import 'package:contacta_pharmacy/ui/screens/otp_screen.dart';
import 'package:contacta_pharmacy/ui/screens/our_team.dart';
import 'package:contacta_pharmacy/ui/screens/pharmacy/contact_screen.dart';
import 'package:contacta_pharmacy/ui/screens/pharmacy/pharmacy_offer_detail_screen.dart';
import 'package:contacta_pharmacy/ui/screens/pharmacy/pharmacy_offers_screen.dart';
import 'package:contacta_pharmacy/ui/screens/pharmacy_screen.dart';
import 'package:contacta_pharmacy/ui/screens/prescriptions/prescription_detail_screen.dart';
import 'package:contacta_pharmacy/ui/screens/prescriptions/prescription_sent.dart';
import 'package:contacta_pharmacy/ui/screens/prescriptions/prescriptions_screen.dart';
import 'package:contacta_pharmacy/ui/screens/prescriptions/send_med_prescription.dart';
import 'package:contacta_pharmacy/ui/screens/prescriptions/send_vet_prescription.dart';
import 'package:contacta_pharmacy/ui/screens/privacy_policy_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/all_gluten_free_products.dart';
import 'package:contacta_pharmacy/ui/screens/products/galenic_preparation_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/gluten_free_products_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/mom_and_baby_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/product_categories_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/product_category_detail_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/product_detail_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/product_photo_detail.dart';
import 'package:contacta_pharmacy/ui/screens/products/product_search_from_barcode.dart';
import 'package:contacta_pharmacy/ui/screens/products/products_add_product_from_photo.dart';
import 'package:contacta_pharmacy/ui/screens/products/products_on_sale_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/products_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/products_search_results.dart';
import 'package:contacta_pharmacy/ui/screens/products/products_show_all.dart';
import 'package:contacta_pharmacy/ui/screens/products/saved_products_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/scheda_prodotto.dart';
import 'package:contacta_pharmacy/ui/screens/products/search_gluten_free.dart';
import 'package:contacta_pharmacy/ui/screens/products/showcase_products_screen_all.dart';
import 'package:contacta_pharmacy/ui/screens/products/showcase_products_screen_preview.dart';
import 'package:contacta_pharmacy/ui/screens/rentals/my_rentals_screen.dart';
import 'package:contacta_pharmacy/ui/screens/rentals/rental_detail_screen.dart';
import 'package:contacta_pharmacy/ui/screens/rentals/rental_products.dart';
import 'package:contacta_pharmacy/ui/screens/reservations/my_reservations_screen.dart';
import 'package:contacta_pharmacy/ui/screens/reservations/reservation_detail_screen.dart';
import 'package:contacta_pharmacy/ui/screens/sent_to_pharmacy/sent_galenic_detail.dart';
import 'package:contacta_pharmacy/ui/screens/sent_to_pharmacy/sent_product_from_photo_detail.dart';
import 'package:contacta_pharmacy/ui/screens/sent_to_pharmacy/sent_to_pharmacy_screen.dart';
import 'package:contacta_pharmacy/ui/screens/services/aesthetic_services.dart';
import 'package:contacta_pharmacy/ui/screens/services/booking/book_service.dart';
import 'package:contacta_pharmacy/ui/screens/services/booking/book_service_first_screen.dart';
import 'package:contacta_pharmacy/ui/screens/services/booking/book_service_second_screen.dart';
import 'package:contacta_pharmacy/ui/screens/services/booking/book_service_working.dart';
import 'package:contacta_pharmacy/ui/screens/services/covid19_services.dart';
import 'package:contacta_pharmacy/ui/screens/services/events/event_detail_screen.dart';
import 'package:contacta_pharmacy/ui/screens/services/events/events_screen.dart';
import 'package:contacta_pharmacy/ui/screens/services/general_services.dart';
import 'package:contacta_pharmacy/ui/screens/services/medical_analyst_services.dart';
import 'package:contacta_pharmacy/ui/screens/services/service_detail_screen.dart';
import 'package:contacta_pharmacy/ui/screens/services/service_web_view.dart';
import 'package:contacta_pharmacy/ui/screens/services/services_screen.dart';
import 'package:contacta_pharmacy/ui/screens/services/videocall_page.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_add_address.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_add_card.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_change_language.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_change_password.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_edit_address.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_edit_profile.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_general_screen.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_manage_addresses.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_notification.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_profile_screen.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_screen.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_therapy_screen.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_therapy_sound.dart';
import 'package:contacta_pharmacy/ui/screens/shift_zoom_image_detail.dart';
import 'package:contacta_pharmacy/ui/screens/shifts_screen.dart';
import 'package:contacta_pharmacy/ui/screens/signup_screen.dart';
import 'package:contacta_pharmacy/ui/screens/social_register/complete_profile_register_social.dart';
import 'package:contacta_pharmacy/ui/screens/splash/splash_screen.dart';
import 'package:contacta_pharmacy/ui/screens/splash/splash_screen_second.dart';
import 'package:contacta_pharmacy/ui/screens/terms_and_conditions_screen.dart';
import 'package:contacta_pharmacy/ui/screens/test_screen.dart';
import 'package:contacta_pharmacy/ui/screens/therapies/create_therapy_first_screen.dart';
import 'package:contacta_pharmacy/ui/screens/therapies/create_therapy_second_screen.dart';
import 'package:contacta_pharmacy/ui/screens/therapies/create_therapy_third_screen.dart';
import 'package:contacta_pharmacy/ui/screens/therapies/edit_therapy_first_screen.dart';
import 'package:contacta_pharmacy/ui/screens/therapies/edit_therapy_second_screen.dart';
import 'package:contacta_pharmacy/ui/screens/therapies/therapies_screen.dart';
import 'package:contacta_pharmacy/ui/screens/user_already_exists.dart';
import 'package:contacta_pharmacy/ui/screens/user_created_successfully.dart';
import 'package:contacta_pharmacy/ui/screens/vet_offers_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'ui/screens/multisede/site_select_screen.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key, required this.navigatorKey}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // AppModel appModel = AppModel();

  @override
  void initState() {
    super.initState();
    initApp();
  }

  void initApp() async {
    await PermissionConfig.getPermission();
    final user = ref.read(authProvider).user;
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(appProvider).locale;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark),
    );
    return Sizer(builder: (context, orientation, deviceType) {
      return FutureBuilder(
          future: PermissionConfig.getLanguage(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            var temp = "";
            if (snapshot.hasData) {
              temp = snapshot.data!;
            }
            return MaterialApp(
              navigatorKey: widget.navigatorKey,
              //TODO fix this
              title: ref.read(flavorProvider).pharmacyName,
              //locale: locale,
              localizationsDelegates: [
                MyLocalizationsDelegate(temp.isEmpty ? locale : Locale(temp)),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                //Localization.delegate
              ],
              //TODO comment this for ita
              // locale: Locale('en'),
              supportedLocales: const [
                Locale('it'), // Ita, no country code
                Locale('en'), // English, no country code
              ],
              localeResolutionCallback:
                  (Locale? locale, Iterable<Locale> supportedLocales) {
                for (Locale supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode ||
                      supportedLocale.countryCode == locale?.countryCode) {
                    return supportedLocale;
                  }
                }

                return supportedLocales.first;
              },
              debugShowCheckedModeBanner: false,
              initialRoute: SplashScreen.routeName,
              //initialRoute: MultisedeChoose.routeName,
              builder: EasyLoading.init(),

              routes: {
                SplashScreen.routeName: (context) => const SplashScreen(),
                SplashScreenSecond.routeName: (context) =>
                    const SplashScreenSecond(),
                OnBoardingScreen.routeName: (context) =>
                    const OnBoardingScreen(),
                LoginScreen.routeName: (context) => const LoginScreen(),
                PreLoginScreen.routeName: (context) => const PreLoginScreen(),
                MainScreen.routeName: (context) => const MainScreen(),
                HomeScreen.routeName: (context) => const HomeScreen(),
                ProductsScreen.routeName: (context) => const ProductsScreen(),
                ServicesScreen.routeName: (context) => const ServicesScreen(),
                PharmacyScreen.routeName: (context) => const PharmacyScreen(),
                SignUpScreen.routeName: (context) => const SignUpScreen(),
                MyOrdersScreen.routeName: (context) => const MyOrdersScreen(),
                MyReservationsScreen.routeName: (context) =>
                    const MyReservationsScreen(),
                ProductDetailScreen.routeName: (context) =>
                    const ProductDetailScreen(),
                NotificationDetailScreen.routeName: (context) =>
                    const NotificationDetailScreen(),
                CartScreen.routeName: (context) => const CartScreen(),
                ProductCategoriesScreen.routeName: (context) =>
                    const ProductCategoriesScreen(),
                ProductsAddProductFromPhotoScreen.routeName: (context) =>
                    const ProductsAddProductFromPhotoScreen(),
                ProductsOnSaleScreen.routeName: (context) =>
                    const ProductsOnSaleScreen(),
                AboutUsScreen.routeName: (context) => const AboutUsScreen(),
                AdvicesScreen.routeName: (context) => const AdvicesScreen(),
                Covid19Screen.routeName: (context) => const Covid19Screen(),
                HealthFolder.routeName: (context) => const HealthFolder(),
                ConventionsScreen.routeName: (context) =>
                    const ConventionsScreen(),
                AvailablePillsScreen.routeName: (context) =>
                    const AvailablePillsScreen(),
                GalenicPreparationScreen.routeName: (context) =>
                    const GalenicPreparationScreen(),
                GlutenFreeProductsScreen.routeName: (context) =>
                    const GlutenFreeProductsScreen(),
                SavedProductsScreen.routeName: (context) =>
                    const SavedProductsScreen(),
                MomAndBabyScreen.routeName: (context) =>
                    const MomAndBabyScreen(),
                VetOffersScreen.routeName: (context) => const VetOffersScreen(),
                SettingsScreen.routeName: (context) => const SettingsScreen(),
                SettingsProfile.routeName: (context) => const SettingsProfile(),
                SettingsGeneralScreen.routeName: (context) =>
                    const SettingsGeneralScreen(),
                SendMedPrescription.routeName: (context) =>
                    const SendMedPrescription(),
                SendVetPrescription.routeName: (context) =>
                    const SendVetPrescription(),
                SavedDocumentsScreen.routeName: (context) =>
                    const SavedDocumentsScreen(),
                ShowDocumentDetail.routeName: (context) =>
                    const ShowDocumentDetail(),
                SettingsEditProfile.routeName: (context) =>
                    const SettingsEditProfile(),
                SettingsAddCard.routeName: (context) => const SettingsAddCard(),
                SettingsNotificationsScreen.routeName: (context) =>
                    const SettingsNotificationsScreen(),
                SettingsTherapyScreen.routeName: (context) =>
                    const SettingsTherapyScreen(),
                SettingsTherapySoundScreen.routeName: (context) =>
                    const SettingsTherapySoundScreen(),
                NotificationsScreen.routeName: (context) =>
                    const NotificationsScreen(),
                MedCabScreen.routeName: (context) => const MedCabScreen(),
                NewsScreen.routeName: (context) => const NewsScreen(),
                ShiftsScreen.routeName: (context) => const ShiftsScreen(),
                OurTeamScreen.routeName: (context) => const OurTeamScreen(),
                MyRentalsScreen.routeName: (context) => const MyRentalsScreen(),
                CouponsScreen.routeName: (context) => const CouponsScreen(),
                ContactScreen.routeName: (context) => const ContactScreen(),
                GeneralServices.routeName: (context) => const GeneralServices(),
                AestheticServices.routeName: (context) =>
                    const AestheticServices(),
                Covid19Services.routeName: (context) => const Covid19Services(),
                MedicalAnalystServices.routeName: (context) =>
                    const MedicalAnalystServices(),
                EventsScreen.routeName: (context) => const EventsScreen(),
                RentalProducts.routeName: (context) => const RentalProducts(),
                ShowCaseProductsScreenPreview.routeName: (context) =>
                    const ShowCaseProductsScreenPreview(),
                ProductPhotoDetail.routeName: (context) =>
                    const ProductPhotoDetail(),
                AdviceCategoryScreen.routeName: (context) =>
                    const AdviceCategoryScreen(),
                ProductsSearchResults.routeName: (context) =>
                    const ProductsSearchResults(),
                ProductsShowAll.routeName: (context) => const ProductsShowAll(),
                OtpScreen.routeName: (context) => const OtpScreen(),
                SettingsManageAddresses.routeName: (context) =>
                    const SettingsManageAddresses(),
                SettingsEditAddress.routeName: (context) =>
                    const SettingsEditAddress(),
                SettingsAddAddress.routeName: (context) =>
                    const SettingsAddAddress(),
                SettingsChangePassword.routeName: (context) =>
                    const SettingsChangePassword(),
                OrderDetailScreen.routeName: (context) =>
                    const OrderDetailScreen(),
                ReservationDetailScreen.routeName: (context) =>
                    const ReservationDetailScreen(),
                TestScreen.routeName: (context) => const TestScreen(),
                TherapiesScreen.routeName: (context) => const TherapiesScreen(),
                CreateTherapyFirstScreen.routeName: (context) =>
                    const CreateTherapyFirstScreen(),
                CreateTherapySecondScreen.routeName: (context) =>
                    const CreateTherapySecondScreen(),
                CreateTherapyThirdScreen.routeName: (context) =>
                    const CreateTherapyThirdScreen(),
                SettingsChangeLanguage.routeName: (context) =>
                    const SettingsChangeLanguage(),
                ProductCategoryDetail.routeName: (context) =>
                    const ProductCategoryDetail(),
                RentalDetailScreen.routeName: (context) =>
                    const RentalDetailScreen(),
                ServiceDetailScreen.routeName: (context) =>
                    const ServiceDetailScreen(),
                // BookService.routeName: (context) => const BookService(),
                SearchGlutenFree.routeName: (context) =>
                    const SearchGlutenFree(),
                EventDetailScreen.routeName: (context) =>
                    const EventDetailScreen(),
                ShowcaseProductsScreenAll.routeName: (context) =>
                    const ShowcaseProductsScreenAll(),
                NewsDetails.routeName: (context) => const NewsDetails(),
                AdviceDetail.routeName: (context) => const AdviceDetail(),
                InsertProductMedCab.routeName: (context) =>
                    const InsertProductMedCab(),
                DigitalFlyersScreen.routeName: (context) =>
                    const DigitalFlyersScreen(),
                SentToPharmacyScreen.routeName: (context) =>
                    const SentToPharmacyScreen(),
                PharmacyOffersScreen.routeName: (context) =>
                    const PharmacyOffersScreen(),
                PharmacyOfferDetail.routeName: (context) =>
                    const PharmacyOfferDetail(),
                ItemSent.routeName: (context) => const ItemSent(),
                PrivacyPolicyScreen.routeName: (context) =>
                    const PrivacyPolicyScreen(),
                TermsConditionScreen.routeName: (context) =>
                    const TermsConditionScreen(),
                ConnectionOff.routeName: (context) => const ConnectionOff(),
                EditTherapyFirstScreen.routeName: (context) =>
                    const EditTherapyFirstScreen(),
                EditTherapySecondScreen.routeName: (context) =>
                    const EditTherapySecondScreen(),
                CreateDocument.routeName: (context) => const CreateDocument(),
                EditProductMedCab.routeName: (context) =>
                    const EditProductMedCab(),
                PrescriptionScreen.routeName: (context) =>
                    const PrescriptionScreen(),
                AllGlutenFreeProductsScreen.routeName: (context) =>
                    const AllGlutenFreeProductsScreen(),
                // BookServiceWorking.routeName: (context) =>
                //     const BookServiceWorking(),
                BookServiceFirstScreen.routeName: (context) =>
                    const BookServiceFirstScreen(),
                BookServiceSecondScreen.routeName: (context) =>
                    const BookServiceSecondScreen(),
                UserCreatedSuccessFully.routeName: (context) =>
                    const UserCreatedSuccessFully(),
                ProductsSearchFromBarcode.routeName: (context) =>
                    const ProductsSearchFromBarcode(),
                ShiftZoomImageDetail.routeName: (context) =>
                    const ShiftZoomImageDetail(),
                PrescriptionDetailScreen.routeName: (context) =>
                    const PrescriptionDetailScreen(),
                GalenicDetailScreen.routeName: (context) =>
                    const GalenicDetailScreen(),
                ProductFromPhotoDetailScreen.routeName: (context) =>
                    const ProductFromPhotoDetailScreen(),
                RecoverPasswordScreen.routeName: (context) =>
                    const RecoverPasswordScreen(),
                CompleteProfileRegisterSocial.routeName: (context) =>
                    const CompleteProfileRegisterSocial(),
                UserAlreadyExists.routeName: (context) =>
                    const UserAlreadyExists(),
                SchedaProdotto.routeName: (context) => const SchedaProdotto(),
                ItemDeleted.routeName: (context) => const ItemDeleted(),
                SiteSelectScreen.routeName: (context) =>
                    const SiteSelectScreen(),
                ServicesWebView.routeName: (context) => const ServicesWebView(),
                // VideoCallPage.routeName: (context) => const VideoCallPage(),
              },
              theme: Platform.isAndroid
                  ? AppTheme.getTheme(ref.read(flavorProvider))
                  : AppTheme.getTheme(ref.read(flavorProvider)).copyWith(
                      appBarTheme: AppBarTheme(
                        centerTitle: true,
                        elevation: 0,
                        backgroundColor: Colors.white,
                        titleTextStyle: TextStyle(
                          color: ref.read(flavorProvider).primary,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 20.5,
                          fontWeight: FontWeight.w700,
                        ),
                        iconTheme: const IconThemeData(
                          color: Colors.black54,
                        ),
                      ),
                    ),
            );
          });
    });
  }
}
