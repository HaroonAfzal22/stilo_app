import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/flavor.dart';

class CustomNumberPicker extends ConsumerStatefulWidget {
  const CustomNumberPicker({
    Key? key,
    this.initialValue,
    required this.onValue,
  }) : super(key: key);

  final int? initialValue;
  final Function(int value) onValue;
  @override
  _CustomNumberPickerState createState() => _CustomNumberPickerState();
}

class _CustomNumberPickerState extends ConsumerState<CustomNumberPicker> {
  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      value = widget.initialValue!;
    }
  }

  int value = 0;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: GestureDetector(
            onTap: () {
              if (value > 0) {
                setState(() {
                  (value--).toString();
                  widget.onValue(value);
                });
              }
            },
            child: Icon(
              Icons.remove_circle_outline,
              color: ref.read(flavorProvider).primary,
            ),
          ),
        ),
        /* SizedBox(
          width: 50,
          child: TextFormField(
            // controller: _textEditingController,
            initialValue: '0',
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                borderSide: BorderSide(color: AppColors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                borderSide: BorderSide(color: AppColors.white),
              ),
              filled: true,
              contentPadding:
                  EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
            ),
            // controller: _textEditingController,
          ),
        ),*/
        Text(value.toString()),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                (value++).toString();
                widget.onValue(value);
              });
            },
            child: Icon(
              Icons.add_circle_outline,
              color: ref.read(flavorProvider).primary,
            ),
          ),
        ),
      ],
    );
  }
}
