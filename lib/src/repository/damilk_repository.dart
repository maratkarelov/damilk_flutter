import 'package:firebase_auth/firebase_auth.dart';
import 'package:damilk_app/src/firebase/auth_provider.dart';
import 'package:damilk_app/src/repository/local/damilk_local_repo.dart';
import 'package:damilk_app/src/repository/remote/api/models/alone/city_model.dart';
import 'package:damilk_app/src/repository/remote/api/models/base_response.dart';
import 'package:damilk_app/src/repository/remote/api/models/client/user_model.dart';
import 'package:damilk_app/src/repository/remote/api/models/request_otp_response.dart';
import 'package:damilk_app/src/repository/remote/damilk_remote_repository.dart';

class DamilkRepository {
  static final _instance = DamilkRepository._internal();

  final _localRepository = DamilkLocalRepo();
  final _remoteRepository = DamilkRemoteRepository();
  final _authProvider = AuthProvider();

  factory DamilkRepository() {
    return _instance;
  }

  DamilkRepository._internal();

  Future<BaseResponse<RequestOtpResponse>> requestOtp(String phone) {
    return _remoteRepository.requestOtp(phone);
  }

  Future<AuthResult> signInWithCredential(AuthCredential credential) =>
      _authProvider.signInWithCredential(credential);

  Future<void> verifyPhoneNumber(
          String phone,
          PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
          PhoneCodeSent codeSent,
          Duration duration,
          PhoneVerificationCompleted verificationCompleted,
          PhoneVerificationFailed verificationFailed) =>
      _authProvider.verifyPhoneNumber(phone, codeAutoRetrievalTimeout, codeSent,
          duration, verificationCompleted, verificationFailed);

  Future<BaseResponse<UserModel>> login(String token) async {
    final response = await _remoteRepository.login(token);
    if (response.isSuccessful()) {
      _localRepository.storeUser(response.message, response.data.isActivate);
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
