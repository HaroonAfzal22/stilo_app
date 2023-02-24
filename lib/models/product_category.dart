class ProductCategoryResponse {
  List<ProductCategory>? productCategories;

  ProductCategoryResponse({this.productCategories});

  ProductCategoryResponse.fromJson(Map<String, dynamic> json) {
    List<ProductCategory> tempList = [];
    for (var cat in json.values) {
      ProductCategory tempProdCat = ProductCategory.fromJson(cat);
      tempList.add(tempProdCat);
    }
    productCategories = tempList;
  }
}

class ProductCategory {
  String? id;
  String? title;
  List<SubCategory>? subCategories;

  ProductCategory({
    this.id,
    this.title,
    this.subCategories,
  });

  ProductCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    Map<String, dynamic> subCatJson = json['subcategories'];

    List<SubCategory>? tempSubCatList = [];
    for (var subCat in subCatJson.values) {
      SubCategory tempSubCat = SubCategory.fromJson(subCat);
      tempSubCatList.add(tempSubCat);
    }
    subCategories = tempSubCatList;
  }
}

class SubCategory {
  String? id;
  String? title;
  String? productGmpCategory;

  SubCategory({this.id, this.title, this.productGmpCategory});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id_subcategory'];
    title = json['title'];
    productGmpCategory = json['product_gmp_category'];
  }
}
