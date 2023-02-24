import 'package:contacta_pharmacy/ui/screens/orders/my_orders_canceled_tab.dart';
import 'package:contacta_pharmacy/ui/screens/orders/my_orders_complete_tab.dart';
import 'package:contacta_pharmacy/ui/screens/orders/my_orders_pending_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';

class MyOrdersScreen extends ConsumerStatefulWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/my-orders-screen';

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends ConsumerState<MyOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          title: Text(
            translate(context, 'my_order'),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelPadding: const EdgeInsets.symmetric(vertical: 8),
            labelColor: ref.read(flavorProvider).primary,
            unselectedLabelColor: AppColors.darkGrey,
            indicatorColor: ref.read(flavorProvider).primary,
            tabs: [
              Text(
                translate(context, 'Processing'),
              ),
              Text(
                translate(context, 'Completed'),
              ),
              Text(
                translate(context, 'Canceled'),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyOrdersPendingTab(),
            MyOrdersCompleteTab(),
            MyOrdersCanceled(),
          ],
        ),
      ),
    );
  }
}
