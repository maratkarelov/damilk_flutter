import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:damilk_app/src/repository/remote/api/models/client/user_model.dart';
import 'package:damilk_app/src/repository/remote/api/models/base_response.dart';
import 'package:damilk_app/src/bloc/base_bloc.dart';
import 'package:damilk_app/src/repository/damilk_repository.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc extends BaseBloc {
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

  Future<BaseResponse<UserModel>> login(String verificationId) async {
    showProgress();
    final result = await _repository.login(verificationId);
    hideProgress();
    return Future.value(result);
  }


}
