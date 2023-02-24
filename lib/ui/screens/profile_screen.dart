import 'package:contacta_pharmacy/ui/custom_widgets/badge_notification.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/icon_standard/standard_icon.dart';
import 'package:contacta_pharmacy/ui/screens/available_pills.dart';
import 'package:contacta_pharmacy/ui/screens/coupons_screen.dart';
import 'package:contacta_pharmacy/ui/screens/documents/saved_documents_screen.dart';
import 'package:contacta_pharmacy/ui/screens/health_folder/health_folder.dart';
import 'package:contacta_pharmacy/ui/screens/medcab/med_cab_screen.dart';
import 'package:contacta_pharmacy/ui/screens/notifications/notifications_screen.dart';
import 'package:contacta_pharmacy/ui/screens/orders/my_orders_screen.dart';
import 'package:contacta_pharmacy/ui/screens/prescriptions/prescriptions_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/saved_products_screen.dart';
import 'package:contacta_pharmacy/ui/screens/reservations/my_reservations_screen.dart';
import 'package:contacta_pharmacy/ui/screens/therapies/therapies_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../config/constant.dart';
import '../../models/flavor.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme.dart';
import '../../translations/translate_string.dart';
import '../custom_widgets/home_item.dart';
import '../custom_widgets/title_text.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    return Scaffold(
      appBar: AppBar(
        //TODO tradurre ciao
        title: Text(
          user != null ? 'Ciao ${user.firstName}' : translate(context, 'guest'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: ref.read(flavorProvider).lightPrimary,
        centerTitle: true,
        actions: [
          InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(NotificationsScreen.routeName);
              },
              child: BadgeNotifications(
                iconColor: Colors.white,
                badgeColor: ref.read(flavorProvider).primary,
              )),
          const SizedBox(
            width: 16,
          ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: 20,
                    child: Icon(
                      Icons.person,
                      size: 20,
                      color: ref.read(flavorProvider).lightPrimary,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  user?.firstName ?? 'Ospite',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),

      /* AppBar(
        backgroundColor: ref.read(flavorProvider).lightPrimary,
        toolbarHeight: 120,
        leadingWidth: 120,
        actions: [
          Center(
            child: Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
                const Positioned(
                  left: 12,
                  top: 12,
                  child: Icon(
                    Icons.qr_code,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 12,
          ),
        ],
        leading: Row(
          children: const [
            SizedBox(
              width: 8,
            ),
            CircleAvatar(
              radius: 20,
            ),
            SizedBox(
              width: 8,
            ),
            Text('Ospite'),
          ],
        ),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),*/
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 32,
              ),
              ItemTileIconWithBackground(
                title: translate(context, 'My_orders'),
                text: translate(context, 'My_orders_des'),
                image: Icons.shopping_basket,
                color: const Color(0xFF15A6C9),
                onTap: () {
                  Navigator.of(context).pushNamed(MyOrdersScreen.routeName);
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ItemTileIconWithBackground(
                title: translate(context, 'My_reservations'),
                text: translate(context, 'My_reservations_des'),
                image: Icons.bookmark_added,
                color: const Color(0xFFF4B961),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(MyReservationsScreen.routeName);
                },
              ),
              const SizedBox(
                height: 8,
              ),
              /*        ItemTileIconWithBackground(
                title: translate(context, 'todays_therapies'),
                text: translate(context, 'todays_therapies_des'),
                image: Icons.medication,
                color: const Color(0xFFA087F7),
                onTap: () {
                  Navigator.of(context).pushNamed(TherapiesScreen.routeName);
                },
              ),
              const SizedBox(
                height: 8,
              ),*/
              ItemTileIconWithBackground(
                title: translate(context, 'Pads_running_out'),
                text: translate(context, 'Pads_running_out_des'),
                image: Icons.list_alt,
                color: const Color(0xFFEF805E),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AvailablePillsScreen.routeName);
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TitleText(
                    text: translate(context, 'For_your_health'),
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.left,
                    height: null,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        builder: (BuildContext context) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 24),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.info,
                                    size: 28,
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    translate(context, 'health_section'),
                                    style: AppTheme.h5Style
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                translate(context, 'health_section_details'),
                                style: AppTheme.h6Style.copyWith(
                                    fontSize: 10.0.sp, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.info,
                      color: Colors.blueGrey,
                      size: 24,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(TherapiesScreen.routeName);
                      },
                      child: Column(
                        children: [
                          const IconStandard(
                              icon: Icons.medication,
                              backgroundColor: AppColors.purple),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            translate(context, 'Therapies'),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(MedCabScreen.routeName);
                      },
                      child: Column(
                        children: const [
                          IconStandard(
                              icon: Icons.medical_services_outlined,
                              backgroundColor: Colors.deepOrangeAccent),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'MedCab',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(HealthFolder.routeName);
                      },
                      child: Column(
                        children: [
                          const IconStandard(
                              icon: Icons.health_and_safety,
                              backgroundColor: Colors.blue),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            translate(context, 'Health'),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              TitleText(
                text: translate(context, 'Your_info'),
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(SavedDocumentsScreen.routeName);
                      },
                      child: Column(
                        children: [
                          const IconStandard(
                            backgroundColor: AppColors.lightBlue,
                            icon: Icons.description,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            translate(context, 'view_documents'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (Constant.isCouponActive == true)
                    const SizedBox(
                      width: 20,
                    ),
                  if (Constant.isCouponActive == true)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(CouponsScreen.routeName);
                        },
                        child: Column(
                          children: [
                            const IconStandard(
                              backgroundColor: AppColors.lightBlue,
                              icon: Icons.redeem,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              translate(context, 'go_to_your_coupon'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (ref.read(flavorProvider).sendReceiptEnabled &&
                      !ref.read(flavorProvider).isParapharmacy)
                    const SizedBox(
                      width: 20,
                    ),
                  if (ref.read(flavorProvider).sendReceiptEnabled &&
                      !ref.read(flavorProvider).isParapharmacy)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(PrescriptionScreen.routeName);
                        },
                        child: Column(
                          children: [
                            IconStandard(
                              backgroundColor:
                                  AppColors.purple.withOpacity(0.85),
                              icon: Icons.upload_file,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              translate(context, 'go_to_saved_prescriptions'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(SavedProductsScreen.routeName);
                      },
                      child: Column(
                        children: [
                          const IconStandard(
                            backgroundColor: Colors.deepOrangeAccent,
                            icon: Icons.favorite,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            translate(context, 'product_list_save_yourself'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!ref.read(flavorProvider).sendReceiptEnabled ||
                      ref.read(flavorProvider).isParapharmacy)
                    const SizedBox(width: 20),
                  if (!ref.read(flavorProvider).sendReceiptEnabled ||
                      ref.read(flavorProvider).isParapharmacy)
                    const Spacer(),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SingleInfoItem extends StatelessWidget {
  const SingleInfoItem(
      {Key? key,
      required this.onTap,
      required this.imgUrl,
      required this.title})
      : super(key: key);

  final VoidCallback onTap;
  final String imgUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Image.asset(imgUrl),
            const SizedBox(
              height: 4,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
