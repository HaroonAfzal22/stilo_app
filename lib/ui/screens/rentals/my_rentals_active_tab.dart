import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/rental.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/rentals/rental_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../custom_widgets/no_user.dart';

class MyRentalsActiveTab extends ConsumerStatefulWidget {
  const MyRentalsActiveTab({Key? key}) : super(key: key);

  @override
  ConsumerState<MyRentalsActiveTab> createState() => _MyRentalsActiveTabState();
}

class _MyRentalsActiveTabState extends ConsumerState<MyRentalsActiveTab> {
  final ApisNew _apisNew = ApisNew();
  List<Rental>? rental;

  Future<void> getRental() async {
    final response = await _apisNew.getRentalList({
      'user_id': 29,
      //TODO controlla stati
      'status': "active",
    });
    rental = [];
    for (var orderItem in response.data) {
      rental!.add(Rental.fromJson(orderItem));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      if (user != null) {
        getRental();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.grey[100],
      child: SingleChildScrollView(
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              Column(
                children: [
                  if (rental != null)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: rental!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => RentalTile(
                        isOpened: index == 0 ? true : false,
                        type: 'active',
                        rental: rental![index],
                      ),
                    )
                  else if (user == null)
                    const NoUser()
                  else if (user != null && rental != null && rental!.isEmpty)
                    NoData(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 2 - 100),
                      text: translate(
                          context,
                          ref.read(flavorProvider).isParapharmacy
                              ? "No_Rental_Product_parapharmacy"
                              : "No_Rental_Product_pharmacy"),
                    )
                  else
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
            ],
          ),
        ),
      ),
    );
  }
}
