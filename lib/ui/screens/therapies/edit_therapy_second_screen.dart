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

class EditTherapySecondScreen extends ConsumerStatefulWidget {
  const EditTherapySecondScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-therapy-second-screen';

  @override
  _EditTherapySecondScreenState createState() =>
      _EditTherapySecondScreenState();
}

class _EditTherapySecondScreenState
    extends ConsumerState<EditTherapySecondScreen> {
  Map<String, dynamic>? args;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  bool switchValue = false;
  final ApisNew _apisNew = ApisNew();
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

  DateTime createEndDate(
      DateTime startDate, int duration, String durationType) {
    if (durationType == "0") {
      return DateTime(
          startDate.year, startDate.month, startDate.day + duration);
    }
    return DateTime(startDate.year, startDate.month + duration, startDate.day);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print(args);
    return Scaffold(
      persistentFooterButtons: [
        InkWell(
          onTap: () {
            if (validation()) {
              ref.read(therapiesProvider).updateTherapy({
                'therapy_id': args?['id'],
                'user_id': ref.read(authProvider).user?.userId,
                'product': args?['product'],
                'medicine_fequency': args?['medicine_fequency'],
                'qty': '0',
                'duration': args?['duration'],
                'as_what_time': args?['as_what_time'],
                'start_date': formatter.format(args?['start_date'] as DateTime),
                'when_take': args?['when_take'],
                'note': args?['note'],
                'available_qty': args?['available_qty'],
                'available_notice': args?['available_notice'],
                'number_aviso': args?['number_aviso'],
                'pharmacy_id': ref.read(flavorProvider).pharmacyId,
              });

              // _apisNew.updateTherapy(_therapy.toMap());
              //{
              // 'pharmacy_id': 1,
              // 'product': 'prod_test',
              // 'description': 'ciao',
              // 'medicine_fequency': 'Quotidiana',
              // 'qty': '5',
              // 'duration': '0',
              // 'as_what_time': '11:00:00',
              // 'start_date': formattedDate,
              // 'end_date': formattedDate,
              // 'when_take': 'Pasto',
              // 'note': 'ciao',
              // 'available_qty': '2',
              // 'available_notice': 'true',
              // 'number_aviso': '0',
              // 'status': 'upcomming',
              // }

              Navigator.popUntil(
                  context, ModalRoute.withName('/therapies-screen'));
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
          translate(context, 'Edit_Therapy'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(translate(context, "Edit_Therapy"),
                  style:
                      AppTheme.h6Style.copyWith(fontWeight: FontWeight.w600)),
              Text(translate(context, "Therapy_insertion_des"),
                  style: AppTheme.bodyText
                      .copyWith(color: AppColors.lightGrey, fontSize: 10.0.sp)),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Text("Quantità disponibile".toUpperCase(),
                        style:
                            AppTheme.h6Style.copyWith(color: AppColors.black)),
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
                        style:
                            AppTheme.h6Style.copyWith(color: AppColors.black)),
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
                      child: Text(translate(context, "AVAILABILITY_NOTICE_des"),
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
                              contentPadding: EdgeInsets.fromLTRB(30, 7, 20, 5),

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
    );
  }
}
