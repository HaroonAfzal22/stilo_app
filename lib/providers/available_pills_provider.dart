import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../apis/apisNew.dart';

final availablePillsProvider =
    ChangeNotifierProvider(((ref) => AvailablePillsProvider()));

class AvailablePillsProvider extends ChangeNotifier {
  List<dynamic> availablePills = [];
  final _apiNews = ApisNew();
}
