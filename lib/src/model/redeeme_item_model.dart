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
    Data? data;

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
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "data": data!.toJson(),
    };
}

class Data {
    List<ReedemInformation>? reedemInformation;
    String? headerImage;

    Data({
        this.reedemInformation,
        this.headerImage,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        reedemInformation: List<ReedemInformation>.from(json["reedemInformation"].map((x) => ReedemInformation.fromJson(x))),
        headerImage: json["header_image"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "reedemInformation": List<dynamic>.from(reedemInformation!.map((x) => x.toJson())),
        "header_image": headerImage,
    };
}

class ReedemInformation {
    int? id;
    String? title;
    int? points;
    String? image;
    int? position;
    String? createdAt;
    String? updatedAt;

    ReedemInformation({
        this.id,
        this.title,
        this.points,
        this.image,
        this.position,
        this.createdAt,
        this.updatedAt,
    });

    factory ReedemInformation.fromJson(Map<String, dynamic> json) => ReedemInformation(
        id: json["id"],
        title: json["title"] ?? "",
        points: json["points"] ?? "",
        image: json["image"] ?? "",
        position: json["position"],
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
