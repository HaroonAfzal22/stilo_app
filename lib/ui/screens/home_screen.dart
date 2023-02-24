import 'package:contacta_pharmacy/config/permissionConfig.dart';
import 'package:contacta_pharmacy/providers/time_tables_provider.dart';
import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/custom_drawer.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/home_features_list.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/home_item.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/pharmacy_hero.dart';
import 'package:contacta_pharmacy/ui/screens/conventions_screen.dart';
import 'package:contacta_pharmacy/ui/screens/health_folder/health_folder.dart';
import 'package:contacta_pharmacy/ui/screens/orders/my_orders_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/products_search_results.dart';
import 'package:contacta_pharmacy/ui/screens/products/showcase_products_screen_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/flavor.dart';
import '../../theme/app_colors.dart';
import '../../utils/pharma32.dart';
import '../custom_widgets/badge_notification.dart';
import '../custom_widgets/bottom_sheets/bottom_sheet_barcode_info.dart';
import '../custom_widgets/bottom_sheets/bottom_sheet_hours.dart';
import '../custom_widgets/bottom_sheets/bottom_sheet_prescription.dart';
import '../custom_widgets/home_stats_widget.dart';
import '../custom_widgets/products/product_list_promo_showcase.dart';
import '../custom_widgets/title_text.dart';
import 'notifications/notifications_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
    //   await ref.read(timeTablesProvider).getTimeTables();
    // });
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  String searchText = "";
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final flavor = ref.read(flavorProvider);
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          key: _key,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Image.asset(
              'assets/flavor/appbar.png',
              height: 32,
            ),
            leading: IconButton(
              onPressed: () {
                _key.currentState!.openDrawer();
              },
              icon: Image.asset(
                'assets/icons/ic_menu.png',
                height: 18,
                color: ref.read(flavorProvider).lightPrimary,
                width: 34,
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    builder: (BuildContext context) => const BottomSheetHours(),
                  );
                },
                child: Icon(
                  Icons.watch_later,
                  color: ref.read(flavorProvider).lightPrimary,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
                child: const BadgeNotifications(),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
          drawer: const CustomDrawer(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: TextField(
                    onSubmitted: (value) {
                      Navigator.of(context).pushNamed(
                          ProductsSearchResults.routeName,
                          arguments: value);
                    },
                    textAlignVertical: TextAlignVertical.center,
                    controller: _controller,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      hintStyle: const TextStyle(
                          fontSize: 14,
                          color: AppColors.lightGrey,
                          fontWeight: FontWeight.w400),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            backgroundColor: Colors.white,
                            builder: (BuildContext context) =>
                                const BottomSheetInstructionScanner(),
                          );
                        },
                        /*      onPressed: () async {
                          var code = await scanBarcode();
                          if (code == null) {
                            showredToast(
                                translate(context, "permission_denied"),
                                context);
                          } else if (code != "-1") {
                            Navigator.of(context).pushNamed(
                                ProductsSearchFromBarcode.routeName,
                                arguments: code);
                          }
                        },*/
                        icon: Image.asset(
                          'assets/images/barcode.png',
                          height: 50,
                          width: 50,
                        ),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: translate(context, 'search_hint'),
                    ),
                  ),
                ),
                Consumer(builder: (context, ref, _) {
                  final timeTables = ref.watch(timeTableProvider).value;

                  return timeTables == null
                      ? Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          height: 120,
                          decoration: BoxDecoration(
                            color: ref.read(flavorProvider).lightPrimary,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : PharmacyHero(
                          imageUrl: timeTables.bannerImage ??
                              'https://blumagnolia.ch/wp-content/uploads/2021/05/placeholder-126.png',
                          morningHoursOpen: timeTables
                              .hours![DateTime.now().weekday - 1]
                              .morningHoursOpen,
                          morningHoursClose: timeTables
                              .hours![DateTime.now().weekday - 1]
                              .morningHoursClose,
                          eveningHoursOpen: timeTables
                              .hours![DateTime.now().weekday - 1]
                              .eveningHoursOpen,
                          eveningHoursClose: timeTables
                              .hours![DateTime.now().weekday - 1]
                              .eveningHoursClose,
                          telephone: "",
                          todayOpeningHoursMorning: timeTables
                                  .hours![DateTime.now().weekday - 1]
                                  .morningHoursOpen ??
                              "",
                          todayClosingHoursMorning: timeTables
                                  .hours![DateTime.now().weekday - 1]
                                  .morningHoursClose ??
                              "",
                          todayOpeningHoursEvening: timeTables
                                  .hours![DateTime.now().weekday - 1]
                                  .eveningHoursOpen ??
                              "",
                          todayClosingHoursEvening: timeTables
                                  .hours![DateTime.now().weekday - 1]
                                  .eveningHoursClose ??
                              "",
                        );
                }),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 16,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: HomeFeaturesListNewIcons(),
                ),
                const SizedBox(
                  height: 16,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: InkWell(
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         TitleText(
                //           height: null,
                //           text: translate(context, 'orders_reservation'),
                //           color: AppColors.darkGrey,
                //           fontWeight: FontWeight.w700,
                //           textAlign: TextAlign.left,
                //         ),
                //         GestureDetector(
                //           onTap: () {
                //             Navigator.of(context)
                //                 .pushNamed(MyOrdersScreen.routeName);
                //           },
                //           child: Row(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: [
                //               Text(translate(context, 'find_out')),
                //               const Icon(Icons.chevron_right),
                //             ],
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 16,
                // ),
                //const HomeStatsWidget(),
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 7,
                        child: TitleText(
                          text:
                              translate(context, 'promo_and_featured_products'),
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w700,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                ShowCaseProductsScreenPreview.routeName);
                          },
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  translate(
                                    context,
                                    'discover_them_all',
                                  ),
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const ProductListPromoAndShowCase(),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      ItemTileIconWithBackground(
                        title: translate(context, 'health_folder'),
                        text: translate(context, 'health_folder_description'),
                        image: Icons.monitor_heart,
                        color: const Color(0xFF5285F5),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(HealthFolder.routeName);
                        },
                      ),
                      if (flavor.sendReceiptEnabled && !flavor.isParapharmacy)
                        const SizedBox(height: 16),
                      if (flavor.sendReceiptEnabled && !flavor.isParapharmacy)
                        ItemTileIconWithBackground(
                          title: translate(context, 'submit_recipe'),
                          text: translate(
                              context,
                              ref.read(flavorProvider).isParapharmacy
                                  ? 'send_receipt_description_parapharmacy'
                                  : 'send_receipt_description_pharmacy'),
                          image: Icons.upload_file,
                          color: const Color(0xFFA087F7),
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                              ),
                              backgroundColor: Colors.white,
                              context: context,
                              builder: (BuildContext context) =>
                                  const PrescriptionBottomSheet(),
                            );
                          },
                        ),
                      if (flavor.hasConventions) const SizedBox(height: 16),
                      if (flavor.hasConventions)
                        ItemTileIconWithBackground(
                          title: translate(context, 'convention'),
                          text: translate(
                              context,
                              ref.read(flavorProvider).isParapharmacy
                                  ? 'events_conventions_description_parapharmacy'
                                  : 'events_conventions_description_pharmacy'),
                          image: Icons.handshake,
                          color: const Color(0xFFED7F5E),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(ConventionsScreen.routeName);
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> scanBarcode() async {
    String? barcodeScanRes;
    var isAuthorized = await PermissionConfig.getPermission();
    if (isAuthorized) {
      String initialRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      barcodeScanRes = pharma32Convert(initialRes);
      if (!mounted) return null;
    }
    return barcodeScanRes;
  }
}
