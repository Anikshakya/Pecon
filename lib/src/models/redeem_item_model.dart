class RedeemItem {
  final int id;
  final String name;
  final String imageUrl;
  final int points;

  RedeemItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.points,
  });

  // Factory constructor to create an instance from a map
  factory RedeemItem.fromJson(Map<String, dynamic> json) {
    return RedeemItem(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      points: json['points'] as int,
    );
  }

  // Convert an instance to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'points': points,
    };
  }

  // Factory method to create a list of RedeemItem from JSON list
  static List<RedeemItem> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => RedeemItem.fromJson(json)).toList();
  }
}
