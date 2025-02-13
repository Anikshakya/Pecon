class RedeemItem {
  final int id;
  final String name;
  final String imageUrl;
  final int points;

  RedeemItem({required this.id, required this.name, required this.imageUrl, required this.points});

  factory RedeemItem.fromJson(Map<String, dynamic> json) {
    return RedeemItem(
      id: json["id"],
      name: json["name"],
      imageUrl: json["imageUrl"],
      points: json["points"],
    );
  }
}