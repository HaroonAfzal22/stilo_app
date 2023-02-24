import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/models/rental.dart';
import 'package:contacta_pharmacy/theme/app_colors.dart';
import 'package:contacta_pharmacy/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';

class RentalDetailScreen extends ConsumerStatefulWidget {
  const RentalDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/rental-detail-screen';

  @override
  _RentalDetailScreenState createState() => _RentalDetailScreenState();
}

class _RentalDetailScreenState extends ConsumerState<RentalDetailScreen> {
  Rental? rental;

  @override
  Widget build(BuildContext context) {
    rental = ModalRoute.of(context)!.settings.arguments as Rental;
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
      body: Column(children: [
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
                      "in attesa",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.0.sp,
                          fontWeight: FontWeight.normal),
                    ),
                    // child: status != null
                    //     ? Text(
                    //         "${status.capitalize()}",
                    //         textAlign: TextAlign.center,
                    //         style: TextStyle(
                    //             color: Colors.white,
                    //             fontSize: 11.0.sp,
                    //             fontWeight: FontWeight.normal),
                    //       )
                    //     : SizedBox()),
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
              Text(
                  "${translate(context, 'rental')} ${translate(context, 'from')}",
                  style: AppTheme.h6Style.copyWith(
                      fontWeight: FontWeight.w600, fontSize: 11.0.sp)),
              const SizedBox(
                width: 5,
              ),
              Text(
                  rental?.startDate != null
                      ? DateFormat("EEEE, dd MMMM yyyy", "it").format(
                          DateFormat("yyyy-MM-dd hh:mm:ss")
                              .parse(rental!.startDate!))
                      : '--/--',
                  style: AppTheme.h5Style.copyWith(
                      fontSize: 11.0.sp, fontWeight: FontWeight.bold)),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15),
          child: Row(
            children: [
              //TODO translate
              Text("Finisce",
                  style: AppTheme.h6Style.copyWith(
                      fontWeight: FontWeight.w600, fontSize: 11.0.sp)),
              const SizedBox(
                width: 5,
              ),
              Text(
                  rental?.endDate != null
                      ? DateFormat("EEEE, dd MMMM yyyy", "it").format(
                          DateFormat("yyyy-MM-dd hh:mm:ss")
                              .parse(rental!.endDate!))
                      : "--/--",
                  style: AppTheme.h5Style.copyWith(
                      fontSize: 11.0.sp, fontWeight: FontWeight.bold)),
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
              Text(translate(context, "order_no"), style: AppTheme.bodyText),
              const SizedBox(
                width: 3,
              ),
              Text(rental!.id.toString(), style: AppTheme.bodyText),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 15.0),
        //   child: Row(
        //     children: [
        //       Text(

        //           "numbers of elements",
        //           style: AppTheme.h3Style.copyWith(
        //               fontSize: 10.0.sp,
        //               color: AppColors.darkGrey.withOpacity(.7),
        //               fontWeight: FontWeight.bold)),
        //       const SizedBox(
        //         width: 5,
        //       ),
        //       Text(
        //         "order!.products!.length", // >= 2
        //         // ? translate(context, "elements")
        //         // : translate(context, "element"),
        //         style: AppTheme.h3Style.copyWith(
        //             fontSize: 10.0.sp,
        //             color: AppColors.darkGrey.withOpacity(.7),
        //             fontWeight: FontWeight.bold),
        //       ),
        //     ],
        //   ),
        // ),
        const SizedBox(height: 15),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                (
                    //TODO FIX
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 1, //order!.products!.length,
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
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(
                                          0, 4), // changes position of shadow
                                    ),
                                  ],
                                  color: AppColors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      child: CachedNetworkImage(
                                          imageUrl:
                                              // order!.products![index]
                                              //     ['product_image'][0]['product_image'],
                                              "assets/images/noImage.png"),
                                      //       )
                                    ),
                                    const SizedBox(
                                      width: 05,
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            right: 0, left: 0, bottom: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.59,
                                              child: Text(
                                                //'Sugar Free Gold Sweetener',
                                                //widget.itemname,
                                                // order!.products![index]
                                                //         ['product_name']
                                                //     .toString(),
                                                rental!.name!,
                                                style: AppTheme.h6Style
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors.black,
                                                        fontSize: 12.0.sp),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // Row(
                                                  //   children: [
                                                  //     Text(
                                                  //       "Quantity",
                                                  //       style: AppTheme.h6Style
                                                  //           .copyWith(
                                                  //               fontWeight:
                                                  //                   FontWeight.w500,
                                                  //               color: Colors
                                                  //                   .grey[500],
                                                  //               fontSize: 9.0.sp),
                                                  //     ),
                                                  //     const SizedBox(
                                                  //       width: 5,
                                                  //     ),
                                                  //     Text(
                                                  //       order!.products![index].

                                                  //           .toString(),
                                                  //       style: AppTheme.h6Style
                                                  //           .copyWith(
                                                  //               fontWeight:
                                                  //                   FontWeight.w600,
                                                  //               color: AppColors
                                                  //                   .lightGrey,
                                                  //               fontSize: 11.0.sp),
                                                  //     ),
                                                  //   ],
                                                  // ),

                                                  Row(children: [
                                                    Text(
                                                      // " ${order!.products![index]['price'].toString()} €",
                                                      // style: TextStyle(fontSize: 11,color: AppColors.notify_set_text,fontWeight: FontWeight.w500,fontFamily: 'Poppins')
                                                      rental!.price.toString(),
                                                      style: AppTheme.h6Style
                                                          .copyWith(
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
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(translate(context, "order_info"),
                          style: AppTheme.h6Style
                              .copyWith(fontWeight: FontWeight.w600))
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
                        // TableRow(children: [
                        //   Padding(
                        //     padding: const EdgeInsets.all(6.0),
                        //     child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //          // order!.shipmentAddress != null
                        //          rental!.id != null
                        //               ? Text(translate(context, "Shipment:"),
                        //                   style: AppTheme.bodyText.copyWith(
                        //                       color: AppColors.lightGrey
                        //                           .withOpacity(0.7),
                        //                       fontWeight: FontWeight.w600))
                        //               : const SizedBox(),
                        //         ]),
                        //   ),
                        //   rental!.shipmentAddress != null
                        //       ? Padding(
                        //           padding: const EdgeInsets.all(6.0),
                        //           child: Column(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.start,
                        //               children: [
                        //                 Text(
                        //                   //rental['shipmentAddress'].toString(),
                        //                     "indirizzo",
                        //                     style: AppTheme.bodyText.copyWith(
                        //                         color: AppColors.black))
                        //               ]),
                        //         )
                        //       : const SizedBox(),
                        // ]),
                        // TableRow(children: [
                        //   rental!.payment != null
                        //       ? Padding(
                        //           padding: const EdgeInsets.all(6.0),
                        //           child: Text(translate(context, "Payment:"),
                        //               style: AppTheme.bodyText.copyWith(
                        //                   color: AppColors.lightGrey
                        //                       .withOpacity(0.7),
                        //                   fontWeight: FontWeight.w600)),
                        //         )
                        //       : const SizedBox(),
                        //   Padding(
                        //     padding: const EdgeInsets.all(6.0),
                        //     child: Row(
                        //       children: [
                        //         rental!.payment != null
                        //             ? Text(rental!.payment.toString(),

                        //                 //"${translate(context, "Card")}",
                        //                 style: AppTheme.h6Style
                        //                     .copyWith(color: AppColors.black))
                        //             : const SizedBox(),
                        //       ],
                        //     ),
                        //   ),
                        // ]),
                        // TableRow(children: [
                        //   Padding(
                        //     padding: const EdgeInsets.all(6.0),
                        //     child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           rental!.shippingType != null
                        //               ? Text(
                        //                   translate(context, "Shipping_Type:"),
                        //                   style: AppTheme.bodyText.copyWith(
                        //                       color: AppColors.lightGrey
                        //                           .withOpacity(0.7),
                        //                       fontWeight: FontWeight.w600))
                        //               : const SizedBox(),
                        //         ]),
                        //   ),
                        //   Padding(
                        //       padding: const EdgeInsets.all(6.0),
                        //       child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             rental['shippingType'] != null
                        //                 ? Text(
                        //                     rental['shippingType'].toString(),
                        //                     style: AppTheme.bodyText.copyWith(
                        //                         color: AppColors.black),
                        //                   )
                        //                 : const SizedBox(),
                        //           ])),
                        // ]),
                        // TableRow(children: [
                        //   Padding(
                        //     padding: const EdgeInsets.all(6.0),
                        //     child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           rental['couponId'] != null
                        //               ? Text(translate(context, "Coupon:"),
                        //                   style: AppTheme.bodyText.copyWith(
                        //                       color: AppColors.lightGrey
                        //                           .withOpacity(0.7),
                        //                       fontWeight: FontWeight.w600))
                        //               : const SizedBox(),
                        //         ]),
                        //   ),
                        //   Padding(
                        //     padding: const EdgeInsets.all(6.0),
                        //     child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           rental != null
                        //               ? Text(
                        //                   "2.99 copupon",
                        //                   style: AppTheme.bodyText
                        //                       .copyWith(color: AppColors.black),
                        //                 )
                        //               : const SizedBox(),
                        //         ]),
                        //   )
                        // ]),

                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  rental!.productPriceVat != null
                                      ? Text("${translate(context, "iva")} :",
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
                                  rental!.productPriceVat != null
                                      ? Text(
                                          NumberFormat.currency(
                                                  locale: 'it_IT', symbol: '€')
                                              .format(double.parse(
                                                  rental!.productPriceVat ??
                                                      '0,00')),
                                          style: AppTheme.bodyText
                                              .copyWith(color: AppColors.black),
                                        )
                                      : const SizedBox()
                                ]),
                          ),
                        ]),
                        // TableRow(children: [
                        //   Padding(
                        //     padding: const EdgeInsets.all(6.0),
                        //     child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           rental['total'] != null
                        //               ? Text(translate(context, "Total:"),
                        //                   style: AppTheme.bodyText.copyWith(
                        //                       color: AppColors.lightGrey
                        //                           .withOpacity(0.7),
                        //                       fontWeight: FontWeight.w600))
                        //               : const SizedBox(),
                        //         ]),
                        //   ),
                        //   Padding(
                        //     padding: const EdgeInsets.all(6.0),
                        //     child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           rental['total'] != null
                        //               ? Text(rental['total'].toString(),
                        //                   style: AppTheme.bodyText.copyWith(
                        //                       color: AppColors.black,
                        //                       fontWeight: FontWeight.w600))
                        //               : const SizedBox(),
                        //         ]),
                        //   ),
                        // ]),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _button(),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _button() {
    return Container(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 60, right: 60),
        decoration: BoxDecoration(
            border:
                Border.all(color: ref.read(flavorProvider).primary, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(25))),
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
