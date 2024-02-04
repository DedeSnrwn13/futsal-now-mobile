import 'package:futsal_now_mobile/models/ground_model.dart';
import 'package:futsal_now_mobile/models/user_model.dart';

class GroundReviewModel {
  int id;
  int groundId;
  int userId;
  double rate;
  String? comment;
  DateTime createdAt;
  DateTime updatedAt;
  GroundModel ground;
  UserModel user;

  GroundReviewModel({
    required this.id,
    required this.groundId,
    required this.userId,
    required this.rate,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.ground,
    required this.user,
  });

  factory GroundReviewModel.fromJson(Map<String, dynamic> json) => GroundReviewModel(
        id: json["id"],
        groundId: json["ground_id"],
        userId: json["user_id"],
        rate: json["rate"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
        ground: GroundModel.fromJson(json["ground"]),
        user: UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ground_id": groundId,
        "user_id": userId,
        "rate": userId,
        "comment": comment,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "ground": ground.toJson(),
        "user": user.toJson(),
      };
}
