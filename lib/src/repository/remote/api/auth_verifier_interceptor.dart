import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:damilk_app/src/repository/remote/api/models/base_response.dart';
import 'package:damilk_app/src/repository/damilk_repository.dart';
import 'package:damilk_app/src/router/app_routing_names.dart';

class AuthVerifierInterceptor {
  static final AuthVerifierInterceptor _instance =
      AuthVerifierInterceptor._internal();
  GlobalKey<NavigatorState> navigatorKey;

  factory AuthVerifierInterceptor() {
    return _instance;
  }

  AuthVerifierInterceptor._internal() {
    navigatorKey = GlobalKey<NavigatorState>();
  }

  Future<void> verify(Response<dynamic> response) async {
    if (response.statusCode == 401) {
      DamilkRepository().clearRepository();

      navigatorKey.currentState.pushNamedAndRemoveUntil(
          AppRoutes.LOGIN_SCREEN, (route) => false,
          arguments:
              BaseResponse.fromErrorJson(response.statusCode, response.data));
    }
  }
}
