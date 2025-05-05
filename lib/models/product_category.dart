// To parse this JSON data, do
//
//     final productCategory = productCategoryFromJson(jsonString);

import 'dart:convert';

ProductCategory productCategoryFromJson(String str) =>
    ProductCategory.fromJson(json.decode(str));

String productCategoryToJson(ProductCategory data) =>
    json.encode(data.toJson());

class ProductCategory {
  ProductCategory(
      {required this.id,
      required this.categoryId,
      required this.name,
      required this.photo,
      this.vendorType});
  VendorTypeChecker? vendorType;
  int id;
  int? categoryId;
  String name;
  String photo;

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
          id: json["id"] == null ? null : json["id"],
          categoryId: json["category_id"] == null ? null : json["category_id"],
          name: json["name"] == null ? null : json["name"],
          photo: json["photo"] == null ? null : json["photo"],
          vendorType: json['vendor_type'] != null
              ? new VendorTypeChecker.fromJson(json['vendor_type'])
              : null
          // vendorType = ;
          );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "photo": photo,
        "vendor_type": vendorType
      };
}

class VendorTypeChecker {
  int? id;
  String? name;
  String? color;
  String? description;
  String? slug;
  int? isActive;
  int? inOrder;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? formattedDate;
  String? logo;
  String? websiteHeader;
  int? hasBanners;

  VendorTypeChecker(
      {this.id,
      this.name,
      this.color,
      this.description,
      this.slug,
      this.isActive,
      this.inOrder,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.formattedDate,
      this.logo,
      this.websiteHeader,
      this.hasBanners});

  VendorTypeChecker.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
    description = json['description'];
    slug = json['slug'];
    isActive = json['is_active'];
    inOrder = json['in_order'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    formattedDate = json['formatted_date'];
    logo = json['logo'];
    websiteHeader = json['website_header'];
    hasBanners = json['has_banners'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['color'] = this.color;
    data['description'] = this.description;
    data['slug'] = this.slug;
    data['is_active'] = this.isActive;
    data['in_order'] = this.inOrder;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['formatted_date'] = this.formattedDate;
    data['logo'] = this.logo;
    data['website_header'] = this.websiteHeader;
    data['has_banners'] = this.hasBanners;
    return data;
  }
}
