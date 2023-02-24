class PharmaDocument {
  int? id;
  String? documentImage;
  String? sharePharmacy;
  String? isAddedByPharmacy;

  PharmaDocument(
      {this.id,
      this.documentImage,
      this.sharePharmacy,
      this.isAddedByPharmacy});

  PharmaDocument.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    documentImage = json['document_image'];
    sharePharmacy = json['share_pharmacy'];
    isAddedByPharmacy = json['is_added_by_pharmacy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['document_image'] = this.documentImage;
    data['share_pharmacy'] = this.sharePharmacy;
    data['is_added_by_pharmacy'] = this.isAddedByPharmacy;
    return data;
  }
}