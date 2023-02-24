import 'package:contacta_pharmacy/ui/screens/reservations/my_reservations_canceled_tab.dart';
import 'package:contacta_pharmacy/ui/screens/reservations/my_reservations_complete_tab.dart';
import 'package:contacta_pharmacy/ui/screens/reservations/my_reservations_pending_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';

class MyReservationsScreen extends ConsumerStatefulWidget {
  const MyReservationsScreen({Key? key}) : super(key: key);
  static const routeName = '/my-reservations-screen';

  @override
  _MyReservationsScreenState createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends ConsumerState<MyReservationsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            translate(context, 'reservation'),
          ),
          bottom: TabBar(
            padding: EdgeInsets.symmetric(vertical: 4),
            labelPadding: EdgeInsets.symmetric(vertical: 8),
            labelColor: ref.read(flavorProvider).primary,
            unselectedLabelColor: AppColors.darkGrey,
            indicatorColor: ref.read(flavorProvider).primary,
            tabs: [
              Text(translate(context, 'Waiting')),
              Text(translate(context, 'Completed')),
              Text(translate(context, 'Canceled')),
            ],
          ),
          /*      bottom: const TabBar(
            labelPadding: EdgeInsets.symmetric(vertical: 8),
            labelColor: ref.read(flavorProvider).primary,
            unselectedLabelColor: AppColors.darkGrey,
            indicatorColor: ref.read(flavorProvider).primary,
            tabs: [
              Text('In attesa'),
              Text('Completato'),
              Text('Annullato'),
            ],
          ),*/
        ),
        body: const TabBarView(
          children: [
            MyReservationsPendingTab(),
            MyReservationsCompleteTab(),
            MyReservationsCanceled(),
          ],
        ),
      ),
    );
  }
}
