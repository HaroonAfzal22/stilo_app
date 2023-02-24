import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../models/flavor.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme.dart';
import '../../translations/translate_string.dart';
import '../custom_widgets/custom_number_picker.dart';
import '../custom_widgets/no_user.dart';

class AvailablePillsScreen extends ConsumerStatefulWidget {
  const AvailablePillsScreen({Key? key}) : super(key: key);
  static const routeName = '/available-pills-screen';

  @override
  ConsumerState<AvailablePillsScreen> createState() =>
      _AvailablePillsScreenState();
}

class _AvailablePillsScreenState extends ConsumerState<AvailablePillsScreen> {
  List<dynamic>? availablePills;
  final ApisNew _apisNew = ApisNew();

  Future<void> getAvailablePills() async {
    final result = await _apisNew.getAvailablePills({
      'user_id': ref.read(authProvider).user?.userId,
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
    });
    availablePills = result.data;
    setState(() {});
  }

  void deletePill(int id) {
    availablePills!.removeWhere((item) => item['id'] == id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    if (user != null) {
      getAvailablePills();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          translate(context, 'Pads_running_out'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (availablePills != null && availablePills!.isNotEmpty)
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: availablePills!.length,
                itemBuilder: (BuildContext context, int index) {
                  return PillItem(
                    pill: availablePills![index],
                    onDelete: () {
                      deletePill((availablePills![index]['id']));
                    },
                  );
                },
              )
            else if (availablePills != null && availablePills!.isEmpty)
              NoData(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2 - 100),
              )
            else if (user == null)
              const NoUser()
            else
              Center(
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2 - 100),
                  child: CircularProgressIndicator(
                    color: ref.read(flavorProvider).lightPrimary,
                  ),
                ),
              ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}

class PillItem extends ConsumerStatefulWidget {
  const PillItem({
    Key? key,
    required this.pill,
    required this.onDelete,
  }) : super(key: key);

  final dynamic pill;
  final VoidCallback onDelete;

  @override
  ConsumerState<PillItem> createState() => _PillItemState();
}

class _PillItemState extends ConsumerState<PillItem> {
  int? selectedQty;

  Future<int?> showSelectQtyDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ref.read(flavorProvider).primary,
                    ),
                    child: Center(
                      child: Text(
                        translate(context, 'enter_qty_therapy'),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  //TODO finire
                  CustomNumberPicker(
                    initialValue: int.tryParse(widget.pill['available_qty']),
                    onValue: (value) {
                      selectedQty = value;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
              actions: <Widget>[
                InkWell(
                  onTap: () {
                    if (selectedQty != null) {
                      Navigator.of(context).pop(selectedQty);
                    }
                  },
                  child: Container(
                      height: 4.0.h,
                      width: 20.0.w,
                      decoration: BoxDecoration(
                        color: ref.read(flavorProvider).primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                          child: Text(
                        translate(context, "select"),
                        style: AppTheme.bodyText.copyWith(
                          color: AppColors.white,
                          fontSize: 10.0.sp,
                        ),
                        textAlign: TextAlign.center,
                      ))),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 4.0.h,
                    width: 20.0.w,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: ref.read(flavorProvider).primary)),
                    child: Center(
                      child: Text(
                        translate(context, "cancel"),
                        style: AppTheme.bodyText.copyWith(
                          color: AppColors.black,
                          fontSize: 10.0.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
        });
    return selectedQty;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //TODO riattivare
      /*     onTap: () async {
        selectedQty = await showSelectQtyDialog(context);
        setState(() {
          widget.pill['available_qty'];
        });
      },*/
      child: Container(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Container(
                        height: 10.0.h,
                        width: 10.0.h,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.darkRed,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        //TODO fix
                        // child: Image.network('${widget.therapilistdata[index]['image']}'),
                        child: widget.pill['product_image'] == null
                            ? Image.asset(
                                'assets/images/noImage.png',
                                height: 10.0.h,
                                width: 18.0.w,
                              )
                            : CachedNetworkImage(
                                height: 10.0.h,
                                width: 18.0.w,
                                imageUrl: 'hhh',
                                errorWidget: (context, url, error) {
                                  return Image.asset(
                                      "assets/images/noImage.png");
                                },
                              ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 8),
                                child: Text(
                                  widget.pill['product_name'],
                                  style: AppTheme.bodyText.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            /*          IconButton(
                              onPressed: widget.onDelete,
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            )*/
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quantità disponibile',
                              style: AppTheme.bodyText.copyWith(
                                  fontSize: 12, color: AppColors.lightGrey),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Expanded(
                              child: Text(
                                widget.pill['available_qty'].toString(),
                                style: AppTheme.bodyText.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.lightGrey),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
