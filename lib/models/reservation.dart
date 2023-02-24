class Reservation {
  int id;
  String title;
  String? category;
  String? appointmentType;
  String? service;
  String? event;
  String? price;
  String date;
  String? slotId;
  String startTime;
  String endTime;
  String address;
  String? reservationDate;
  String? couponName;
  String? couponDiscount;
  String? number;
  String? phone;
  String? status;

  Reservation({
    required this.id,
    required this.title,
    this.category,
    this.appointmentType,
    this.service,
    this.event,
    this.price,
    required this.date,
    this.slotId,
    required this.startTime,
    required this.endTime,
    required this.address,
    this.reservationDate,
    this.couponName,
    this.couponDiscount,
    this.number,
    this.phone,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'appointmentType': appointmentType,
      'service': service,
      'event': event,
      'price': price,
      'date': date,
      'slotId': slotId,
      'startTime': startTime,
      'endTime': endTime,
      'address': address,
      'reservationDate': reservationDate,
      'couponName': couponName,
      'couponDiscount': couponDiscount,
      'number': number,
      'phone': phone,
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'] as int,
      title: map['title'] as String,
      category: map['category'],
      appointmentType: map['appointmentType'],
      service: map['service'],
      event: map['event'] as String,
      price: map['price'] as String,
      date: map['date'] as String,
      slotId: map['slote_id'],
      startTime: map['start_time'] as String,
      endTime: map['end_time'] as String,
      address: map['address'] as String,
      reservationDate: map['reservationDate'],
      couponName: map['coupon_name'],
      couponDiscount: map['coupan_discount'],
      number: map['number'] as String,
      phone: map['phone'] as String,
      status: map['status'],
    );
  }
}
