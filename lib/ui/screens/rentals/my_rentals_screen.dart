import 'package:contacta_pharmacy/ui/screens/rentals/my_rentals_active_tab.dart';
import 'package:contacta_pharmacy/ui/screens/rentals/my_rentals_finished_tab.dart';
import 'package:contacta_pharmacy/ui/screens/rentals/my_rentals_others_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';

class MyRentalsScreen extends ConsumerStatefulWidget {
  const MyRentalsScreen({Key? key}) : super(key: key);
  static const routeName = '/my-rentals-screen';

  @override
  _MyRentalsScreenState createState() => _MyRentalsScreenState();
}

class _MyRentalsScreenState extends ConsumerState<MyRentalsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            translate(context, 'my_rentals'),
          ),
          bottom: TabBar(
            labelPadding: const EdgeInsets.symmetric(vertical: 8),
            labelColor: ref.read(flavorProvider).primary,
            unselectedLabelColor: AppColors.darkGrey,
            indicatorColor: ref.read(flavorProvider).primary,
            tabs: [
              Text(
                translate(context, 'Active'),
              ),
              Text(
                translate(context, 'finished'),
              ),
              Text(
                translate(context, 'Other'),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyRentalsActiveTab(),
            MyRentalsFinishedTab(),
            MyRentalsOthersTab(),
          ],
        ),
      ),
    );
  }
}
