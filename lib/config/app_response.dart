import 'dart:convert';
import 'package:futsal_now_mobile/config/failure.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:d_method/d_method.dart';

class AppResponse {
  static Map data(Response response) {
    DMethod.printResponse(response);

    switch (response.statusCode) {
      case 200: // read
      case 201: // create, update
        var responseJson = jsonDecode(response.body);
        return responseJson;
      case 204: // delete
        return {'success': true};
      case 400:
        throw BadRequestFailure(message: response.body);
      case 401:
        throw UnauthorisedFailure(message: response.body);
      case 403:
        throw ForbiddenFailure(message: response.body);
      case 404:
        throw NotFoundFailure(message: response.body);
      case 422:
        throw InvalidInputFailure(message: response.body);
      case 500:
        throw ServerFailure(message: response.body);
      default:
        throw FetchFailure(message: response.body);
    }
  }

  static invalidInput(BuildContext context, String messageBody) {
    Map errors = jsonDecode(messageBody)['errors'];

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            title: const Text('Invalid Input'),
            children: [
              ...errors.entries.map((e) {
                return ListTile(
                  title: Text(e.key),
                  subtitle: Column(
                    children: (e.value! as List).map((itemError) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [const Text('- '), Expanded(child: Text(itemError))],
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close')),
              )
            ],
          );
        });
  }
}
