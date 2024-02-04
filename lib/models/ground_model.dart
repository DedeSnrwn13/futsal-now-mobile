import 'package:futsal_now_mobile/models/sport_arena_model.dart';

class GroundModel {
  int id;
  int sportArenaId;
  String name;
  String description;
  double rentalPrice;
  int capacity;
  bool isAvailable;
  List<String> image;
  DateTime createdAt;
  DateTime updatedAt;
  SportArenaModel sportArena;
  double? rate;
  String? imgThumbnail;

  GroundModel({
    required this.id,
    required this.sportArenaId,
    required this.name,
    required this.description,
    required this.rentalPrice,
    required this.capacity,
    required this.isAvailable,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.sportArena,
    this.rate,
    this.imgThumbnail,
  });

  factory GroundModel.fromJson(Map<String, dynamic> json) => GroundModel(
        id: json["id"],
        sportArenaId: json["sport_arena_id"],
        name: json["name"],
        description: json["description"],
        rentalPrice: json["rental_price"]?.toDouble(),
        capacity: json["capacity"],
        isAvailable: json["is_available"] == 1,
        image: _parseImage(json["image"]),
        createdAt: DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
        sportArena: SportArenaModel.fromJson(json["sport_arena"]),
        rate: json["rate"]?.toDouble() ?? 0,
        imgThumbnail: json["image_thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sport_arena_id": sportArenaId,
        "name": name,
        "description": description,
        "rental_price": rentalPrice,
        "capacity": capacity,
        "is_available": isAvailable,
        "image": image.join(','),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "sportArena": sportArena,
        'rate': rate,
        "image_thumbnail": imgThumbnail,
      };

  static List<String> _parseImage(dynamic imageData) {
    if (imageData is String) {
      return imageData.split(',');
    } else if (imageData is List<dynamic>) {
      // Handle List<dynamic> case (you might need to adjust this based on your data structure)
      return imageData.map((item) => item.toString()).toList();
    } else {
      // Handle other cases or return an empty list based on your requirements
      return [];
    }
  }
}
