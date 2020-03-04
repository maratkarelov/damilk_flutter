import 'package:sim23/src/repository/local/sim23_local_repo.dart';
import 'package:sim23/src/repository/remote/api/models/alone/city_model.dart';
import 'package:sim23/src/repository/remote/api/models/base_response.dart';
import 'package:sim23/src/repository/remote/api/models/client/client_auth_model.dart';
import 'package:sim23/src/repository/remote/api/models/request_otp_response.dart';
import 'package:sim23/src/repository/remote/sim23_remote_repository.dart';

class Sim23Repository {
  static final _instance = Sim23Repository._internal();

  final _localRepository = Sim23LocalRepo();
  final _remoteRepository = Sim23RemoteRepository();

  factory Sim23Repository() {
    return _instance;
  }

  Sim23Repository._internal();

  Future<BaseResponse<RequestOtpResponse>> requestOtp(String phone) {
    return _remoteRepository.requestOtp(phone);
  }

  Future<BaseResponse<ClientAuthModel>> login(
      String phone, String otpCode) async {
    final response = await _remoteRepository.login(phone, otpCode);
    if (response.isSuccessful()) {
      _localRepository.storeUser(response.data);
    }

    return response;
  }

  Future<BaseResponse<List<CityModel>>> loadCities() {
    return _remoteRepository.loadCities();
  }

  Future<BaseResponse> register(String name, CityModel city) async {
    final response = await _remoteRepository.register(name, city);
    _localRepository.onUserRegistered(response);
    return response;
  }

  void clearRepository() async {
    _localRepository.clearDatabase();
  }
}
