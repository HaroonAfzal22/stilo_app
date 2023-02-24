import 'package:contacta_pharmacy/providers/app_provider.dart';
import 'package:contacta_pharmacy/providers/site_provider.dart';
import 'package:contacta_pharmacy/ui/screens/home_screen.dart';
import 'package:contacta_pharmacy/ui/screens/multisede/site_select_screen.dart';
import 'package:contacta_pharmacy/ui/screens/pharmacy_screen.dart';
import 'package:contacta_pharmacy/ui/screens/products/products_screen.dart';
import 'package:contacta_pharmacy/ui/screens/profile_screen.dart';
import 'package:contacta_pharmacy/ui/screens/services/services_screen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/flavor.dart';
import '../custom_widgets/custom_drawer.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const routeName = '/main-screen';

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final _appProvider = ref.watch(appProvider);

    return Scaffold(
      drawer: const CustomDrawer(),
      key: _key,
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.reactCircle,
        activeColor: ref.read(flavorProvider).lightPrimary,
        backgroundColor: Colors.white,
        initialActiveIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          TabItem(
            activeIcon: Image.asset(
              'assets/icons/ic_home.png',
              color: Colors.white,
              height: 20,
              scale: 18,
            ),
            icon: Image.asset('assets/icons/ic_home.png'),
          ),
          TabItem(
              icon: Image.asset(
                'assets/icons/ic_category.png',
                height: 21,
              ),
              activeIcon: Image.asset(
                'assets/icons/ic_category.png',
                color: Colors.white,
                height: 20,
                scale: 18,
              )),
          TabItem(
            icon: Image.asset(
              'assets/icons/ic_fav.png',
              height: 21,
            ),
            activeIcon: Image.asset(
              'assets/icons/ic_fav.png',
              color: Colors.white,
              height: 20,
              scale: 8,
            ),
          ),
          TabItem(
            icon: Image.asset('assets/icons/ic_healthFolder.png'),
            activeIcon: Image.asset(
              'assets/icons/ic_healthFolder.png',
              color: Colors.white,
              height: 20,
              scale: 18,
            ),
          ),
          TabItem(
              icon: Image.asset(
                'assets/icons/ic_profile.png',
                height: 21,
              ),
              activeIcon: Image.asset(
                'assets/icons/ic_profile.png',
                color: Colors.white,
                height: 20,
                scale: 4,
              )),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: const [
          HomeScreen(),
          ProductsScreen(),
          ServicesScreen(),
          PharmacyScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
