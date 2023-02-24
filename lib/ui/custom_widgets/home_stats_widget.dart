import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../models/flavor.dart';
import '../../theme/app_colors.dart';
import '../../translations/translate_string.dart';
import '../screens/orders/my_orders_screen.dart';
import '../screens/reservations/my_reservations_screen.dart';

class HomeStatsWidget extends ConsumerStatefulWidget {
  const HomeStatsWidget({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<HomeStatsWidget> createState() => _HomeStatsWidgetState();
}

class _HomeStatsWidgetState extends ConsumerState<HomeStatsWidget> {
  int? nReservations;
  int? nOrders;
  final ApisNew _apisNew = ApisNew();

  Future<void> getStats() async {
    final result = await _apisNew.getStats(
      {
        'user_id': ref.read(authProvider).user?.userId,
        'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      },
    );

    nReservations = result.data['appointments_count'];
    nOrders = result.data['orders_count'];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (ref.read(authProvider).user?.userId != null) {
      getStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC107).withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    translate(context, 'reservation_in_progress'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                        fontSize: 10.0.sp),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Text(
                      nReservations != null
                          ? nReservations.toString() +
                              ' ' +
                              translate(context, 'reservation')
                          : '0 ' + translate(context, 'reservation'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.0.sp),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(MyReservationsScreen.routeName);
                    },
                    child: Text(
                      translate(context, 'your_reservations'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 9.0.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFEE7D54).withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    translate(context, 'view_products'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                        fontSize: 10.0.sp),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Text(
                      nOrders != null
                          ? nOrders.toString() +
                              ' ' +
                              translate(context, 'no_order_box')
                          : '0 ' + translate(context, 'no_order_box'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.0.sp),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(MyOrdersScreen.routeName);
                    },
                    child: Text(
                      translate(context, 'your_orders'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 9.0.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
