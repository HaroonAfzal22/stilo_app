class ProductDetail {
  int id;
  String productName;
  String isGultan;
  String? isPromotional;
  String? productDescription;
  String? productTherapeuticIndicationsText;
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
  String? productPriceVat;
  String? instruction;
  String? warning;
  String? productType;
  String? category;
  String? productCategoryId;
  String? code;
  String? forRent;
  String? period;
  String? minPeriod;
  String? instructionFile;
  String? producer;
  double? productPrice;
  double? promotionalPrice;
  double? productDisplayPrice;
  String? pricePeriod;
  List<dynamic>? productImage;
  String? scheda;
  String? productGmpCategory;

  ProductDetail({
    required this.id,
    required this.productName,
    required this.isGultan,
    required this.isPromotional,
    this.productDescription,
    this.productTherapeuticIndicationsText,
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
    this.productPriceVat,
    this.instruction,
    this.warning,
    this.productType,
    this.category,
    this.productCategoryId,
    this.code,
    this.forRent,
    this.period,
    this.minPeriod,
    this.instructionFile,
    this.producer,
    this.productPrice,
    this.productDisplayPrice,
    this.pricePeriod,
    this.productImage,
    this.scheda,
    this.productGmpCategory,
    this.promotionalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'isGultan': isGultan,
      'isPromotional': isPromotional,
      'productDescription': productDescription,
      'productTherapeuticIndicationsText': productTherapeuticIndicationsText,
      'productActivePrincipleText': productActivePrincipleText,
      'productDosageText': productDosageText,
      'productWarningsText': productWarningsText,
      'productContraindicationsText': productContraindicationsText,
      'productUndesirableEffectsText': productUndesirableEffectsText,
      'productOverdoseText': productOverdoseText,
      'productExcipientsText': productExcipientsText,
      'productPregnancyFeedingTimeText': productPregnancyFeedingTimeText,
      'manufacturerTitle': manufacturerTitle,
      'productCode': productCode,
      'requiresPrescription': requiresPrescription,
      'productTypeTitle': productTypeTitle,
      'productPrescriptionTypeDetails': productPrescriptionTypeDetails,
      'productPriceVat': productPriceVat,
      'instruction': instruction,
      'warning': warning,
      'productType': productType,
      'category': category,
      'productCategoryId': productCategoryId,
      'code': code,
      'forRent': forRent,
      'period': period,
      'minPeriod': minPeriod,
      'instructionFile': instructionFile,
      'producer': producer,
      'productPrice': productPrice,
      'productDisplayPrice': productDisplayPrice,
      'pricePeriod': pricePeriod,
      'productImage': productImage,
      'productGmpCategory': productGmpCategory
    };
  }

  List<Map<String, dynamic>> get images {
    List<Map<String, dynamic>> res = [];
    if (productImage == null || productImage != null && productImage!.isEmpty) {
      return res;
    }
    if (productImage != null && productImage!.isNotEmpty) {
      res.add(productImage![0]);
    }
    return res;
  }

  List<Map<String, dynamic>> get firstSection {
    List<Map<String, dynamic>> res = [];
    if (productTherapeuticIndicationsText != null &&
        productTherapeuticIndicationsText!.isNotEmpty) {
      res.add({
        'title': 'Instruction_to_use',
        'description': productTherapeuticIndicationsText
      });
    }
    if (productDosageText != null && productDosageText!.isNotEmpty) {
      res.add({'title': 'dosage', 'description': productDosageText});
    }

    return res;
  }

  List<Map<String, dynamic>> get secondSection {
    List<Map<String, dynamic>> resSecond = [];
    if (productWarningsText != null && productWarningsText!.isNotEmpty) {
      resSecond.add({'title': 'warning', 'description': productWarningsText});
    }
    if (productContraindicationsText != null &&
        productContraindicationsText!.isNotEmpty) {
      resSecond.add({
        'title': 'contraindications',
        'description': productContraindicationsText
      });
    }
    if (productUndesirableEffectsText != null &&
        productUndesirableEffectsText!.isNotEmpty) {
      resSecond.add({
        'title': 'undesirable_effects',
        'description': productUndesirableEffectsText
      });
    }
    if (productOverdoseText != null && productOverdoseText!.isNotEmpty) {
      resSecond.add({'title': 'overdose', 'description': productOverdoseText});
    }
    return resSecond;
  }

  List<Map<String, dynamic>> get thirdSection {
    List<Map<String, dynamic>> resThird = [];
    if (productExcipientsText != null && productExcipientsText!.isNotEmpty) {
      resThird
          .add({'title': 'excipients', 'description': productExcipientsText});
    }
    if (productActivePrincipleText != null &&
        productActivePrincipleText!.isNotEmpty) {
      resThird.add({
        'title': 'active_principle',
        'description': productActivePrincipleText
      });
    }
    return resThird;
  }

  List<Map<String, dynamic>> get fourthSection {
    List<Map<String, dynamic>> resfourth = [];
    if (productPregnancyFeedingTimeText != null &&
        productPregnancyFeedingTimeText!.isNotEmpty) {
      resfourth.add({
        'title': 'pregnancy_feeding_time',
        'description': productPregnancyFeedingTimeText
      });
    }
    return resfourth;
  }

  factory ProductDetail.fromMap(Map<String, dynamic> map) {
    return ProductDetail(
      id: map['id'] as int,
      productName: map['product_name'] as String,
      isGultan: map['is_gultan'],
      isPromotional: map['is_promational'],
      productDescription: map['product_description'],
      productTherapeuticIndicationsText:
          map['product_terapeutic_indications_text'],
      productActivePrincipleText: map['product_active_principle_text'],
      productDosageText: map['product_dosage_text'],
      productWarningsText: map['product_warnings_text'],
      productContraindicationsText: map['product_contraindications_text'],
      productUndesirableEffectsText: map['product_undesirable_effects_text'],
      productOverdoseText: map['product_overdose_text'],
      productExcipientsText: map['product_excipients_text'],
      productPregnancyFeedingTimeText:
          map['product_pregnancy_feeding_time_text'],
      manufacturerTitle: map['manufacturer_title'],
      productCode: map['product_code'],
      requiresPrescription: map['requires_prescription'],
      productTypeTitle: map['product_type_title'],
      productPrescriptionTypeDetails: map['product_prescription_type_details'],
      productPriceVat: map['product_price_vat'],
      instruction: map['instruction'],
      warning: map['warning'],
      productType: map['product_type'],
      category: map['category'],
      productCategoryId: map['product_category_id'],
      code: map['code'],
      forRent: map['for_rent'],
      period: map['period'],
      minPeriod: map['min_period'],
      instructionFile: map['instruction_file'],
      producer: map['producer'],
      productPrice: double.tryParse(map['product_price']?.replaceAll(',', '.')),
      promotionalPrice:
          double.tryParse(map['promotional_price']?.replaceAll(',', '.') ?? ""),
      productDisplayPrice: double.tryParse(map['product_display_price']),
      pricePeriod: map['price_period'],
      productImage: map['prodcut_image'],
      scheda: map['scheda'],
      productGmpCategory: map['product_gmp_category'],
    );
  }
}
