import 'package:futsal_now_mobile/models/ground_model.dart';
import 'package:futsal_now_mobile/models/promo_model.dart';
import 'package:futsal_now_mobile/models/user_model.dart';

class BookingModel {
  int id;
  int groundId;
  int userId;
  DateTime orderDate;
  String startedAt;
  String endedAt;
  double totalPrice;
  String orderNumber;
  String orderStatus;
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
    required this.orderStatus,
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
        startedAt: json["started_at"],
        endedAt: json["ended_at"],
        totalPrice: json["total_price"].toDouble(),
        orderNumber: json["order_number"],
        orderStatus: json["order_status"],
        paymentMethod: json["payment_method"],
        paymentStatus: json["payment_status"],
        paidAt: json["paid_at"] != null ? DateTime.parse(json["paid_at"]).toLocal() : null,
        promoId: json["promo_id"],
        refId: json["ref_id"],
        createdAt: DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
        ground: GroundModel.fromJson(json["ground"]),
        user: UserModel.fromJson(json["user"]),
        promo: json["promo"] != null ? PromoModel.fromJson(json["promo"]) : null,
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
        "order_status": orderStatus,
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
