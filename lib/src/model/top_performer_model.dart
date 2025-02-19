import 'dart:convert';

TopPerformers topPerformersFromJson(String str) => TopPerformers.fromJson(json.decode(str));

String topPerformersToJson(TopPerformers data) => json.encode(data.toJson());

class TopPerformers {
  bool status;
  int code;
  String message;
  List<Performers> data;

  TopPerformers({
    this.status = false,
    this.code = 0,
    this.message = "",
    List<Performers>? data,
  }) : data = data ?? [];

  factory TopPerformers.fromJson(Map<String, dynamic> json) => TopPerformers(
        status: json["status"] ?? false,
        code: json["code"] ?? 0,
        message: json["message"] ?? "",
        data: json["data"] != null
            ? List<Performers>.from(json["data"].map((x) => Performers.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Performers {
  String user;
  int totalRedeem;
  int userId;
  String profilePicture;

  Performers({
    this.user = "",
    this.totalRedeem = 0,
    this.userId = 0,
    this.profilePicture = "",
  });

  factory Performers.fromJson(Map<String, dynamic> json) => Performers(
        user: json["user"] ?? "",
        totalRedeem: json["total_redeem"] ?? 0,
        userId: json["user_id"] ?? 0,
        profilePicture: json["profile_picture"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "total_redeem": totalRedeem,
        "user_id": userId,
        "profile_picture": profilePicture,
      };
}
