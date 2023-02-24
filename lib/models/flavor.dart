import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final flavorProvider = Provider<Flavor>((ref) => throw UnimplementedError());

class Flavor {
  Flavor({
    required this.pharmacyId,
    required this.pharmacyName,
    this.isParapharmacy = false,
    required this.primary,
    required this.lightPrimary,
    this.sendReceiptEnabled = true,
    this.hasConventions = true,
    this.hasCovid19 = true,
    this.hasAdvices = true,
    this.hasGalenic = true,
    this.hasGlutenFree = true,
    this.hasMomChild = true,
    this.hasVeterinary = true,
    this.hasAesthetic = true,
    this.hasAnalysis = true,
    this.hasEvents = true,
    this.hasDigitalFlyer = true,
    this.hasNews = true,
    this.hasOffers = true,
    this.farmaciediturnoCode,
    this.hasElectronicReceipt = true,
    this.redRecipes,
    this.qrLink,
  });

  final int pharmacyId;
  final String pharmacyName;
  final bool isParapharmacy;
  final Color primary;
  final Color lightPrimary;
  final bool sendReceiptEnabled;
  final bool hasConventions;
  final bool hasCovid19;
  final bool hasAdvices;
  final bool hasGalenic;
  final bool hasGlutenFree;
  final bool hasMomChild;
  final bool hasVeterinary;
  final bool hasAesthetic;
  final bool hasAnalysis;
  final bool hasEvents;
  final bool hasDigitalFlyer;
  final bool hasNews;
  final bool hasOffers;
  final String? farmaciediturnoCode;
  final String? qrLink;

  ///temp
  final bool hasElectronicReceipt;
  final String? redRecipes;
}
