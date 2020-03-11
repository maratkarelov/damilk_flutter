
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:damilk_app/src/repository/remote/api/auth_verifier_interceptor.dart';
import 'package:damilk_app/src/resources/const.dart';

class DamilkApiProvider {
  static const BASE_URL = "https://api.mobile.damilk.com.ua/api/v1/";

  final Dio _dio = Dio();
  final Logger _logger = Logger("DamilkApiProvider");
  static final DamilkApiProvider _instance = DamilkApiProvider._internal();

  DamilkApiProvider._internal() {
    _setupInterceptors();
  }

  factory DamilkApiProvider() {
    return _instance;
  }

  Future<Response> requestOtpCode(String phone) {
    var formattedPhone = phone.replaceAll(" ", "");
    return _dio.post(BASE_URL + "client/auth/code/create",
        data: {"phone": formattedPhone});
  }

  Future<Response> login(String phone, String otpCode) {
    var formattedPhone = phone.replaceAll(" ", "");
    return _dio.post(BASE_URL + "user/entry/firebase",
        data: {"token": formattedPhone, "code": otpCode});
  }

  Future<Response> updateProfile(Map<String, dynamic> profile) {
    return _dio.patch(BASE_URL + "client/profile", data: profile);
  }

  Future<Response> loadCities() {
    return _dio
        .get(BASE_URL + "cities", queryParameters: {"page": 1, "limit": -1});
  }

  void _setupInterceptors() {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      return _handleDioRequest(options);
    }, onResponse: (Response response) async {
      return _handleDioResponse(response);
    }, onError: (DioError error) async {
      return _handleDioError(error);
    }));
  }

  dynamic _handleDioRequest(RequestOptions options) async {
    _logger.info("--> ${options.method} ${options.path}");
    _logger.info("Content type: ${options.contentType}");
    _logger.info("<-- END HTTP");
    final sharedPrefs = await SharedPreferences.getInstance();
    String token = sharedPrefs?.getString(Const.JWT_TOKEN);

    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer " + token;
    }
    return options;
  }

  dynamic _handleDioResponse(Response response) {
    int maxCharactersPerLine = 200;

    _logger.info(
        "<-- ${response.statusCode} ${response.request.method} ${response.request.path}");
    String responseAsString = response.data.toString();
    if (responseAsString.length > maxCharactersPerLine) {
      int iterations = (responseAsString.length / maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
        _logger.info(
            responseAsString.substring(i * maxCharactersPerLine, endingIndex));
      }
    } else {
      _logger.info(response.data);
    }
    _logger.info("<-- END HTTP");
  }

  dynamic _handleDioError(DioError error) {
    if (error != null &&
        error.response != null &&
        error.response.statusCode == 401) {
      AuthVerifierInterceptor().verify(error.response);
      return _dio.resolve(error);
    } else {
      return error.response;
    }
  }
}
