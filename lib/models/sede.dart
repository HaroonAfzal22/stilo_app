class Site {
  final int id;
  final String name;
  final String address;
  final String? province;
  final String? cap;
  final String? city;

  const Site({
    required this.id,
    required this.address,
    required this.name,
    this.city,
    this.province,
    this.cap,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'cap': cap,
      'province': province,
      'city': city,
    };
  }

  factory Site.fromMap(Map<String, dynamic> map) {
    return Site(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      cap: map['cap'],
      province: map['province'],
      city: map['city'],
    );
  }
}
