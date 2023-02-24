import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/order.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/theme/app_colors.dart';
import 'package:contacta_pharmacy/theme/theme.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({
    Key? key,
  }) : super(key: key);
  static const routeName = '/order-detail-screen';

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  Order? order;
  int? fromRouteID;
  dynamic id;
  final ApisNew _apisNew = ApisNew();

  Future<void> getOrderById() async {
    final result = await _apisNew.getOrderById({
      "order_id": fromRouteID,
      "user_id": ref.read(authProvider).user?.userId,
      "pharmacy_id": ref.read(flavorProvider).pharmacyId,
    });
    if (result != null) {
      setState(() {
        order = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (ref.read(authProvider).user != null) {
        fromRouteID =
            int.tryParse(ModalRoute.of(context)!.settings.arguments.toString());
        getOrderById();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(authProvider).user;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          translate(context, 'order_details'),
        ),
      ),
      body: user == null
          ? const NoUser()
          : order != null && user != null
              ? Column(children: [
                  //TODO fixare dopo
/*
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 15),
          child: Row(
            children: [
              Container(
                width: 50.0.w,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.blueColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
                  child: Center(
                    child: Text(
                      order?.status ?? '-',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.0.sp,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
*/
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 15),
                    child: Row(
                      children: [
                        Text(translate(context, "Ordine_del"),
                            style: AppTheme.h6Style.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 11.0.sp)),
                        const SizedBox(
                          width: 5,
                        ),
                        if (order?.date != null)
                          Text(
                            DateFormat("EEEE, dd MMMM yyyy", "it").format(
                                DateFormat("yyyy-MM-dd hh:mm:ss")
                                    .parse(order?.date ?? '')),
                            style: AppTheme.h5Style.copyWith(
                                fontSize: 11.0.sp, fontWeight: FontWeight.bold),
                          ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: [
                        Text(translate(context, "order_no"),
                            style: AppTheme.bodyText),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(order?.id.toString() ?? '-',
                            style: AppTheme.bodyText),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (order?.products != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: [
                          Text(order!.products!.length.toString(),
                              style: AppTheme.h3Style.copyWith(
                                  fontSize: 10.0.sp,
                                  color: AppColors.darkGrey.withOpacity(.7),
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            translate(context, "element"),
                            style: AppTheme.h3Style.copyWith(
                                fontSize: 10.0.sp,
                                color: AppColors.darkGrey.withOpacity(.7),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 15),
                  if (order != null && order?.products != null)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            (ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: order!.products!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        padding: const EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              offset: const Offset(0,
                                                  4), // changes position of shadow
                                            ),
                                          ],
                                          color: AppColors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            if (order!.products![index]
                                                .productImage!.isNotEmpty)
                                              SizedBox(
                                                  height: 100,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.35,
                                                  child: CachedNetworkImage(
                                                    imageUrl: order!
                                                        .products![index]
                                                        .productImage![0]
                                                        .productImage!,
                                                    errorWidget:
                                                        (context, url, error) {
                                                      return Image.asset(
                                                          "assets/images/noImage.png");
                                                    },
                                                    // "assets/images/noImage.png"),
                                                  ))
                                            else
                                              SizedBox(
                                                height: 100,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.35,
                                                child: Image.asset(
                                                    "assets/images/noImage.png"),
                                              ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              flex: 7,
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    right: 0,
                                                    left: 0,
                                                    bottom: 15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.59,
                                                      child: Text(
                                                        order!.products![index]
                                                            .productName!,
                                                        style: AppTheme.h6Style
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: AppColors
                                                                    .black,
                                                                fontSize:
                                                                    12.0.sp),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Quantità",
                                                                style: AppTheme.h6Style.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                            .grey[
                                                                        500],
                                                                    fontSize:
                                                                        9.0.sp),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                order!
                                                                    .products![
                                                                        index]
                                                                    .qty
                                                                    .toString(),
                                                                style: AppTheme.h6Style.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: AppColors
                                                                        .lightGrey,
                                                                    fontSize:
                                                                        11.0.sp),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(children: [
                                                            Text(
                                                              NumberFormat.currency(
                                                                      locale:
                                                                          'it_IT',
                                                                      symbol:
                                                                          '€')
                                                                  .format(order!
                                                                      .products![
                                                                          index]
                                                                      .price),
                                                              style: AppTheme.h6Style.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: AppColors
                                                                      .lightGrey,
                                                                  fontSize:
                                                                      11.0.sp),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            )
                                                          ])
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  );
                                })),
                            const SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(translate(context, "order_info"),
                                      style: AppTheme.h6Style.copyWith(
                                          fontWeight: FontWeight.w600))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                child: Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(4),
                                    1: FlexColumnWidth(6),
                                  },
                                  children: [
                                    /*       TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  order!.shipmentAddress != null
                                      ? Text(translate(context, "Shipment:"),
                                          style: AppTheme.bodyText.copyWith(
                                              color: AppColors.lightGrey
                                                  .withOpacity(0.7),
                                              fontWeight: FontWeight.w600))
                                      : const SizedBox(),
                                ]),
                          ),
                          order!.shipmentAddress != null
                              ? Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(order!.shipmentAddress.toString(),
                                            //"indirizzo",
                                            style: AppTheme.bodyText.copyWith(
                                                color: AppColors.black))
                                      ]),
                                )
                              : const SizedBox(),
                        ]),
                        TableRow(children: [
                          order!.payment != null
                              ? Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(translate(context, "Payment:"),
                                      style: AppTheme.bodyText.copyWith(
                                          color: AppColors.lightGrey
                                              .withOpacity(0.7),
                                          fontWeight: FontWeight.w600)),
                                )
                              : const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                order!.payment != null
                                    ? Text(order!.payment.toString(),

                                        //"${translate(context, "Card")}",
                                        style: AppTheme.h6Style
                                            .copyWith(color: AppColors.black))
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  order!.shippingType != null
                                      ? Text(
                                          translate(context, "Shipping_Type:"),
                                          style: AppTheme.bodyText.copyWith(
                                              color: AppColors.lightGrey
                                                  .withOpacity(0.7),
                                              fontWeight: FontWeight.w600))
                                      : const SizedBox(),
                                ]),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    order!.shippingType != null
                                        ? Text(
                                            order!.shippingType.toString(),
                                            style: AppTheme.bodyText.copyWith(
                                                color: AppColors.black),
                                          )
                                        : const SizedBox(),
                                  ])),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  order!.couponId != null
                                      ? Text(translate(context, "Coupon:"),
                                          style: AppTheme.bodyText.copyWith(
                                              color: AppColors.lightGrey
                                                  .withOpacity(0.7),
                                              fontWeight: FontWeight.w600))
                                      : const SizedBox(),
                                ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  order!.couponId != null
                                      ? Text(
                                          //todo vedi prezzo scontato da coupon
                                          "2.99 copupon",
                                          style: AppTheme.bodyText
                                              .copyWith(color: AppColors.black),
                                        )
                                      : const SizedBox(),
                                ]),
                          )
                        ]),*/
                                    TableRow(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              order!.tax != null
                                                  ? Text(
                                                      "${translate(context, "iva")} :",
                                                      style: AppTheme.bodyText
                                                          .copyWith(
                                                              color: AppColors
                                                                  .lightGrey
                                                                  .withOpacity(
                                                                      0.7),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600))
                                                  : const SizedBox(),
                                            ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              order!.tax != null
                                                  ? Text(
                                                      NumberFormat.currency(
                                                              locale: 'it_IT',
                                                              symbol: '€')
                                                          .format(double.parse(
                                                              order!.tax ??
                                                                  '')),
                                                      style: AppTheme.bodyText
                                                          .copyWith(
                                                              color: AppColors
                                                                  .black),
                                                    )
                                                  : const SizedBox()
                                            ]),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              order?.subTotal != null
                                                  ? Text(
                                                      translate(
                                                          context, "Total:"),
                                                      style: AppTheme.bodyText
                                                          .copyWith(
                                                              color: AppColors
                                                                  .lightGrey
                                                                  .withOpacity(
                                                                      0.7),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600))
                                                  : const SizedBox(),
                                            ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              order?.subTotal != null
                                                  ? Text(
                                                      NumberFormat.currency(
                                                              locale: 'it_IT',
                                                              symbol: '€')
                                                          .format(
                                                        double.parse(
                                                            order?.subTotal ??
                                                                ''),
                                                      ),
                                                      style: AppTheme.bodyText
                                                          .copyWith(
                                                              color: AppColors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600))
                                                  : const SizedBox(),
                                            ]),
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                            //TODO riattivare???
                            /*  Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _button(),
                )*/
                          ],
                        ),
                      ),
                    ),
                ])
              : Center(
                  child: CircularProgressIndicator(
                    color: ref.read(flavorProvider).lightPrimary,
                  ),
                ),
    );
  }

  Widget _button() {
    return Container(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 60, right: 60),
        decoration: BoxDecoration(
          border: Border.all(color: ref.read(flavorProvider).primary, width: 1),
          borderRadius: const BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Text(
          "Riordina",
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              color: ref.read(flavorProvider).primary),
        ));
  }
}
