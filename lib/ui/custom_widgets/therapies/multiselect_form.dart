import 'package:contacta_pharmacy/theme/app_colors.dart';
import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

import '../../../models/flavor.dart';

class MultiselectForm extends ConsumerStatefulWidget {
  final List<dynamic> weekDays;
  final List<dynamic> selectedWeekDays;
  final Function(List<dynamic>) updateParentList;
  final String mode;
  const MultiselectForm(
      this.weekDays, this.selectedWeekDays, this.updateParentList, this.mode,
      {Key? key})
      : super(key: key);

  @override
  ConsumerState<MultiselectForm> createState() => _MultiselectFormState();
}

class _MultiselectFormState extends ConsumerState<MultiselectForm> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> _selectedDays = [];
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: MultiSelectFormField(
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.lightGrey),
                ),
                autovalidate: AutovalidateMode.disabled,
                chipBackGroundColor: ref.read(flavorProvider).primary,
                chipLabelStyle: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
                dialogTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                checkBoxActiveColor: ref.read(flavorProvider).lightPrimary,
                checkBoxCheckColor: AppColors.white,
                dialogShapeBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                title: Text(
                  translate(context, "weekdays"),
                  style: const TextStyle(fontSize: 16),
                ),
                validator: (value) {
                  if (value == null || value.length == 0) {
                    return translate(context, "select_weekdays");
                  }
                  return null;
                },
                dataSource: widget.weekDays,
                textField: "name",
                valueField: "id",
                okButtonLabel: 'OK',
                cancelButtonLabel: translate(context, "cancel"),
                fillColor: AppColors.white,
                hintWidget: Text(translate(context, "select_weekdays")),
                initialValue: widget.selectedWeekDays,
                enabled: widget.mode == "edit" ? false : true,
                onSaved: widget.mode == "edit"
                    ? null
                    : (value) {
                        List arry = [];

                        if (value == null) return;
                        setState(() {
                          _selectedDays = value;
                        });
                        for (int i = 0; i < _selectedDays.length; i++) {
                          arry.add(_selectedDays[i].toString());
                        }
                        widget.updateParentList(_selectedDays);
                      },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
