import 'dart:convert';

WithdrawalRequestModel withdrawalRequestModelFromJson(String str) => WithdrawalRequestModel.fromJson(json.decode(str));

String withdrawalRequestModelToJson(WithdrawalRequestModel data) => json.encode(data.toJson());

class WithdrawalRequestModel {
  bool status;
  int code;
  String message;
  List<Datum> data;

  WithdrawalRequestModel({
    this.status = false,
    this.code = 0,
    this.message = '',
    this.data = const [],
  });

  factory WithdrawalRequestModel.fromJson(Map<String, dynamic> json) => WithdrawalRequestModel(
        status: json["status"] ?? false,
        code: json["code"] ?? 0,
        message: json["message"] ?? '',
        data: json["data"] != null ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))) : [],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  int userId;
  int redeemInformationId;
  int redeemPointsUsed;
  String status;
  dynamic adminId;
  String remarks;
  DateTime? createdAt;
  DateTime? updatedAt;
  String customerPaymentOption;
  Redeeminformation? redeeminformation;

  Datum({
    this.id = 0,
    this.userId = 0,
    this.redeemInformationId = 0,
    this.redeemPointsUsed = 0,
    this.status = '',
    this.adminId,
    this.remarks = '',
    this.createdAt,
    this.updatedAt,
    this.customerPaymentOption = '',
    this.redeeminformation,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        redeemInformationId: json["redeem_information_id"] ?? 0,
        redeemPointsUsed: json["redeem_points_used"] ?? 0,
        status: json["status"] ?? '',
        adminId: json["admin_id"],
        remarks: json["remarks"] ?? '',
        createdAt: json["created_at"] != null ? DateTime.tryParse(json["created_at"]) : null,
        updatedAt: json["updated_at"] != null ? DateTime.tryParse(json["updated_at"]) : null,
        customerPaymentOption: json["customer_payment_option"] ?? '',
        redeeminformation: json["redeeminformation"] != null
            ? Redeeminformation.fromJson(json["redeeminformation"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "redeem_information_id": redeemInformationId,
        "redeem_points_used": redeemPointsUsed,
        "status": status,
        "admin_id": adminId,
        "remarks": remarks,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "customer_payment_option": customerPaymentOption,
        "redeeminformation": redeeminformation?.toJson(),
      };
}

class Redeeminformation {
  int id;
  String title;
  int points;
  String image;
  int position;
  DateTime? createdAt;
  DateTime? updatedAt;

  Redeeminformation({
    this.id = 0,
    this.title = '',
    this.points = 0,
    this.image = '',
    this.position = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory Redeeminformation.fromJson(Map<String, dynamic> json) => Redeeminformation(
        id: json["id"] ?? 0,
        title: json["title"] ?? '',
        points: json["points"] ?? 0,
        image: json["image"] ?? '',
        position: json["position"] ?? 0,
        createdAt: json["created_at"] != null ? DateTime.tryParse(json["created_at"]) : null,
        updatedAt: json["updated_at"] != null ? DateTime.tryParse(json["updated_at"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "points": points,
        "image": image,
        "position": position,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}