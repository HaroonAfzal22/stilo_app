class GlutenFreeCategory {
  int? id;
  String? title;
  String? image;

  GlutenFreeCategory({this.id, this.title, this.image});

  GlutenFreeCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    return data;
  }
}

