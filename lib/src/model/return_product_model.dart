import 'dart:convert';

ReturnProductModel productListModelFromJson(String str) => ReturnProductModel.fromJson(json.decode(str));

String productListModelToJson(ReturnProductModel data) => json.encode(data.toJson());

class ReturnProductModel {
  final bool status;
  final int code;
  final String message;
  final List<ProductData> data;

  ReturnProductModel({
    this.status = false,
    this.code = 0,
    this.message = "",
    this.data = const [],
  });

  factory ReturnProductModel.fromJson(Map<String, dynamic> json) => ReturnProductModel(
        status: json["status"] ?? false,
        code: json["code"] ?? 0,
        message: json["message"] ?? "",
        data: json["data"] != null
            ? List<ProductData>.from(json["data"].map((x) => ProductData.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ProductData {
  final String code;
  final Product product;
  final ProductBatch productBatch;
  final String redeemedAt;
  final int redeemPoint;
  final int productId;

  ProductData({
    this.code = "",
    Product? product,
    ProductBatch? productBatch,
    this.redeemedAt = "",
    this.redeemPoint = 0,
    this.productId = 0,
  })  : product = product ?? Product(),
        productBatch = productBatch ?? ProductBatch();

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        code: json["code"] ?? "",
        product: json["product"] != null ? Product.fromJson(json["product"]) : Product(),
        productBatch:
            json["product_batch"] != null ? ProductBatch.fromJson(json["product_batch"]) : ProductBatch(),
        redeemedAt: json["redeemed_at"] ?? "",
        redeemPoint: json["redeem_point"] ?? 0,
        productId: json["product_id"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "product": product.toJson(),
        "product_batch": productBatch.toJson(),
        "redeemed_at": redeemedAt,
        "redeem_point": redeemPoint,
        "product_id": productId,
      };
}

class Product {
  final String title;
  final String? colorCode;

  Product({
    this.title = "",
    this.colorCode,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        title: json["title"] ?? "",
        colorCode: json["color_code"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "color_code": colorCode,
      };
}

class ProductBatch {
  final String batch;
  final int batchId;

  ProductBatch({
    this.batch = "",
    this.batchId = 0,
  });

  factory ProductBatch.fromJson(Map<String, dynamic> json) => ProductBatch(
        batch: json["batch"] ?? "",
        batchId: json["batch_id"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "batch": batch,
        "batch_id": batchId,
      };
}
