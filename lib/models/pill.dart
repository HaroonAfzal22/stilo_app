class Pill {
  int? id;
  //TODO fix types
  dynamic pillId;
  dynamic therapyId;
  String? status;
  String? date;
  String? hour;
  String? whenTaken;
  String? photoUrl;
  String? productName;
  String? qty;
  String? qtyUnit;

  Pill({
    this.id,
    this.pillId,
    this.therapyId,
    this.status,
    this.date,
    this.hour,
    this.whenTaken,
    this.photoUrl,
    this.productName,
    this.qty,
    this.qtyUnit,
  });

  Pill.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pillId = json['pill_id'];
    therapyId = json['therapy_id'];
    status = json['status'];
    date = json['date'];
    hour = json['hour'];
    whenTaken = json['when_taken'];
    photoUrl = json['product_image'];
    productName = json['product_name'];
    qty = json['qty'];
    qtyUnit = json['qty_unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pill_id'] = pillId;
    data['therapy_id'] = therapyId;
    data['status'] = status;
    data['date'] = date;
    data['hour'] = hour;
    data['when_taken'] = whenTaken;

    return data;
  }
}
