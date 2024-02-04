class PromoModel {
  int id;
  String name;
  String description;
  String uniqueCode;
  String type;
  double amount;
  DateTime startedAt;
  DateTime endedAt;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  PromoModel({
    required this.id,
    required this.name,
    required this.description,
    required this.uniqueCode,
    required this.type,
    required this.amount,
    required this.startedAt,
    required this.endedAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) => PromoModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        uniqueCode: json["unique_code"],
        type: json["type"],
        amount: json["amount"]?.toDouble(),
        startedAt: DateTime.parse(json["started_at"]).toLocal(),
        endedAt: DateTime.parse(json["ended_at"]).toLocal(),
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "unique_code": uniqueCode,
        "type": type,
        "amount": amount,
        "started_at": startedAt.toIso8601String(),
        "ended_at": endedAt.toIso8601String(),
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
