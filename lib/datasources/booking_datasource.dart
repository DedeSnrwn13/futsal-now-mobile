import 'package:dartz/dartz.dart';
import 'package:futsal_now_mobile/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:futsal_now_mobile/config/app_constants.dart';
import 'package:futsal_now_mobile/config/app_request.dart';
import 'package:futsal_now_mobile/config/app_response.dart';
import 'package:futsal_now_mobile/config/app_session.dart';
import 'package:futsal_now_mobile/config/failure.dart';

class BookingDatasource {
  static Future<Either<Failure, Map>> history() async {
    Uri url = Uri.parse('${AppConstants.baseURL}/bookings/history');
    final token = await AppSession.getBearerToken();

    try {
      final response = await http.get(
        url,
        headers: AppRequest.header(token),
      );

      final data = AppResponse.data(response);

      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }

      return Left(FetchFailure(message: e.toString()));
    }
  }

  static Future<Either<Failure, Map>> showById(String id) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/bookings/$id/show');
    final token = await AppSession.getBearerToken();

    try {
      final response = await http.get(
        url,
        headers: AppRequest.header(token),
      );

      final data = AppResponse.data(response);

      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }

      return Left(FetchFailure(message: e.toString()));
    }
  }

  static Future<Either<Failure, Map>> cancelOrderNumber(String orderNumber) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/bookings/$orderNumber/cancel');
    final token = await AppSession.getBearerToken();

    try {
      final response = await http.put(
        url,
        headers: AppRequest.header(token),
        body: {
          'order_number': orderNumber,
        },
      );

      final data = AppResponse.data(response);

      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }

      return Left(FetchFailure(message: e.toString()));
    }
  }

  static Future<Either<Failure, Map>> booking(
    String sportArenaId,
    String groundId,
    String orderDate,
    String startedAt,
    String endedAt,
    String totalPrice,
    String paymentMethod,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/sport-arenas/$sportArenaId/grounds/$groundId/book');
    final token = await AppSession.getBearerToken();
    UserModel? user = await AppSession.getUser();

    paymentMethod == 'BCA' ? 'bca_va' : 'bni_va';

    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(token),
        body: {
          'user_id': user!.id.toString(),
          'ground_id': groundId,
          'order_date': orderDate,
          'started_at': startedAt,
          'ended_at': endedAt,
          'total_price': totalPrice,
          'payment_method': paymentMethod,
        },
      );

      final data = AppResponse.data(response);

      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }

      return Left(FetchFailure(message: e.toString()));
    }
  }
}
