class MedCabItem {
  final int? id;
  final String? name;
  final String? expirationDate;
  final dynamic qty;
  final String? notes;
  final dynamic limit;
  final dynamic productId;

  MedCabItem({
    this.id,
    this.name,
    this.qty,
    this.expirationDate,
    this.notes,
    this.limit,
    this.productId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'expirationDate': expirationDate,
      'qty': qty,
      'notes': notes,
      'limit': limit,
      'productId': productId,
    };
  }

  factory MedCabItem.fromMap(Map<String, dynamic> map) {
    return MedCabItem(
      id: map['id'],
      name: map['name'],
      expirationDate: map['expirationDate'],
      qty: map['qty'],
      notes: map['notes'],
      limit: map['limit'],
      productId: map['productId'],
    );
  }
}
