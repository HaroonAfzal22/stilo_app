class User {
  int? userId;
  String? firstName;
  String? lastName;
  String? emailNotifications;
  String? emailNewsUpdates;
  String? bookingNotifications;
  String? stockNotifications;
  String? pharmacyTherapies;
  String? therapyNotification;
  String? therapyAdd;
  String? isNotification;
  String? email;
  String? city;
  String? customerCode;
  String? dateOfBirth;
  String? gender;
  String? country;
  String? postalCode;
  String? qrCode;
  String? contactNumber;
  String? streetNumber;
  String? address;
  String? createdDate;
  String? termsAccepted;
  String? privacyAccepted;
  String? promoAccepted;
  String? province;
  int? wpId;

  User({
    this.userId,
    this.firstName,
    this.lastName,
    this.emailNotifications,
    this.emailNewsUpdates,
    this.bookingNotifications,
    this.stockNotifications,
    this.pharmacyTherapies,
    this.therapyNotification,
    this.therapyAdd,
    this.isNotification,
    this.email,
    this.city,
    this.customerCode,
    this.dateOfBirth,
    this.gender,
    this.country,
    this.postalCode,
    this.qrCode,
    this.contactNumber,
    this.streetNumber,
    this.address,
    this.createdDate,
    this.termsAccepted,
    this.privacyAccepted,
    this.promoAccepted,
    this.province,
    this.wpId,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    emailNotifications = json['email_notifications'];
    emailNewsUpdates = json['email_news_updates'];
    bookingNotifications = json['booking_notifications'];
    stockNotifications = json['stock_notifications'];
    pharmacyTherapies = json['Pharmacy_therapies'];
    therapyNotification = json['therapy_notification'];
    therapyAdd = json['therapy_add'];
    isNotification = json['is_notification'];
    email = json['email'];
    city = json['city'];
    customerCode = json['customer_code'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    country = json['country'];
    postalCode = json['postal_code'];
    qrCode = json['qr_code'];
    contactNumber = json['contact_number'];
    streetNumber = json['street_number'];
    address = json['address'];
    createdDate = json['created_date'];
    termsAccepted = json['terms_accepted'];
    privacyAccepted = json['privacy_accepted'];
    promoAccepted = json['promo_accepted'];
    province = json['province'];
    wpId = int.tryParse(json['wp_id'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email_notifications'] = emailNotifications;
    data['email_news_updates'] = emailNewsUpdates;
    data['booking_notifications'] = bookingNotifications;
    data['stock_notifications'] = stockNotifications;
    data['Pharmacy_therapies'] = pharmacyTherapies;
    data['therapy_notification'] = therapyNotification;
    data['therapy_add'] = therapyAdd;
    data['is_notification'] = isNotification;
    data['email'] = email;
    data['city'] = city;
    data['customer_code'] = customerCode;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['country'] = country;
    data['postal_code'] = postalCode;
    data['qr_code'] = qrCode;
    data['contact_number'] = contactNumber;
    data['street_number'] = streetNumber;
    data['address'] = address;
    data['created_date'] = createdDate;
    data['terms_accepted'] = termsAccepted;
    data['privacy_accepted'] = privacyAccepted;
    data['promo_accepted'] = promoAccepted;
    data['province'] = province;
    data['wp_id'] = wpId;
    return data;
  }
}
