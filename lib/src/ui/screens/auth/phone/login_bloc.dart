import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:damilk_app/src/bloc/base_bloc.dart';
import 'package:damilk_app/src/repository/damilk_repository.dart';
import 'package:damilk_app/src/repository/remote/api/models/base_response.dart';
import 'package:damilk_app/src/repository/remote/api/models/request_otp_response.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends BaseBloc {
  final _repository = DamilkRepository();
  final _verificationId = BehaviorSubject<String>();

  Observable<String> get verificationID => _verificationId.stream;
  String get getVerificationId => _verificationId.value;
  Function(String) get changeVerificationId => _verificationId.sink.add;

  Future<void> verifyPhoneNumber(
      String phoneNumber,
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
      PhoneCodeSent codeSent,
      PhoneVerificationCompleted verificationCompleted,
      PhoneVerificationFailed verificationFailed) {
    // For the full phone number we need to concat the dialcode and the number entered by the user
    return _repository.verifyPhoneNumber(
        phoneNumber,
        codeAutoRetrievalTimeout,
        codeSent,
        Duration(seconds: 10),
        verificationCompleted,
        verificationFailed);
  }

  Future<AuthResult> signInWithCredential(AuthCredential credential) {
    return _repository.signInWithCredential(credential);
  }

  Future<BaseResponse<RequestOtpResponse>> requestOtp(String phone) async {
    showProgress();
    final result = await _repository.requestOtp(phone);
    hideProgress();
    return Future.value(result);
  }
}
