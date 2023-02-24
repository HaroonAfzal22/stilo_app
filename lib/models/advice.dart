class Advice {
  int? id;
  String? title;
  String? description;
  String? image;
  String? date;
  String? time;
    
  Advice(
      {this.id,
      this.title,
      this.description,
      this.image,
      this.date,
      this.time});

  Advice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['date'] = date;
    data['time'] = time;
    return data;
  }
}