import 'dart:convert';

ProductListModel productListModelFromJson(String str) => ProductListModel.fromJson(json.decode(str));

String productListModelToJson(ProductListModel data) => json.encode(data.toJson());

class ProductListModel {
  final bool status;
  final int code;
  final String message;
  final List<Product> data;

  ProductListModel({
    this.status = false,
    this.code = 0,
    this.message = "",
    this.data = const [],
  });

  factory ProductListModel.fromJson(Map<String, dynamic> json) => ProductListModel(
        status: json["status"] ?? false,
        code: json["code"] ?? 0,
        message: json["message"] ?? "",
        data: json["data"] != null
            ? List<Product>.from(json["data"].map((x) => Product.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Product {
  final int id;
  final String title;
  final String watt;
  final String color;
  final String price;
  final String redeem;
  final String specification;
  final List<String> images;
  final int categoryId;
  final Category category;
  final String coverPhoto;

  Product({
    this.id = 0,
    this.title = "",
    this.watt = "",
    this.color = "",
    this.price = "0",
    this.redeem = "0",
    this.specification = "",
    this.images = const [],
    this.categoryId = 0,
    Category? category,
    this.coverPhoto = "",
  }) : category = category ?? Category();

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"] ?? 0,
        title: json["title"] ?? "",
        watt: json["watt"] ?? "",
        color: json["color"] ?? "",
        price: json["price"] ?? "0",
        redeem: json["redeem"] ?? "0",
        specification: json["specification"] ?? "",
        images: json["images"] != null ? List<String>.from(json["images"].map((x) => x)) : [],
        categoryId: json["category_id"] ?? 0,
        category: json["category"] != null ? Category.fromJson(json["category"]) : Category(),
        coverPhoto: json["cover_photo"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "watt": watt,
        "color": color,
        "price": price,
        "redeem": redeem,
        "specification": specification,
        "images": List<dynamic>.from(images.map((x) => x)),
        "category_id": categoryId,
        "category": category.toJson(),
        "cover_photo": coverPhoto,
      };
}

class Category {
  final int id;
  final String name;
  final String description;

  Category({
    this.id = 0,
    this.name = "",
    this.description = "",
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        description: json["description"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
      };
}
