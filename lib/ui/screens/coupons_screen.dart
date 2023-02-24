import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../models/flavor.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme.dart';
import '../../translations/translate_string.dart';
import '../custom_widgets/no_data.dart';

class CouponsScreen extends ConsumerStatefulWidget {
  const CouponsScreen({Key? key}) : super(key: key);
  static const routeName = '/coupons-screen';

  @override
  ConsumerState<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends ConsumerState<CouponsScreen> {
  final ApisNew _apisNew = ApisNew();
  List<dynamic>? coupons;

  Future<void> getCouponsList() async {
    final result = await _apisNew.getCouponList({
      'user_id': ref.read(authProvider).user?.userId,
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
    });
    setState(() {
      coupons = result.data;
    });
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    if (user != null) {
      getCouponsList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(translate(context, 'coupanlist')),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (user == null)
                const NoUser()
              else if (coupons != null && coupons!.isNotEmpty)
                ListView.builder(
                    itemCount: coupons!.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          child: Card(
                            color: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: ref.read(flavorProvider).primary,
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        topRight: Radius.circular(0),
                                        bottomRight: Radius.circular(0)),
                                  ),

                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${coupons?[index]['discount'] ?? ""} ${coupons?[index]['type'] == "discount" ? "%" : "€"}",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.white),
                                          ),
                                          Text(
                                            translate(context, "off"),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // color: Colors.indigo,
                                  // padding: EdgeInsets.only(right: 20,left: 20),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 9,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: <InlineSpan>[
                                              TextSpan(
                                                text: 'Coupon: ',
                                                style: AppTheme.h6Style
                                                    .copyWith(
                                                        fontSize: 9.0.sp,
                                                        fontWeight:
                                                            FontWeight.w700),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${coupons?[index]['title'] ?? ""}',
                                                style: AppTheme.h6Style
                                                    .copyWith(
                                                        fontSize: 10.0.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          '${translate(context, "off")}: ${coupons?[index]['discount'] ?? ""} ${coupons?[index]['type'] == "discount" ? "%" : "€"}',
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTheme.bodyText
                                              .copyWith(fontSize: 10.0.sp),
                                          maxLines: 5,
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Text(
                                              '${coupons?[index]['remaining_period'] ?? ""} ${translate(context, "days_remaining")}',
                                              style: AppTheme.bodyText
                                                  .copyWith(fontSize: 10.0.sp)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
              else if (coupons != null && coupons!.isEmpty)
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2 - 100),
                  child: NoData(
                    text: translate(context, 'No_Coupans'),
                  ),
                )
              else
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2 - 100),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ref.read(flavorProvider).lightPrimary,
                    ),
                  ),
                )
            ],
          ),
        ));
  }
}
