class Event {
  int? id;
  String? eventName;
  String? bookingRequired;
  String? eventDescription;
  String? date;
  String? fromTime;
  String? pharmacyEvents;
  String? eventToDate;
  String? toTime;
  String? goingMemberCount;
  int? pendingMemberCount;
  String? address;
  String? price;
  String? image;

  Event(
      {this.id,
      this.eventName,
      this.bookingRequired,
      this.eventDescription,
      this.date,
      this.fromTime,
      this.pharmacyEvents,
      this.eventToDate,
      this.toTime,
      this.goingMemberCount,
      this.pendingMemberCount,
      this.address,
      this.price,
      this.image});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventName = json['event_name'];
    bookingRequired = json['booking_required'];
    eventDescription = json['event_description'];
    date = json['date'];
    fromTime = json['from_time'];
    pharmacyEvents = json['pharmacy_events'];
    eventToDate = json['event_to_date'];
    toTime = json['to_time'];
    goingMemberCount = json['going_member_count'];
    pendingMemberCount = json['pending_member_count'];
    address = json['address'];
    price = json['price'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['event_name'] = eventName;
    data['booking_required'] = bookingRequired;
    data['event_description'] = eventDescription;
    data['date'] = date;
    data['from_time'] = fromTime;
    data['pharmacy_events'] = pharmacyEvents;
    data['event_to_date'] = eventToDate;
    data['to_time'] = toTime;
    data['going_member_count'] = goingMemberCount;
    data['pending_member_count'] = pendingMemberCount;
    data['address'] = address;
    data['price'] = price;
    data['image'] = image;
    return data;
  }
}
