import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/therapy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pill.dart';

final therapiesProvider = ChangeNotifierProvider(
  (ref) => TherapiesProvider(),
);

class TherapiesProvider extends ChangeNotifier {
  List<Therapy>? therapies;
  List<Pill>? nextPills;
  final ApisNew _apisNew = ApisNew();

  Future<void> getTherapies(Map<String, dynamic> data) async {
    final result = await _apisNew.getTherapies(data);
    therapies = result;
    notifyListeners();
  }

  void deleteTherapy(Map<String, dynamic> data) async {
    final result = await _apisNew.deleteTherapy(data);
    getTherapies({
      'user_id': data['user_id'],
      'pharmacy_id': data['pharmacy_id'],
    });
    getNextPills({
      'pharmacy_id': data['pharmacy_id'],
      'user_id': data['user_id'],
      'page_number': 0,
    });
  }

  void updateTherapy(Map<String, dynamic> data) async {
    final result = await _apisNew.updateTherapy(data);
    getTherapies({
      'user_id': data['user_id'],
      'pharmacy_id': data['pharmacy_id'],
    });
    getNextPills({
      'pharmacy_id': data['pharmacy_id'],
      'user_id': data['user_id'],
      'page_number': 0,
    });
  }

  Future<dynamic> createTherapy(Map<String, dynamic> data) async {
    final result = await _apisNew.createTherapy(data);
    getTherapies({
      'pharmacy_id': data['pharmacy_id'],
      'user_id': data['user_id'],
    });
    getNextPills({
      'pharmacy_id': data['pharmacy_id'],
      'user_id': data['user_id'],
      'page_number': 0,
    });
    return result.statusCode;
  }

  ///PILLS

  Future<dynamic> getNextPills(Map<String, dynamic> data) async {
    final result = await _apisNew.getNextPills(data);
    result.sort((a, b) {
      //sorting in descending order
      return DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!));
    });
    nextPills = result;
    notifyListeners();
  }

  Future<dynamic> changeHourForPill(Map<String, dynamic> data) async {
    final result = await _apisNew.changeHourForPill(data);
    getNextPills({
      'user_id': data['user_id'],
      'page_number': 0,
    });
  }

  Future<dynamic> takePill(Map<String, dynamic> data) async {
    final result = await _apisNew.takePill(data);
    getNextPills({
      'user_id': data['user_id'],
      'page_number': 0,
    });
  }

  Future<dynamic> skipPill(Map<String, dynamic> data) async {
    final result = await _apisNew.skipPill(data);
    getNextPills({
      'user_id': data['user_id'],
      'page_number': 0,
    });
  }

  Future<List<dynamic>> fetchMorePills(Map<String, dynamic> data) async {
    final result = await _apisNew.getNextPills(data);
    nextPills?.addAll(result);
    notifyListeners();
    return result;
  }
}
