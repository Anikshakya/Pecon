// To parse this JSON data, do
//
//     final redeemInformationModel = redeemInformationModelFromJson(jsonString);

import 'dart:convert';

RedeemInformationModel redeemInformationModelFromJson(String str) => RedeemInformationModel.fromJson(json.decode(str));

String redeemInformationModelToJson(RedeemInformationModel data) => json.encode(data.toJson());

class RedeemInformationModel {
    bool? status;
    int? code;
    String? message;
    List<Datum>? data;

    RedeemInformationModel({
        this.status,
        this.code,
        this.message,
        this.data,
    });

    factory RedeemInformationModel.fromJson(Map<String, dynamic> json) => RedeemInformationModel(
        status: json["status"],
        code: json["code"],
        message: json["message"] ?? "",
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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
    int? points;
    String? image;
    int? position;
    String? createdAt;
    String? updatedAt;

    Datum({
        this.id,
        this.title,
        this.points,
        this.image,
        this.position,
        this.createdAt,
        this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"] ?? "",
        points: json["points"] ?? "",
        image: json["image"] ?? "",
        position: json["position"] ?? "",
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "points": points,
        "image": image,
        "position": position,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
