import 'package:contacta_pharmacy/theme/app_colors.dart';
import 'package:contacta_pharmacy/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';

class AddCardBottomSheet extends ConsumerWidget {
  AddCardBottomSheet({Key? key}) : super(key: key);

  final Map<String, dynamic> _controllers = {
    'cardNumber': TextEditingController(),
    'deadline': TextEditingController(),
    'cvv': TextEditingController(),
    'nameOnTheCard': TextEditingController(),
  };

  validation() {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.close,
                size: 32,
                color: Colors.black54,
              ),
            ),
            alignment: Alignment.centerRight,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              translate(context, 'add_card'),
              style: AppTheme.bodyText.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 17.0.sp,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              textAlign: TextAlign.start,
              controller: _controllers['cardNumber'],
              decoration: InputDecoration(
                labelText: translate(context, "card_number"),
                contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                suffixIcon: const Icon(
                  Icons.credit_card,
                  color: AppColors.lightGrey,
                  size: 45,
                ),
                prefixIcon: Consumer(builder: (context, ref, _) {
                  return Icon(
                    Icons.lock,
                    size: 25,
                    color: ref.read(flavorProvider).primary,
                  );
                }),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                  width: 45.0.w,
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 10,
                  ),
                  child: TextFormField(
                    controller: _controllers['deadline'],
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      labelText: translate(context, "deadline"),
                      contentPadding:
                          const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    ),
                  )),
              Container(
                  width: 45.0.w,
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 10,
                  ),
                  child: TextFormField(
                    controller: _controllers['cvv'],
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      labelText: translate(context, "cvv"),
                      contentPadding:
                          const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    ),
                  ))
            ],
          ),
          Container(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: _controllers['nameOnTheCard'],
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    labelText: translate(context, "name_of_the_card"),
                    contentPadding:
                        const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    prefixIcon: Consumer(builder: (context, ref, _) {
                      return Icon(
                        Icons.person,
                        size: 20,
                        color: ref.read(flavorProvider).primary,
                      );
                    }),
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(
                left: 30.0, right: 30, top: 30, bottom: 15),
            child: InkWell(
              onTap: () => validation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0.h),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 1.6.h),
                    decoration: BoxDecoration(
                      color: ref.read(flavorProvider).lightPrimary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        Text(
                          translate(context, "add_card"),
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
          ),
        ],
      ),
    );
  }
}
