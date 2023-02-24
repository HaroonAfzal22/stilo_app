import 'package:contacta_pharmacy/providers/site_provider.dart';
import 'package:contacta_pharmacy/ui/screens/documents/saved_documents_screen.dart';
import 'package:contacta_pharmacy/ui/screens/login/pre_login_screen.dart';
import 'package:contacta_pharmacy/ui/screens/multisede/site_select_screen.dart';
import 'package:contacta_pharmacy/ui/screens/orders/my_orders_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/saved_products_screen.dart';
import 'package:contacta_pharmacy/ui/screens/reservations/my_reservations_screen.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_edit_profile.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/flavor.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../translations/translate_string.dart';
import '../screens/sent_to_pharmacy/sent_to_pharmacy_screen.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
        ),
      ),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
        children: [
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  backgroundColor: ref.read(flavorProvider).lightPrimary,
                  radius: 32,
                  child: const Icon(
                    Icons.person,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.firstName ?? 'Ospite',
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(user?.email ?? ''),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          DrawerItem(
            title: translate(context, 'my_account'),
            imgUrl: 'assets/icons/ic_user.png',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(SettingsEditProfile.routeName);
            },
          ),
          DrawerItem(
            title: translate(context, 'my_order'),
            imgUrl: 'assets/icons/ic_order.png',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(MyOrdersScreen.routeName);
            },
          ),
          DrawerItem(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(MyReservationsScreen.routeName);
              },
              imgUrl: 'assets/icons/ic_reservation.png',
              title: translate(context, 'reservation')),
          /*       DrawerItem(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(MyRentalsScreen.routeName);
            },
            title: translate(context, 'my_rentals'),
            imgUrl: 'assets/icons/ic_rental.png',
          ),*/
          DrawerItem(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(SavedDocumentsScreen.routeName);
              },
              imgUrl: 'assets/icons/ic_document.png',
              title: translate(context, 'document')),
          DrawerItem(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(SentToPharmacyScreen.routeName);
            },
            imgUrl: 'assets/icons/ic_document.png',
            title: translate(
                context,
                ref.read(flavorProvider).isParapharmacy
                    ? 'sent_to_parapharmacy'
                    : 'sent_to_pharmacy'),
          ),
          DrawerItem(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(SavedProductsScreen.routeName);
              },
              imgUrl: 'assets/icons/ic_wishlist.png',
              title: translate(context, 'wishlist')),
          DrawerItem(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(SettingsScreen.routeName);
              },
              imgUrl: 'assets/icons/primary_setting.png',
              title: translate(context, 'settings')),
          if (ref.read(sitesProvider).length > 1)
            DrawerItem2(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(SiteSelectScreen.routeName);
                },
                icon: Icons.place,
                title: "Seleziona Sede"),
          if (user != null)
            DrawerItem(
                onTap: () {
                  ref.read(authProvider).logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      PreLoginScreen.routeName, (route) => false);
                },
                imgUrl: 'assets/icons/primary_logout.png',
                title: translate(context, 'Logout'))
        ],
      ),
    );
  }
}

class DrawerItem extends ConsumerWidget {
  const DrawerItem({
    Key? key,
    required this.onTap,
    required this.imgUrl,
    required this.title,
  }) : super(key: key);

  final VoidCallback onTap;
  final String imgUrl;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  imgUrl,
                  width: 20,
                  height: 20,
                  color: ref.read(flavorProvider).lightPrimary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.darkGrey),
                ),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            const Divider(),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem2 extends ConsumerWidget {
  const DrawerItem2({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final VoidCallback onTap;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: ref.read(flavorProvider).lightPrimary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.darkGrey),
                ),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            const Divider(),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
