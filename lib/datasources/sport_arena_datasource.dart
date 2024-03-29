import 'package:futsal_now_mobile/config/app_constants.dart';
import 'package:futsal_now_mobile/config/app_request.dart';
import 'package:futsal_now_mobile/config/app_response.dart';
import 'package:futsal_now_mobile/config/app_session.dart';
import 'package:futsal_now_mobile/config/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:futsal_now_mobile/models/user_model.dart';
import 'package:http/http.dart' as http;

class SportArenaDatasource {
  static Future<Either<Failure, Map>> readRecommendationLimit() async {
    Uri url = Uri.parse('${AppConstants.baseURL}/sport-arenas/recommendation/limit');
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

  static Future<Either<Failure, Map>> search(String query) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/sport-arenas/search/$query');
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

  static Future<Either<Failure, Map>> readGrounds(String id) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/sport-arenas/$id/grounds');
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

  static Future<Either<Failure, Map>> getGroundById(String id, String groundId) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/sport-arenas/$id/grounds/$groundId');
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

  static Future<Either<Failure, Map>> getGroundReview(String id) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/sport-arenas/$id/reviews');
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

  static Future<Either<Failure, Map>> submitReview(
    String sportArenaId,
    String groundId,
    double rate,
    String comment,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/sport-arenas/$sportArenaId/grounds/$groundId/reviews');
    final token = await AppSession.getBearerToken();
    UserModel? user = await AppSession.getUser();

    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(token),
        body: {
          'ground_id': groundId.toString(),
          'user_id': user!.id.toString(),
          'rate': rate.toString(),
          'comment': comment,
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
