import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/models/order.dart';
import 'package:contacta_pharmacy/theme/app_colors.dart';
import 'package:contacta_pharmacy/ui/screens/orders/order_detail_screen.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

class OrderTile extends StatefulWidget {
  final Order order;
  final bool defaultOpened;
  const OrderTile({
    Key? key,
    required this.order,
    required this.defaultOpened,
  }) : super(key: key);

  @override
  _OrderTileState createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      initialExpanded: widget.defaultOpened,
      child: ExpandablePanel(
        theme: const ExpandableThemeData(
            hasIcon: false,
            tapBodyToCollapse: false,
            tapHeaderToExpand: true,
            tapBodyToExpand: false),
        collapsed: CollapsedItem(
          order: widget.order,
        ),
        expanded: ExpandedItem(order: widget.order),
        header: Header(
          order: widget.order,
        ),
      ),
    );
  }
}

class CollapsedItem extends StatelessWidget {
  const CollapsedItem({Key? key, required this.order}) : super(key: key);
  final Order order;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(order.products!.length.toString() +
              ' ' +
              translate(context, "items in your cart")),
        ),
        Container(
          padding: const EdgeInsets.only(top: 3, bottom: 3, left: 2, right: 8),
          margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(OrderDetailScreen.routeName,
                      arguments: order.id);
                },
                child: Row(
                  children: [
                    Text(
                      translate(context, "Show_detail"),
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 11.0.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.arrow_forward_sharp,
                      color: Colors.blue,
                      size: 19,
                    )
                  ],
                ),
              ),
            ],
          ),

//TODO fix later
/*
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: order.status == 'pendingl'
                      ? Container(
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 3, bottom: 3, left: 8, right: 8),
                            child: Text(
                              translate(context, 'Waiting'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : order.status == 'completed'
                          ? Container(
                              decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 3, bottom: 3, left: 8, right: 8),
                                child: Text(
                                  translate(context, 'Completed'),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 3, bottom: 3, left: 8, right: 8),
                                child: Text(
                                  translate(context, 'Canceled'),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),

//TODO fix later
*/
/*
                    Container(
                      margin: const EdgeInsets.only(bottom: 5, top: 5),
                      decoration: BoxDecoration(
                        color: order['shipping_type']
                                    .toString()
                                    .toLowerCase()
                                    .contains("Canceled") ||
                                order['shipping_type']
                                    .toString()
                                    .toLowerCase()
                                    .contains("refund")
                            ? AppColors.darkRed
                            : order['shipping_type']
                                    .toString()
                                    .toLowerCase()
                                    .contains("completed")
                                ? ref.read(flavorProvider).lightPrimary
                                : order['shipping_type']
                                            .toString()
                                            .toLowerCase()
                                            .contains("pending") ||
                                        order['shipping_type']
                                            .toString()
                                            .toLowerCase()
                                            .contains("ORDER shipped")
                                    ? AppColors.blueColor
                                    : Colors.orange,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15),
                        child: Center(
                          child: status != null
                              ? Text(
                                  //TODO fix with capitalize
                                  "$status",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.0.sp,
                                      fontWeight: FontWeight.normal),
                                )
                              : const SizedBox(),
                        ),
                      ),
                    ),
*/ /*


              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(OrderDetailScreen.routeName, arguments: order);
                },
                child: Row(
                  children: [
                    Text(
                      translate(context, "Show_detail"),
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 11.0.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.arrow_forward_sharp,
                      color: Colors.blue,
                      size: 19,
                    )
                  ],
                ),
              ),
            ],
          ),
*/
        ),
      ],
    );
  }
}

