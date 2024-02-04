import 'package:dartz/dartz.dart';
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

  static Future<Either<Failure, Map>> cancelById(String id) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/bookings/$id/cancel');
    final token = await AppSession.getBearerToken();

    try {
      final response = await http.put(
        url,
        headers: AppRequest.header(token),
        body: {
          'id': id,
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
