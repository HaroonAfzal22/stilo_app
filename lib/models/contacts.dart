class Contact {
  int? id;
  String? address;
  String? email;
  String? phone;
  String? whatsapp;
  String? facebookLink;
  String? instagramLink;
  String? mondayFriday;
  String? saturday;
  String? sunday;
  

  Contact(
      {this.id,
      this.address,
      this.email,
      this.phone,
      this.whatsapp,
      this.facebookLink,
      this.instagramLink,
      this.mondayFriday,
      this.saturday,
      this.sunday});

  Contact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    email = json['email'];
    phone = json['phone'];
    whatsapp = json['whatsapp'];
    facebookLink = json['facebook_link'];
    instagramLink = json['instagram_link'];
    mondayFriday = json['monday_friday'];
    saturday = json['saturday'];
    sunday = json['sunday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['whatsapp'] = this.whatsapp;
    data['facebook_link'] = this.facebookLink;
    data['instagram_link'] = this.instagramLink;
    data['monday_friday'] = this.mondayFriday;
    data['saturday'] = this.saturday;
    data['sunday'] = this.sunday;
    return data;
  }
}

