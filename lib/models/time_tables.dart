class TimeTables {
  int? id;
  String? pharmacyContactNo;
  String? pharmacyAddress1;
  String? pharmacyAddress2;
  String? pharmacyMessage;
  String? bannerImage;
  // String? contactDetailAddress;
  // String? addressPharmacy;
  // String? contactDetailPhone;
  List<Hours>? hours;

  TimeTables(
      {this.id,
      this.pharmacyContactNo,
      this.pharmacyAddress1,
      this.pharmacyAddress2,
      this.pharmacyMessage,
      this.bannerImage,
      // this.contactDetailAddress,
      // this.addressPharmacy,
      // this.contactDetailPhone,
      this.hours});

  TimeTables.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pharmacyContactNo = json['pharmacy_contact_no'];
    pharmacyAddress1 = json['pharmacy_address1'];
    pharmacyAddress2 = json['pharmacy_address2'];
    pharmacyMessage = json['pharamcy_message'];
    bannerImage = json['banner_image'];
    // contactDetailAddress = json['contact_detail_address'];
    // addressPharmacy = json['addresspharmacy'];
    // contactDetailPhone = json['contact_detail_phone'];
    if (json['Orario'] != null) {
      hours = <Hours>[];
      json['Orario'].forEach((v) {
        hours!.add(Hours.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pharmacy_contact_no'] = pharmacyContactNo;
    data['pharmacy_address1'] = pharmacyAddress1;
    data['pharmacy_address2'] = pharmacyAddress2;
    data['pharamcy_message'] = pharmacyMessage;
    data['banner_image'] = bannerImage;
    // data['contact_detail_address'] = contactDetailAddress;
    // data['addresspharmacy'] = addressPharmacy;
    // data['contact_detail_phone'] = contactDetailPhone;
    if (hours != null) {
      data['Orario'] = hours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hours {
  String? mon;
  String? status;
  String? morningHoursOpen;
  String? morningHoursClose;
  String? eveningHoursOpen;
  String? eveningHoursClose;
  String? tue;
  String? wed;
  String? thu;
  String? fri;
  String? sat;
  String? sun;

  Hours(
      {this.mon,
      this.status,
      this.morningHoursOpen,
      this.morningHoursClose,
      this.eveningHoursOpen,
      this.eveningHoursClose,
      this.tue,
      this.wed,
      this.thu,
      this.fri,
      this.sat,
      this.sun});

  Hours.fromJson(Map<String, dynamic> json) {
    mon = json['mon'];
    status = json['status'];
    morningHoursOpen = json['morning_hours_open'];
    morningHoursClose = json['morning_hours_close'];
    eveningHoursOpen = json['evening_hours_open'];
    eveningHoursClose = json['evening_hours_close'];
    tue = json['tue'];
    wed = json['wed'];
    thu = json['thu'];
    fri = json['fri'];
    sat = json['sat'];
    sun = json['sun'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mon'] = mon;
    data['status'] = status;
    data['morning_hours_open'] = morningHoursOpen;
    data['morning_hours_close'] = morningHoursClose;
    data['evening_hours_open'] = eveningHoursOpen;
    data['evening_hours_close'] = eveningHoursClose;
    data['tue'] = tue;
    data['wed'] = wed;
    data['thu'] = thu;
    data['fri'] = fri;
    data['sat'] = sat;
    data['sun'] = sun;
    return data;
  }
}
