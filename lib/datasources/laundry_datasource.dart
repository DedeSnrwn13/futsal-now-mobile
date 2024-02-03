import 'package:dartz/dartz.dart';
import 'package:futsal_now_mobile/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:futsal_now_mobile/config/app_constants.dart';
import 'package:futsal_now_mobile/config/app_request.dart';
import 'package:futsal_now_mobile/config/app_response.dart';
import 'package:futsal_now_mobile/config/app_session.dart';
import 'package:futsal_now_mobile/config/failure.dart';

class LaundryDatasource {
  static Future<Either<Failure, Map>> readByUser(int userId) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/laundry/user/$userId');
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

  static Future<Either<Failure, Map>> claim(String id, String claimCode) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/laundry/claim');
    UserModel? user = await AppSession.getUser();
    final token = await AppSession.getBearerToken();

    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(token),
        body: {
          'id': id,
          'claim_code': claimCode,
          'user_id': user!.id.toString(),
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
