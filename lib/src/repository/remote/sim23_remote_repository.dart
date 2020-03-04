import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sim23/src/repository/remote/api/models/alone/city_model.dart';
import 'package:sim23/src/repository/remote/api/models/base_response.dart';
import 'package:sim23/src/repository/remote/api/models/client/client_model.dart';
import 'package:sim23/src/repository/remote/api/models/request_otp_response.dart';
import 'package:sim23/src/repository/remote/api/sim23_api_provider.dart';
import 'package:sim23/src/resources/const.dart';

import 'api/models/client/client_auth_model.dart';

class Sim23RemoteRepository {
  final _apiProvider = Sim23ApiProvider();

  static final Sim23RemoteRepository _instance =
      Sim23RemoteRepository._internal();

  factory Sim23RemoteRepository() {
    return _instance;
  }

  Sim23RemoteRepository._internal();

  Future<BaseResponse<RequestOtpResponse>> requestOtp(String phone) async {
    BaseResponse<RequestOtpResponse> convertedResponse;

    try {
      final response = await _apiProvider.requestOtpCode(phone);
      int statusCode = response.statusCode;
      if (statusCode == 0) {
        convertedResponse = BaseResponse(code: Const.NETWORK_CONNECTION);
      } else if (statusCode == 202 || statusCode == 429) {
        convertedResponse = BaseResponse.fromJson(statusCode, response.data,
            (json) => RequestOtpResponse.fromJson(json));
      } else {
        convertedResponse =
            BaseResponse.fromErrorJson(statusCode, response.data);
      }
    } on DioError catch (e) {
      convertedResponse =
          BaseResponse(code: Const.NETWORK_CONNECTION, message: e.toString());
    }

    return Future.value(convertedResponse);
  }

  Future<BaseResponse<ClientAuthModel>> login(
      String phone, String otpCode) async {
    BaseResponse<ClientAuthModel> convertedResponse;

    try {
      final response = await _apiProvider.login(phone, otpCode);
      int statusCode = response.statusCode;
      if (statusCode == 0) {
        convertedResponse = BaseResponse(code: Const.NETWORK_CONNECTION);
      } else if (statusCode == 200) {
        convertedResponse = BaseResponse.fromJson(statusCode, response.data,
            (json) => ClientAuthModel.fromJson(json));
      } else {
        convertedResponse =
            BaseResponse.fromErrorJson(statusCode, response.data);
      }
    } on DioError catch (e) {
      convertedResponse =
          BaseResponse(code: Const.NETWORK_CONNECTION, message: e.toString());
    }

    return Future.value(convertedResponse);
  }

  Future<BaseResponse<List<CityModel>>> loadCities() async {
    BaseResponse<List<CityModel>> convertedResponse;

    try {
      final response = await _apiProvider.loadCities();
      int statusCode = response.statusCode;
      if (statusCode == 0) {
        convertedResponse = BaseResponse(code: Const.NETWORK_CONNECTION);
      } else if (statusCode == 200) {
        convertedResponse = BaseResponse(
            code: statusCode,
            data: CityModel.fromListJson(response.data['data']));
      } else {
        convertedResponse =
            BaseResponse.fromErrorJson(statusCode, response.data);
      }
    } on DioError catch (e) {
      convertedResponse =
          BaseResponse(code: Const.NETWORK_CONNECTION, message: e.toString());
    }

    return Future.value(convertedResponse);
  }

  Future<BaseResponse> register(String name, CityModel city) async {
    BaseResponse convertedResponse;

    try {
      final updateModel = {
        "first_name": name,
        "city": {"id": city.id, "title": city.title}
      };

      final response = await _apiProvider.updateProfile(updateModel);
      int statusCode = response.statusCode;
      if (statusCode == 0) {
        convertedResponse = BaseResponse(code: Const.NETWORK_CONNECTION);
      } else if (statusCode == 200) {
        convertedResponse = BaseResponse(code: statusCode);
      } else {
        convertedResponse =
            BaseResponse.fromErrorJson(statusCode, response.data);
      }
    } on DioError catch (e) {
      convertedResponse =
          BaseResponse(code: Const.NETWORK_CONNECTION, message: e.toString());
    }

    return Future.value(convertedResponse);
  }
}
