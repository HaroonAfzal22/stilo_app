import 'package:contacta_pharmacy/models/medcab_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../apis/apisNew.dart';

final medCabProvider = ChangeNotifierProvider(((ref) => MedCabProvider()));

class MedCabProvider extends ChangeNotifier {
  List<dynamic>? items;
  final _apiNews = ApisNew();

  Future<void> getMedCabItems(Map<String, dynamic> data) async {
    final result = await _apiNews.getMedCabItems(data);
    items = result;
    notifyListeners();
  }

  Future<void> createMedCabItem(Map<String, dynamic> data) async {
    final result = await _apiNews.createMedCabItem(data);
    await getMedCabItems(
      {'user_id': data['user_id']},
    );
  }

  Future<void> deleteMedCabItem(Map<String, dynamic> data) async {
    final rsult = await _apiNews.deleteMedCabItem(data);
    await getMedCabItems(
      {'user_id': data['user_id']},
    );
  }

  Future<dynamic> updateMedCabItem(Map<String, dynamic> data) async {
    final result = await _apiNews.updateMedCabItem(data);
    await getMedCabItems(
      {'user_id': data['user_id']},
    );
    return result;
  }
}
