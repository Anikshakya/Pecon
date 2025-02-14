class User {
  int id;
  String name;
  String email;
  String? emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    this.id = 0,
    this.name = "",
    this.email = "",
    this.emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime(1970, 1, 1),
        updatedAt = updatedAt ?? DateTime(1970, 1, 1);

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime(1970, 1, 1),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime(1970, 1, 1),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}