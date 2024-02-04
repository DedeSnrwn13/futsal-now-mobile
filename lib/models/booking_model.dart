import 'package:futsal_now_mobile/models/ground_model.dart';
import 'package:futsal_now_mobile/models/promo_model.dart';
import 'package:futsal_now_mobile/models/user_model.dart';

class BookingModel {
  int id;
  int groundId;
  int userId;
  DateTime orderDate;
  DateTime startedAt;
  DateTime endedAt;
  double totalPrice;
  String orderNumber;
  String orderSatus;
  String paymentMethod;
  String paymentStatus;
  DateTime? paidAt;
  int? promoId;
  String? refId;
  DateTime createdAt;
  DateTime updatedAt;
  GroundModel ground;
  UserModel user;
  PromoModel? promo;

  BookingModel({
    required this.id,
    required this.groundId,
    required this.userId,
    required this.orderDate,
    required this.startedAt,
    required this.endedAt,
    required this.totalPrice,
    required this.orderNumber,
    required this.orderSatus,
    required this.paymentMethod,
    required this.paymentStatus,
    this.paidAt,
    this.promoId,
    this.refId,
    required this.createdAt,
    required this.updatedAt,
    required this.ground,
    required this.user,
    this.promo,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        id: json["id"],
        groundId: json["ground_id"],
        userId: json["user_id"],
        orderDate: DateTime.parse(json["order_date"]).toLocal(),
        startedAt: DateTime.parse(json["started_at"]).toLocal(),
        endedAt: DateTime.parse(json["ended_at"]).toLocal(),
        totalPrice: json["total_price"],
        orderNumber: json["order_number"],
        orderSatus: json["order_status"],
        paymentMethod: json["paymentMethod"],
        paymentStatus: json["paymentStatus"],
        paidAt: DateTime.parse(json["paid_at"]).toLocal(),
        promoId: json["promo_id"],
        refId: json["ref_id"],
        createdAt: DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
        ground: GroundModel.fromJson(json["ground"]),
        user: UserModel.fromJson(json["user"]),
        promo: PromoModel.fromJson(json["promo"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ground_id": groundId,
        "user_id": userId,
        "order_date": orderDate,
        "started_at": startedAt,
        "ended_at": endedAt,
        "total_price": totalPrice,
        "order_number": orderNumber,
        "order_status": orderSatus,
        "payment_method": paymentMethod,
        "payment_status": paymentStatus,
        "paid_at": paidAt,
        "promo_id": promoId,
        "ref_id": refId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "ground": ground.toJson(),
        "user": user.toJson(),
        "promo": promo?.toJson(),
      };
}
