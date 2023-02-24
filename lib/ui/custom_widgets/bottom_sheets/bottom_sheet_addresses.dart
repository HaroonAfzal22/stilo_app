import 'package:contacta_pharmacy/ui/custom_widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';
import '../../../utils/ImageString.dart';

class BottomSheetAddresses extends ConsumerWidget {
  const BottomSheetAddresses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _manageAddressBottomsheet(ref);
  }
}

Widget _manageAddressBottomsheet(WidgetRef ref) {
  List<dynamic> workAddress = [];
  List<dynamic> homeAddress = [];
  List<dynamic> otherAddress = [];

  return StatefulBuilder(builder: (context, state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleText(
                  text: translate(context, 'edit_manage_address'),
                  color: Colors.black,
                  height: null,
                  textAlign: TextAlign.center),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  ic_cancel,
                  scale: 4,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: 1 > 0
              ? Center(
                  child: Text(
                    translate(context, "no_address"),
                    textAlign: TextAlign.center,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            )),
                        child: 1 > 0
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 15),
                                child: Text(
                                  translate(context, "work"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              )
                            : const SizedBox(),
                      ),
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                /*        setState(() {
                            addressType =
                            "${workAddress[index]['address_type']}";
                            pickupType = "home";
                            address =
                            "${workAddress[index]['name']}, ${workAddress[index]['address']}, ${workAddress[index]['province']}, ${workAddress[index]['region']}, ${workAddress[index]['country']} ${workAddress[index]['cap']}";

                            addressMap = workAddress[index];
                            log(addressMap.toString());
                          });
                          Navigator.pop(context);

                          showgreenToast(
                              translate(context, "Address selected"),
                              context);*/
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              '${workAddress[index]['name']}',
                                              style: AppTheme.h6Style.copyWith(
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: IconButton(
                                                icon: Image.asset(
                                                  ic_edit_primarycolor,
                                                  height: 10.0.h,
                                                ),
                                                onPressed: () {
                                                  /*Navigator.pushNamed(
                                              context, EditManageAddress.routeName);*/
                                                  /*   Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => EditManageAddress(
                                                        workAddress[
                                                        index],
                                                        "edit",
                                                        addressType))).then(
                                                    (value) {
                                                  if (value) {
                                                    addAdressList(
                                                        state);
                                                  }
                                                });*/
                                                }),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                          '${workAddress[index]['address']}, ${workAddress[index]['province']}, ${workAddress[index]['region']}, ${workAddress[index]['country']}, ${workAddress[index]['cap']}, ',
                                          style: AppTheme.bodyText.copyWith(
                                              color: AppColors.lightGrey)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                      const SizedBox(
                        height: 15,
                      ),
                      homeAddress.isNotEmpty
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 15),
                                child: Text(
                                  //"Casa",
                                  translate(context, "home"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ))
                          : const SizedBox(),
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: homeAddress.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                /*     setState(() {
                            addressType =
                            "${homeAddress[index]['address_type']}";
                            pickupType = "home";
                            address =
                            "${homeAddress[index]['name']}, ${homeAddress[index]['address']}, ${homeAddress[index]['province']}, ${homeAddress[index]['region']}, ${homeAddress[index]['country']} ${homeAddress[index]['cap']}";

                            addressMap = homeAddress[index];
                            log(addressMap.toString());
                          });
                          Navigator.pop(context);

                          showgreenToast(
                              translate(context, "Address selected"),
                              context);*/
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                  '${homeAddress[index]['name']}',
                                                  style: AppTheme.h6Style
                                                      .copyWith(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight: FontWeight
                                                              .w600))),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: IconButton(
                                                icon: Image.asset(
                                                  ic_edit_primarycolor,
                                                  height: 10.0.h,
                                                ),
                                                onPressed: () {
                                                  /*  Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => EditManageAddress(
                                                        homeAddress[
                                                        index],
                                                        "edit",
                                                        addressType))).then(
                                                    (value) {
                                                  if (value) {
                                                    addAdressList(
                                                        state);
                                                  }
                                                });*/
                                                }),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                          '${homeAddress[index]['address']}, ${homeAddress[index]['province']}, ${homeAddress[index]['region']}, ${homeAddress[index]['country']}, ${homeAddress[index]['cap']}, ',
                                          style: AppTheme.bodyText.copyWith(
                                              color: AppColors.lightGrey)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                      const SizedBox(height: 10),
                      otherAddress.isNotEmpty
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 15),
                                child: Text(
                                  translate(context, "Other"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ))
                          : const SizedBox(),
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: otherAddress.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                /*       setState(() {
                            addressType =
                            "${otherAddress[index]['address_type']}";
                            pickupType = "home";
                            address =
                            "${otherAddress[index]['name']}, ${otherAddress[index]['address']}, ${otherAddress[index]['province']}, ${otherAddress[index]['region']}, ${otherAddress[index]['country']} ${otherAddress[index]['cap']}";
                            addressMap = otherAddress[index];
                            log(addressMap.toString());
                          });
                          Navigator.pop(context);

                          showgreenToast(
                              translate(context, "Address selected"),
                              context);*/
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                  '${otherAddress[index]['name']}',
                                                  style: AppTheme.h6Style
                                                      .copyWith(
                                                          color:
                                                              AppColors.black,
                                                          fontWeight: FontWeight
                                                              .w600))),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: IconButton(
                                                icon: Image.asset(
                                                  ic_edit_primarycolor,
                                                  height: 10.0.h,
                                                ),
                                                onPressed: () {
                                                  /*    Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => EditManageAddress(
                                                        otherAddress[
                                                        index],
                                                        "edit",
                                                        addressType))).then(
                                                    (value) {
                                                  if (value) {
                                                    addAdressList(
                                                        state);
                                                  }*/
                                                }),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                          '${otherAddress[index]['address']}, ${otherAddress[index]['province']}, ${otherAddress[index]['region']}, ${otherAddress[index]['country']}, ${otherAddress[index]['cap']}, ',
                                          style: AppTheme.bodyText.copyWith(
                                              color: AppColors.lightGrey)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
        ),
        Container(
          padding:
              const EdgeInsets.only(left: 0, right: 0, bottom: 20, top: 30),
          width: 70.0.w,
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: () {
              /*  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditManageAddress({}, "add", addressType)))
                  .then((value) {
                if (value = true) {
                  addAdressList(state);
                  // state(() {});
                }
              });*/
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0.h),
              child: Card(
                margin: EdgeInsets.zero,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 1.6.h),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      (ref.read(flavorProvider).lightPrimary),
                      (ref.read(flavorProvider).lightPrimary),
                    ],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                  )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        translate(context, "add_address"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  });
}
