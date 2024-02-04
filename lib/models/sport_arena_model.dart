class SportArenaModel {
  int id;
  int userId;
  String name;
  String description;
  String city;
  String district;
  String? email;
  String waNumber;
  String openTime;
  String closeTime;
  String? logo;
  String? mapLink;
  DateTime createdAt;
  DateTime updatedAt;
  String image;
  double rate;
  double price;

  SportArenaModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.city,
    required this.district,
    this.email,
    required this.waNumber,
    required this.openTime,
    required this.closeTime,
    this.logo,
    this.mapLink,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
    required this.rate,
    required this.price,
  });

  factory SportArenaModel.fromJson(Map<String, dynamic> json) => SportArenaModel(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        description: json["description"],
        city: json["city"],
        district: json["district"],
        email: json["email"],
        waNumber: json["wa_number"],
        openTime: json["open_time"],
        closeTime: json["close_time"],
        logo: json["logo"],
        mapLink: json["map_link"],
        createdAt: DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
        image: json["image"] ?? "",
        rate: json["rate"]?.toDouble() ?? 0,
        price: json["price"]?.toDouble() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "description": description,
        "city": city,
        "district": district,
        "email": email,
        "wa_number": waNumber,
        "open_time": openTime,
        "close_time": closeTime,
        "logo": logo,
        "map_link": mapLink,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "image": image,
        "rate": rate,
        "price": price,
      };
}
