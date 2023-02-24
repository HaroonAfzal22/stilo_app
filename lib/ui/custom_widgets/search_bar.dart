import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../translations/translate_string.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    this.onChanged,
    this.onSubmitted,
    required this.controller,
    this.qrCode = false,
  }) : super(key: key);
  final TextEditingController controller;
  final Function(String? value)? onChanged;
  final Function(String? value)? onSubmitted;
  final bool qrCode;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: TextField(
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.grey[200],
          hintStyle: const TextStyle(
              fontSize: 14,
              color: AppColors.lightGrey,
              fontWeight: FontWeight.w400),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: qrCode
              ? IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/images/barcode.png',
                    height: 50,
                    width: 50,
                  ),
                )
              : const SizedBox.shrink(),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: translate(context, 'search_hint'),
        ),
      ),
    );
  }
}
