class Address {
  String? userId;
  int? id;
  String? addressType;
  String? name;
  String? address;
  String? province;
  String? region;
  String? country;
  String? cap;

  Address(
      {this.userId,
      this.id,
      this.addressType,
      this.name,
      this.address,
      this.province,
      this.region,
      this.country,
      this.cap});

  Address.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    id = json['id'];
    addressType = json['address_type'];
    name = json['name'];
    address = json['address'];
    province = json['province'];
    region = json['region'];
    country = json['country'];
    cap = json['cap'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['id'] = id;
    data['address_type'] = addressType;
    data['name'] = name;
    data['address'] = address;
    data['province'] = province;
    data['region'] = region;
    data['country'] = country;
    data['cap'] = cap;
    return data;
  }
}
