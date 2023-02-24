class News {
  int? id;
  String? title;
  String? shortDescription;
  String? description;
  String? date;
  String? image;
  String? readingTime;

  News(
      {this.id,
      this.title,
      this.shortDescription,
      this.description,
      this.date,
      this.image,
      this.readingTime});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    shortDescription = json['short_description'];
    description = json['description'];
    date = json['date'];
    image = json['image'];
    readingTime = json['reading_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['short_description'] = shortDescription;
    data['description'] = description;
    data['date'] = date;
    data['image'] = image;
    data['reading_time'] = readingTime;
    return data;
  }
}