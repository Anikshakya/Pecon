// To parse this JSON data, do
//
//     final productListModel = productListModelFromJson(jsonString);

import 'dart:convert';

ProductListModel productListModelFromJson(String str) => ProductListModel.fromJson(json.decode(str));

String productListModelToJson(ProductListModel data) => json.encode(data.toJson());

class ProductListModel {
    bool? status;
    int? code;
    String? message;
    List<Datum>? data;

    ProductListModel({
        this.status,
        this.code,
        this.message,
        this.data,
    });

    factory ProductListModel.fromJson(Map<String, dynamic> json) => ProductListModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? title;
    String? watt;
    String? color;
    String? price;
    String? redeem;
    String? specification;
    List<String>? images;
    int? categoryId;

    Datum({
        this.id,
        this.title,
        this.watt,
        this.color,
        this.price,
        this.redeem,
        this.specification,
        this.images,
        this.categoryId,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"] ?? "",
        watt: json["watt"] ?? "",
        color: json["color"] ?? "",
        price: json["price"] ?? "",
        redeem: json["redeem"] ?? "",
        specification: json["specification"] ?? "",
        images: List<String>.from(json["images"].map((x) => x)),
        categoryId: json["category_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "watt": watt,
        "color": color,
        "price": price,
        "redeem": redeem,
        "specification": specification,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "category_id": categoryId,
    };
}
