import 'dart:convert';

// Function to parse JSON data into AdSlider object
AdSlider adSliderFromJson(String str) => AdSlider.fromJson(json.decode(str));

// Function to convert AdSlider object to JSON string
String adSliderToJson(AdSlider data) => json.encode(data.toJson());

class AdSlider {
  final bool status;
  final int code;
  final String message;
  final List<Datum> data;

  AdSlider({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory AdSlider.fromJson(Map<String, dynamic> json) => AdSlider(
        status: json["status"] ?? false,
        code: json["code"] ?? 0,
        message: json["message"] ?? "",
        data: json["data"] != null
            ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  final int id;
  final String title;
  final String image;
  final int position;
  final DateTime createdAt;
  final DateTime updatedAt;

  Datum({
    required this.id,
    required this.title,
    required this.image,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? 0,
        title: json["title"] ?? "Untitled",
        image: json["image"] ?? "",
        position: json["position"] ?? 0,
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "position": position,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
