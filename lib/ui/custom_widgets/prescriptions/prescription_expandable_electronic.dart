import 'package:contacta_pharmacy/models/flavor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../config/MyApplication.dart';
import '../../../config/constant.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

class PrescriptionExpandableElectronic extends ConsumerStatefulWidget {
  final String? layoutType;
  final String? numPrescriptionMed;
  final String? numPrescriptionVet;
  final String? codFiscale;
  final String? prefixPrescription;
  final Function(String, String) validate;

  const PrescriptionExpandableElectronic(
      {this.layoutType,
      this.numPrescriptionMed,
      this.numPrescriptionVet,
      this.codFiscale,
      this.prefixPrescription,
      required this.validate,
      Key? key})
      : super(key: key);

  @override
  ConsumerState<PrescriptionExpandableElectronic> createState() =>
      _PrescriptionExpandableElectronicState();
}

class _PrescriptionExpandableElectronicState
    extends ConsumerState<PrescriptionExpandableElectronic> {
  final Map<String, dynamic> _controllers = {
    'numPrescriptionMed': TextEditingController(),
    'numPrescriptionVet': TextEditingController(),
    'codFiscale': TextEditingController(),
    'prefixPrescription': TextEditingController(),
    'preferences': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            spreadRadius: 4,
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            backgroundColor: Colors.white,
            title: Text(
              translate(context, 'electronic_recipe'),
              overflow: TextOverflow.ellipsis,
              style: AppTheme.bodyText.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              translate(context, 'select_electronic_recipe'),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: AppTheme.bodyText
                  .copyWith(fontSize: 8.0.sp, color: AppColors.lightGrey),
            ),
            leading: Padding(
                padding: const EdgeInsets.all(2),
                child: Image.asset('assets/icons/e_reciet.png')),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    const Align(
                      child: Text('Numero Ricetta'),
                      alignment: Alignment.centerLeft,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    widget.layoutType == "med"
                        ? Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: TextFormField(
                                    controller:
                                        _controllers['prefixPrescription'],
                                    decoration:
                                        Constant.borderTextFieldDecoration(ref
                                            .read(flavorProvider)
                                            .lightPrimary),
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    onChanged: (val) {
                                      widget.validate(
                                          'prefixPrescription',
                                          _controllers['prefixPrescription']
                                              .text);
                                    }),
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              Expanded(
                                flex: 8,
                                child: TextFormField(
                                    controller:
                                        _controllers['numPrescriptionMed'],
                                    decoration:
                                        Constant.borderTextFieldDecoration(ref
                                            .read(flavorProvider)
                                            .lightPrimary),
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    onChanged: (val) {
                                      widget.validate(
                                          'numPrescriptionMed',
                                          _controllers['numPrescriptionMed']
                                              .text);
                                    }),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              const SizedBox(),
                              Expanded(
                                child: TextFormField(
                                    controller:
                                        _controllers['numPrescriptionVet'],
                                    decoration:
                                        Constant.borderTextFieldDecoration(ref
                                            .read(flavorProvider)
                                            .lightPrimary),
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    onChanged: (val) {
                                      widget.validate(
                                          'numPrescriptionVet',
                                          _controllers['numPrescriptionVet']
                                              .text);
                                    }),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Align(
                      child: Text('Codice Fiscale'),
                      alignment: Alignment.centerLeft,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                        controller: _controllers['codFiscale'],
                        decoration: Constant.borderTextFieldDecoration(
                            ref.read(flavorProvider).lightPrimary),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp("[0-9a-zA-Z]")),
                          UpperCaseTextFormatter(),
                        ], // Only num
                        onChanged: (val) {
                          widget.validate(
                              'codFiscale', _controllers['codFiscale'].text);
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
