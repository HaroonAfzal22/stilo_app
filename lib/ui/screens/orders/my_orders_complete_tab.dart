import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/order.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/orders/order_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../custom_widgets/no_user.dart';

class MyOrdersCompleteTab extends ConsumerStatefulWidget {
  const MyOrdersCompleteTab({Key? key}) : super(key: key);

  @override
  ConsumerState<MyOrdersCompleteTab> createState() =>
      _MyOrdersCompleteTabState();
}

class _MyOrdersCompleteTabState extends ConsumerState<MyOrdersCompleteTab> {
  final ApisNew _apisNew = ApisNew();
  List<Order>? orders;

  Future<void> getOrders() async {
    final response = await _apisNew.getOrders({
      'user_id': ref.read(authProvider).user!.userId,
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      'type': "completed",
    });
    orders = [];
    for (var orderItem in response.data) {
      orders!.add(Order.fromJson(orderItem));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      final user = ref.read(authProvider).user;
      if (user != null) {
        await getOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(authProvider).user;
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            if (orders != null && orders!.isNotEmpty)
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 24,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                itemCount: orders!.length,
                itemBuilder: (context, index) => OrderTile(
                  order: orders![index],
                  defaultOpened: index == 0 ? true : false,
                ),
              )
            else if (user == null)
              const NoUser()
            else if (user != null && orders != null && orders!.isEmpty)
              NoData(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2 - 100),
                  text: translate(context, "No_Order"))
            else
              //TODO full heaight - barra superiore
              SizedBox(
                height: MediaQuery.of(context).size.height - 180,
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
