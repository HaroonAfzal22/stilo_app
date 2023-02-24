import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/config/MyApplication.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/providers/therapies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

class CreateTherapyThirdScreen extends ConsumerStatefulWidget {
  const CreateTherapyThirdScreen({Key? key}) : super(key: key);
  static const routeName = '/create-therapy-third-screen';

  @override
  _CreateTherapyThirdScreenState createState() =>
      _CreateTherapyThirdScreenState();
}

class _CreateTherapyThirdScreenState
    extends ConsumerState<CreateTherapyThirdScreen> {
  bool switchValue = false;
  final ApisNew _apisNew = ApisNew();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  Map<String, dynamic> args = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {});
    });
  }

  final Map<String, dynamic> _controllers = {
    'qtyAvailable': TextEditingController(),
    'number_aviso': TextEditingController(),
  };

  bool validation() {
    if (_controllers['qtyAvailable'].text.isEmpty) {
      showredToast(translate(context, "err_qtyAvailable"), context);
      return false;
    }
    return true;
  }

  String createEndDate(DateTime startDate, int duration, String durationType) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    if (durationType == "0") {
      return formatter.format(
          DateTime(startDate.year, startDate.month, startDate.day + duration));
    }
    return formatter.format(
        DateTime(startDate.year, startDate.month + duration, startDate.day));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        persistentFooterButtons: [
          InkWell(
            onTap: () async {
              if (validation()) {
                args.addAll({
                  'available_qty': _controllers['qtyAvailable'].text,
                  'available_notice': switchValue,
                  'number_aviso': _controllers['number_aviso'].text,
                  'status': "upcoming",
                });

                final result = await ref.read(therapiesProvider).createTherapy(
                  {
                    'user_id': ref.read(authProvider).user!.userId,
                    "pharmacy_id": ref.read(flavorProvider).pharmacyId,
                    "product": args['product'],
                    "product_id": args['product_id'],
                    "medicine_frequency": args['medicine_fequency'],
                    "frequency_value": args['frequency_value'],
                    "qty": int.tryParse(args['qty'] as String),
                    "qty_unit": args['qty_unit'],
                    "duration": int.tryParse(args['duration'] as String),
                    "duration_type": args['duration_unit'],
                    "as_what_time": args['as_what_time'],
                    "start_date":
                        formatter.format(args['start_date'] as DateTime),
                    "time": args['as_what_time'],
                    "when_take": args['when_take'],
                    "note": args['note'],
                    "available_qty":
                        int.tryParse(_controllers['qtyAvailable'].text),
                    "available_notice": switchValue.toString(),
                    "number_aviso":
                        int.tryParse(_controllers['number_aviso'].text),
                  },
                );
                if (result == 200) {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName('/therapies-screen'),
                  );
                }
              }
            },
            child: Container(
              width: double.infinity,
              height: 64,
              color: ref.read(flavorProvider).lightPrimary,
              child: Center(
                child: Text(
                  translate(context, 'continue'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
        appBar: AppBar(
          title: Text(
            translate(context, 'Therapy_insertion'),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(translate(context, "3/3"),
                    style: AppTheme.h6Style.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ref.read(flavorProvider).primary)),
                Text(translate(context, "Therapy_insertion"),
                    style:
                        AppTheme.h6Style.copyWith(fontWeight: FontWeight.w600)),
                Text(translate(context, "Therapy_insertion_des"),
                    style: AppTheme.bodyText.copyWith(
                        color: AppColors.lightGrey, fontSize: 10.0.sp)),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Text("Quantità disponibile".toUpperCase(),
                          style: AppTheme.h6Style
                              .copyWith(color: AppColors.black)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25))),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 100,
                                child: TextFormField(
                                  controller: _controllers['qtyAvailable'],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 5, 10, 5),
                                    //labelText: 'Pillole',
                                    labelStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                            ],
                          )),
                    )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Text("Notifica disponibilità".toUpperCase(),
                          style: AppTheme.h6Style
                              .copyWith(color: AppColors.black)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Container(
                        constraints:
                            const BoxConstraints(minWidth: 200, maxWidth: 300),
                        child: Text(
                            translate(context, "AVAILABILITY_NOTICE_des"),
                            style: AppTheme.bodyText.copyWith(
                                color: AppColors.black, fontSize: 10.0.sp)),
                      ),
                    ),
                    Expanded(
                      child: Switch(
                          value: switchValue,
                          onChanged: (val) {
                            setState(() {
                              switchValue = !switchValue;
                              if (!switchValue) {
                                _controllers['number_aviso'].text = "";
                              }
                            });
                          }),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18, right: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 8,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Text(
                                translate(context, "MINIMUM_NUMBER_FOR_AVISO"),
                                style: AppTheme.h6Style
                                    .copyWith(color: AppColors.black)),
                          )),
                      Expanded(
                          flex: 2,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: TextFormField(
                              enabled: switchValue,
                              controller: _controllers['number_aviso'],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(30, 7, 20, 5),

                                //labelText: 'Pillolee',
                                labelStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
