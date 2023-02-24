import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serviceBookingProvider = ChangeNotifierProvider(
  (ref) => ServiceBookingProvider(),
);

class ServiceBookingProvider extends ChangeNotifier {
  dynamic selectedDateIndex;
  int? selectedSlotIndex;
  dynamic selectedService;

  void selectDate(dynamic selectedDate) {
    selectedDateIndex = selectedDate;
    notifyListeners();
  }

  void selectSlot(dynamic selectedSlot) {
    selectedSlotIndex = selectedSlot;
    notifyListeners();
  }
}
