import 'package:intl/intl.dart';

class Therapy {
  final int id;
  final String? pharmacyId;
  final String product;
  final String? productImage;
  final String? description;
  final String medicineFrequency;
  final String? qty;
  final String? duration;
  final String? asWhatTime;
  final String startDate;
  final String endDate;
  final String whenToTake;
  final String? note;
  final String availableQty;
  final String? availableNotice;
  final String? numberAviso;
  final String? status;

  //final String? type????

  //final String drug;
  //final String frequency;
  //final int nPills;
  //final int? nSachets;
  //final int? mlSpoon;
  //TODO prima-dopo-durante pasti
  //final String? whenToTake;
  //final String type;
  //final String? notes;

  const Therapy({
    required this.id,
    required this.pharmacyId,
    required this.product,
    this.productImage,
    required this.description,
    required this.medicineFrequency,
    required this.qty,
    required this.duration,
    required this.asWhatTime,
    required this.startDate,
    required this.endDate,
    required this.whenToTake,
    this.note,
    required this.availableQty,
    this.availableNotice,
    this.numberAviso,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pharmacy_id': pharmacyId,
      'product': product,
      'description': description,
      'medicine_fequency': medicineFrequency.toString(),
      'qty': qty,
      'duration': duration.toString(),
      'as_what_time': asWhatTime.toString(),
      'start_date': startDate,
      'end_date': endDate,
      'when_take': whenToTake,
      'note': note,
      'available_qty': availableQty.toString(),
      'available_notice': availableNotice.toString(),
      'number_aviso': numberAviso.toString(),
      'status': status,
    };
  }

  factory Therapy.fromMap(Map<String, dynamic> map) {
    return Therapy(
      id: map['id'],
      pharmacyId: map['pharmacy_id'],
      product: map['product'],
      description: map['description'],
      medicineFrequency: map['medicine_fequency'],
      productImage: map['product_image'],
      qty: map['qty'],
      duration: map['duration'],
      asWhatTime: map['as_what_time'],
      startDate: map['start_date'],
      endDate: map['end_date'],
      whenToTake: map['when_take'],
      note: map['note'],
      availableQty: map['available_qty'],
      availableNotice: map['available_notice'],
      numberAviso: map['number_aviso'],
      status: map['status'],
    );
  }
}