class ExpandedItem extends StatelessWidget {
  const ExpandedItem({Key? key, required this.order}) : super(key: key);
  final Order order;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            color: AppColors.grey,
          ),
          shrinkWrap: true,
          itemCount: order.products!.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              //TODO ripristinare?
              /*       Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: order.products![index]);*/
            },
            child: Container(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              color: Colors.white,
              child: Row(
                children: [
                  if (order.products![index].productImage!.isNotEmpty)
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: CachedNetworkImage(
                          imageUrl: order
                              .products![index].productImage![0].productImage!,
                          errorWidget: (context, url, error) {
                            return Image.asset("assets/images/noImage.png");
                          },
                        ),
                      ),
                    )
                  else
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Image.asset("assets/images/noImage.png"),
                      ),
                    ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.products![index].productName!,
                          maxLines: 2,
                          style: AppTheme.h6Style.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                              fontSize: 13.0.sp),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20.0.w,
                              child: Text(
                                "${translate(context, "quantity")} :",
                                style: AppTheme.h6Style.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkGrey,
                                    fontSize: 11.0.sp),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                order.products![index].qty.toString(),
                                style: AppTheme.h6Style.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkGrey,
                                    fontSize: 11.0.sp),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "${translate(context, "price")} : ",
                              style: AppTheme.h6Style.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkGrey,
                                  fontSize: 11.0.sp),
                            ),
                            Text(
                              '${order.products![index].productDisplayPrice ?? order.products![index].price ?? "0.0"}' +
                                  " €",
                              //TODO fix con concatena
                              style: AppTheme.h6Style.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkGrey,
                                  fontSize: 11.0.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        //TODO fix with status
        Container(
          padding: const EdgeInsets.only(top: 3, bottom: 3, left: 2, right: 8),
          margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(OrderDetailScreen.routeName,
                      arguments: order.id);
                },
                child: Row(
                  children: [
                    Text(
                      translate(context, "Show_detail"),
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 11.0.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.arrow_forward_sharp,
                      color: Colors.blue,
                      size: 19,
                    )
                  ],
                ),
              ),
            ],
          ),

//TODO fix later
/*
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: order.status == 'pendingl'
                      ? Container(
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 3, bottom: 3, left: 8, right: 8),
                            child: Text(
                              translate(context, 'Waiting'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : order.status == 'completed'
                          ? Container(
                              decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 3, bottom: 3, left: 8, right: 8),
                                child: Text(
                                  translate(context, 'Completed'),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 3, bottom: 3, left: 8, right: 8),
                                child: Text(
                                  translate(context, 'Canceled'),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),

//TODO fix later
*/
/*
                    Container(
                      margin: const EdgeInsets.only(bottom: 5, top: 5),
                      decoration: BoxDecoration(
                        color: order['shipping_type']
                                    .toString()
                                    .toLowerCase()
                                    .contains("Canceled") ||
                                order['shipping_type']
                                    .toString()
                                    .toLowerCase()
                                    .contains("refund")
                            ? AppColors.darkRed
                            : order['shipping_type']
                                    .toString()
                                    .toLowerCase()
                                    .contains("completed")
                                ? ref.read(flavorProvider).lightPrimary
                                : order['shipping_type']
                                            .toString()
                                            .toLowerCase()
                                            .contains("pending") ||
                                        order['shipping_type']
                                            .toString()
                                            .toLowerCase()
                                            .contains("ORDER shipped")
                                    ? AppColors.blueColor
                                    : Colors.orange,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15),
                        child: Center(
                          child: status != null
                              ? Text(
                                  //TODO fix with capitalize
                                  "$status",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.0.sp,
                                      fontWeight: FontWeight.normal),
                                )
                              : const SizedBox(),
                        ),
                      ),
                    ),
*/ /*


              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(OrderDetailScreen.routeName, arguments: order);
                },
                child: Row(
                  children: [
                    Text(
                      translate(context, "Show_detail"),
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 11.0.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.arrow_forward_sharp,
                      color: Colors.blue,
                      size: 19,
                    )
                  ],
                ),
              ),
            ],
          ),
*/
        ),
      ],
    );
  }
}

class Header extends ConsumerWidget {
  const Header({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: ref.read(flavorProvider).primary,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/order_basket.png',
            height: 2.0.h,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            translate(context, "Order_No"),
            style: AppTheme.h6Style.copyWith(
                color: Colors.white,
                fontSize: 11.0.sp,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 2,
          ),
          Text(
            order.id.toString(),
            style: AppTheme.h6Style.copyWith(
                color: Colors.white,
                fontSize: 11.0.sp,
                fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
              DateFormat("dd/MM/yyyy")
                  .format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(order.date!)),
              style: AppTheme.h6Style.copyWith(
                color: Colors.grey[300],
                fontSize: 11.0.sp,
              )),
          SizedBox(
            height: 30,
            width: 30,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              onPressed: () {},
              //TODO fix
              /*  icon: Icon(
                _controller.value
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              onPressed: () {
                _controller.toggle.call();
                setState(() {});
              },*/
            ),
          ),
        ],
      ),
    );
  }
}
