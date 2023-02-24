class Rental {
  int? id;
  String? reservationId;
  String? name;
  String? description;
  String? price;
  String? productTerapeuticIndicationsText;
  String? productActivePrincipleText;
  String? productDosageText;
  String? productWarningsText;
  String? productContraindicationsText;
  String? productUndesirableEffectsText;
  String? productOverdoseText;
  String? productExcipientsText;
  String? productPregnancyFeedingTimeText;
  String? manufacturerTitle;
  String? productCode;
  String? requiresPrescription;
  String? productTypeTitle;
  String? productPrescriptionTypeDetails;
  String? productCategoryId;
  String? productPriceVat;
  List<RentalImages>? image;
  String? startDate;
  String? endDate;
  //todo aggiungere questi campi alla risposta dal backend
  int? duration;
  String? period;
  // payment
  // shippingType
  //shipmentAddress
  // couponId
  // total

  Rental(
      {this.id,
      this.reservationId,
      this.name,
      this.description,
      this.price,
      this.productTerapeuticIndicationsText,
      this.productActivePrincipleText,
      this.productDosageText,
      this.productWarningsText,
      this.productContraindicationsText,
      this.productUndesirableEffectsText,
      this.productOverdoseText,
      this.productExcipientsText,
      this.productPregnancyFeedingTimeText,
      this.manufacturerTitle,
      this.productCode,
      this.requiresPrescription,
      this.productTypeTitle,
      this.productPrescriptionTypeDetails,
      this.productCategoryId,
      this.productPriceVat,
      this.image,
      this.startDate,
      this.endDate,
      this.duration,
      this.period});

  Rental.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reservationId = json['reservation_id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    productTerapeuticIndicationsText =
        json['product_terapeutic_indications_text'];
    productActivePrincipleText = json['product_active_principle_text'];
    productDosageText = json['product_dosage_text'];
    productWarningsText = json['product_warnings_text'];
    productContraindicationsText = json['product_contraindications_text'];
    productUndesirableEffectsText = json['product_undesirable_effects_text'];
    productOverdoseText = json['product_overdose_text'];
    productExcipientsText = json['product_excipients_text'];
    productPregnancyFeedingTimeText =
        json['product_pregnancy_feeding_time_text'];
    manufacturerTitle = json['manufacturer_title'];
    productCode = json['product_code'];
    requiresPrescription = json['requires_prescription'];
    productTypeTitle = json['product_type_title'];
    productPrescriptionTypeDetails = json['product_prescription_type_details'];
    productCategoryId = json['product_category_id'];
    productPriceVat = json['product_price_vat'];
    if (json['image'] != String) {
      image = <RentalImages>[];
      json['image'].forEach((v) {
        image!.add(RentalImages.fromJson(v));
      });
    }
    startDate = json['start_date'];
    endDate = json['end_date'];
    duration = json['duration'];
    period = json['period'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['reservation_id'] = reservationId;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['product_terapeutic_indications_text'] =
        productTerapeuticIndicationsText;
    data['product_active_principle_text'] = productActivePrincipleText;
    data['product_dosage_text'] = productDosageText;
    data['product_warnings_text'] = productWarningsText;
    data['product_contraindications_text'] = productContraindicationsText;
    data['product_undesirable_effects_text'] = productUndesirableEffectsText;
    data['product_overdose_text'] = productOverdoseText;
    data['product_excipients_text'] = productExcipientsText;
    data['product_pregnancy_feeding_time_text'] =
        productPregnancyFeedingTimeText;
    data['manufacturer_title'] = manufacturerTitle;
    data['product_code'] = productCode;
    data['requires_prescription'] = requiresPrescription;
    data['product_type_title'] = productTypeTitle;
    data['product_prescription_type_details'] = productPrescriptionTypeDetails;
    data['product_category_id'] = productCategoryId;
    data['product_price_vat'] = productPriceVat;
    if (this.image != String) {
      data['image'] = this.image!.map((v) => v.toJson()).toList();
    }
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['duration'] = duration;
    data['period'] = period;
    return data;
  }
}

class RentalImages {
  int? id;
  String? imageUrl;

  RentalImages({this.id, this.imageUrl});

  RentalImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['image_url'] = imageUrl;
    return data;
  }
}
