import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:damilk_app/src/bloc/base_bloc.dart';
import 'package:damilk_app/src/repository/remote/api/models/base_response.dart';
import 'package:damilk_app/src/repository/remote/api/models/client/client_auth_model.dart';
import 'package:damilk_app/src/repository/remote/api/models/request_otp_response.dart';
import 'package:damilk_app/src/repository/damilk_repository.dart';

class OtpBloc extends BaseBloc {
  final _repository = DamilkRepository();

  Timer timer;
  int currentTime = 0;

  final _processTimer = StreamTransformer<int, TimerEntity>.fromHandlers(
      handleData: (timesLeft, timerSink) {
    timerSink.add(TimerEntity(timesLeft, timesLeft <= 0));
  });

  final _timerController = StreamController<int>.broadcast();

  StreamSink<int> get _timerSink => _timerController.sink;

  Stream<TimerEntity> get timerStream =>
      _timerController.stream.transform(_processTimer);

  void runTimer(int timeToNext) {
    if (currentTime <= 0) {
      //timer still running
      currentTime = timeToNext;

      timer = Timer.periodic(Duration(seconds: 1), (tick) {
        currentTime--;
        _timerSink.add(currentTime);

        if (currentTime <= 0) {
          _stopTimer();
        }
      });
    }
  }

  Future<BaseResponse<RequestOtpResponse>> requestOtp(String phone) async {
    showProgress();
    final result = await _repository.requestOtp(phone);
    hideProgress();
    return Future.value(result);
  }

  Future<AuthResult> signInWithCredential(AuthCredential credential) {
    return _repository.signInWithCredential(credential);
  }

  Future<BaseResponse<ClientAuthModel>> login(String phone, String otp) async {
    showProgress();
    final result = await _repository.login(phone, otp);
    hideProgress();
    return Future.value(result);
  }

  void _stopTimer() {
    timer?.cancel();
    currentTime = 0;
  }

  @override
  void dispose() {
    _stopTimer();
    _timerController.close();
    super.dispose();
  }
}

class TimerEntity {
  final timesLeft;
  final isEnabled;

  TimerEntity(this.timesLeft, this.isEnabled);
}
