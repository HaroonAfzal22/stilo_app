class PharmaNotification {
  final int? id;
  final String title;
  final String body;
  final String? read;
  final String? longDesc;
  final String type;
  final String? itemID;

  const PharmaNotification({
    this.id,
    required this.read,
    required this.title,
    required this.body,
    this.longDesc,
    required this.type,
    this.itemID,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'read': read,
      'longDesc': longDesc,
      'type': type,
    };
  }

  factory PharmaNotification.fromMap(Map<String, dynamic> map) {
    return PharmaNotification(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      read: map['read'],
      longDesc: map['longDesc'],
      type: map['type'],
      itemID: map['item_id'],
    );
  }
}
