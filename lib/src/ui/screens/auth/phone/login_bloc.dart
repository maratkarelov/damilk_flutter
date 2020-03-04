import 'dart:async';

import 'package:damilk_app/src/bloc/base_bloc.dart';
import 'package:damilk_app/src/repository/sim23_repository.dart';
import 'package:damilk_app/src/repository/remote/api/models/base_response.dart';
import 'package:damilk_app/src/repository/remote/api/models/request_otp_response.dart';

class LoginBloc extends BaseBloc {
  final _repository = Sim23Repository();

  Future<BaseResponse<RequestOtpResponse>> requestOtp(String phone) async {
    showProgress();
    final result = await _repository.requestOtp(phone);
    hideProgress();
    return Future.value(result);
  }
}
