import 'package:dartz/dartz.dart';
import 'package:futsal_now_mobile/config/app_constants.dart';
import 'package:futsal_now_mobile/config/app_request.dart';
import 'package:futsal_now_mobile/config/app_response.dart';
import 'package:futsal_now_mobile/config/app_session.dart';
import 'package:futsal_now_mobile/config/failure.dart';
import 'package:futsal_now_mobile/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserDatasource {
  static Future<Either<Failure, Map>> login(
    String email,
    String password,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/login');

    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(),
        body: {
          'email': email,
          'password': password,
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

  static Future<Either<Failure, Map>> register(
    String name,
    String email,
    String phone,
    String password,
    String passwordConfirmation,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/register');

    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(),
        body: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
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

  static Future<Either<Failure, Map>> feedback(
    String body,
    double rate,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/feedback');
    final token = await AppSession.getBearerToken();
    UserModel? user = await AppSession.getUser();

    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(token),
        body: {
          'user_id': user!.id.toString(),
          'body': body,
          'rate': rate.toString(),
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
