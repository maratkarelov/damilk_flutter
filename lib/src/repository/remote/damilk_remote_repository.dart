import 'package:damilk_app/src/repository/remote/api/damilk_api_provider.dart';
import 'package:damilk_app/src/repository/remote/api/models/alone/city_model.dart';
import 'package:damilk_app/src/repository/remote/api/models/base_response.dart';
import 'package:damilk_app/src/repository/remote/api/models/request_otp_response.dart';
import 'package:damilk_app/src/resources/const.dart';
import 'package:dio/dio.dart';

import 'api/models/client/user_model.dart';

class DamilkRemoteRepository {
  final _apiProvider = DamilkApiProvider();

  static final DamilkRemoteRepository _instance =
  DamilkRemoteRepository._internal();

  factory DamilkRemoteRepository() {
    return _instance;
  }

  DamilkRemoteRepository._internal();

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

  Future<BaseResponse<UserModel>> login(String token) async {
    BaseResponse<UserModel> convertedResponse;
    try {
      final response = await _apiProvider.login(token);
      int statusCode = response.statusCode;
      if (statusCode == 0) {
        convertedResponse = BaseResponse(code: Const.NETWORK_CONNECTION);
      } else if (statusCode == 200) {
        convertedResponse = BaseResponse.fromJson(statusCode, response.data,
                (json) => UserModel.fromJson(json));
      } else {
        convertedResponse =
            BaseResponse.fromErrorJson(statusCode, response.data);
      }
      String jwt = response.data["data"]["token"];
      convertedResponse.message = jwt;
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
