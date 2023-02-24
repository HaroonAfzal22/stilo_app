import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final String? text;
  final EdgeInsets? margin;
  const NoData({Key? key, this.text, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.only(
      //top: MediaQuery.of(context).size.height / 2 - 100),
      margin: margin ?? EdgeInsets.zero,
      child: Center(
        child: Text(
          translate(context, text ?? 'No_Data'),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
