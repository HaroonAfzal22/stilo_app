import 'package:contacta_pharmacy/models/flavor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../theme/app_colors.dart';

class EditTextWithoutIcon extends ConsumerStatefulWidget {
  String label;
  String onchangtext;
  TextEditingController controller;
  bool obsecured = false;
  TextInputType textInputType;
  Function(String) onchange;

  EditTextWithoutIcon({
    Key? key,
    required this.onchangtext,
    required this.label,
    required this.controller,
    required this.onchange,
    this.obsecured = false,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  @override
  _EditTextWithoutIconState createState() => _EditTextWithoutIconState();
}

class _EditTextWithoutIconState extends ConsumerState<EditTextWithoutIcon> {
  //TODO ripristinare

  // var maskFormatter = new MaskTextInputFormatter(mask: '***.**', filter: { "*": RegExp(r'[0-9]') });

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextFormField(
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: true),
            controller: widget.controller,
            obscureText: widget.obsecured,
            //keyboardType: widget.textInputType,
            onChanged: (v) => widget.onchange != null ? widget.onchange(v) : {},
            inputFormatters: [
              LengthLimitingTextInputFormatter(6),
            ],
            //TODO ripristinare
            /*     ValidatorInputFormatter(
                  editingValidator: DecimalNumberEditingRegexValidator())],*/
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.0.sp,
                color: AppColors.darkGrey),
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              labelText: widget.label,
              filled: false,
              enabled: true,
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.lightGrey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ref.read(flavorProvider).primary),
              ),
            )));
  }
}
