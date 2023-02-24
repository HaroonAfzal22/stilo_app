import 'package:contacta_pharmacy/theme/app_colors.dart';
import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:flutter/material.dart';

class SearchBarNoQr extends StatelessWidget {
  const SearchBarNoQr({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final TextEditingController controller;

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
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.grey[200],
          hintStyle: const TextStyle(
              fontSize: 14,
              color: AppColors.lightGrey,
              fontWeight: FontWeight.w400),
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: translate(context, 'search_hint'),
        ),
      ),
    );
  }
}
