import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../custom_widgets/no_user.dart';
import '../../custom_widgets/reservations/reservation_tile.dart';

class MyReservationsPendingTab extends ConsumerStatefulWidget {
  const MyReservationsPendingTab({Key? key}) : super(key: key);

  @override
  ConsumerState<MyReservationsPendingTab> createState() =>
      _MyReservationsPendingTabState();
}

class _MyReservationsPendingTabState
    extends ConsumerState<MyReservationsPendingTab> {
  List<dynamic>? reservations;
  final ApisNew _apisNew = ApisNew();

  Future<void> getReservations() async {
    final response = await _apisNew.getReservations({
      'user_id': ref.read(authProvider).user!.userId,
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      'type': 'waiting',
    });

    setState(() {
      reservations = response.data;
    });
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    if (user != null) {
      getReservations();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    return Container(
      color: Colors.grey[100],
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            if (reservations != null && reservations!.isNotEmpty)
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 24,
                ),
                itemCount: reservations!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => ReservationTile(
                    reservations![index],
                    index == 0,
                    reservations![index]['service'] == null),
              )
            else if (user == null)
              const NoUser()
            else if (user != null &&
                reservations != null &&
                reservations!.isEmpty)
              NoData(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2 - 100),
                  text: translate(context, "No_Reservation_present"))
            else
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2 - 150),
                child: Center(
                  child: CircularProgressIndicator(
                    color: ref.read(flavorProvider).lightPrimary,
                  ),
                ),
              ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
