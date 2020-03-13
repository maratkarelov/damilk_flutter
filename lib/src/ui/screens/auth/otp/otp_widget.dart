import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:damilk_app/src/bloc/provider/block_provider.dart';
import 'package:damilk_app/src/resources/colors.dart';
import 'package:damilk_app/src/resources/const.dart';
import 'package:damilk_app/src/resources/drawables.dart';
import 'package:damilk_app/src/resources/strings.dart';
import 'package:damilk_app/src/router/app_routing_names.dart';
import 'package:damilk_app/src/ui/screens/auth/phone/login_bloc.dart';
import 'package:damilk_app/src/ui/screens/auth/otp/otp_bloc.dart';
import 'package:damilk_app/src/ui/screens/auth/otp/otp_screen.dart';
import 'package:damilk_app/src/extensions/parser.dart';
import 'package:damilk_app/src/ui/widgets/confirmation_dialog.dart';

class OtpWidget extends State<OtpScreen> {
  final OtpScreenArguments _arguments;
  OtpBloc _bloc;
  TextEditingController _inputController;
  final _lengthInputFormatter =
      LengthLimitingTextInputFormatter(Const.OTP_MAX_LENGTH);
  final _inputFocus = FocusNode();

  OtpWidget(this._arguments);

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: "");
    _bloc = OtpBloc();
    _bloc.runTimer(Const.TIMER_DELAY);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_inputFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          backgroundColor: AppColors.bg_light_grey,
          body: BlocProvider<OtpBloc>(
            child: StreamBuilder(
              stream: _bloc.progressStream,
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return ModalProgressHUD(
                  child: _buildScreenContent(),
                  inAsyncCall: snapshot.data,
                );
              },
            ),
            block: _bloc,
          ),
        ));
  }

  Future<bool> _onBackPressed() {
//    return showDialog(
//          context: context,
//          builder: (context) => new AlertDialog(
//            title: new Text('Are you sure?'),
//            content: new Text('Do you want to exit an App'),
//            actions: <Widget>[
//              new GestureDetector(
//                onTap: () => Navigator.of(context).pop(false),
//                child: Text("NO"),
//              ),
//              SizedBox(height: 16),
//              new GestureDetector(
//                onTap: () => Navigator.of(context).pop(true),
//                child: Text("YES"),
//              ),
//            ],
//          ),
//        ) ??
    false;
  }

  @override
  void dispose() {
    _bloc.dispose();
    _inputController.dispose();
    super.dispose();
  }

  Widget _buildScreenContent() {
    return BlocProvider<OtpBloc>(
      block: _bloc,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 88.dp()),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.dp()),
                  topRight: Radius.circular(16.dp())),
              child: Container(
                color: AppColors.white,
              ),
            ),
          ),
//          Drawables.getImage(Drawables.RECTANGLE_BACKGROUND_SMALL),
          GestureDetector(
            onTap: () => {Navigator.pop(context)},
            child: Container(
              padding: EdgeInsets.only(
                  left: 24.dp(), top: 55.dp(), right: 24.dp(), bottom: 24.dp()),
              color: Colors.transparent,
              child: Drawables.getImage(Drawables.IC_BACK),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 40.dp()),
              child: Column(
                children: _buildOtpInputWidget(),
              ),
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: _buildTimerBlock())
        ],
      ),
    );
  }

  List<Widget> _buildOtpInputWidget() {
    return <Widget>[
      Text(
        Strings.get(context, Strings.CODE_FROM_SMS),
        style: TextStyle(
            color: AppColors.solid_black,
            fontSize: 18.sp(),
            fontFamily: Const.FONT_FAMILY_NUNITO,
            fontWeight: FontWeight.w700),
      ),
      Padding(
        padding: EdgeInsets.only(left: 16.dp(), right: 16.dp(), top: 40.dp()),
        child: ClipRect(
          child: Container(
            width: MediaQuery.of(context).size.width,
//            color: AppColors.white,
            padding: EdgeInsets.only(
                left: 24.dp(), right: 24.dp(), bottom: 24.dp(), top: 19.dp()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 59.dp(),
                  child: TextField(
                    controller: _inputController,
                    cursorColor: AppColors.solid_black,
                    focusNode: _inputFocus,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 16.dp(), top: 19.dp()),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.bg_light_grey, width: 2),
                          borderRadius:
                              BorderRadius.all(Radius.circular(8.dp()))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.bg_light_grey, width: 2),
                          borderRadius:
                              BorderRadius.all(Radius.circular(8.dp()))),
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: AppColors.solid_black,
                        letterSpacing: 10.dp(),
                        fontSize: 24.sp(),
                        fontWeight: FontWeight.w700,
                        fontFamily: Const.FONT_FAMILY_NUNITO),
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    onChanged: (text) {
                      if (text.length == Const.OTP_MAX_LENGTH) {
                        _login();
                      }
                    },
                    inputFormatters: <TextInputFormatter>[
                      _lengthInputFormatter
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.dp(), bottom: 4.dp()),
                    child: Text(
                      Strings.get(context,
                          Strings.CONFIRMATION_CODE_WITH_SMS_SEND_ON_NUMBER),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.solid_black_60,
                          fontFamily: Const.FONT_FAMILY_NUNITO,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp()),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    _arguments.formattedPhone,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.solid_black,
                        fontFamily: Const.FONT_FAMILY_NUNITO,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp()),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ];
  }

  Widget _buildTimerBlock() {
    return StreamBuilder<TimerEntity>(
      stream: _bloc.timerStream,
      initialData: TimerEntity(_bloc.currentTime, _bloc.currentTime <= 0),
      builder: (BuildContext context, AsyncSnapshot<TimerEntity> snapshot) {
        return Container(
            height: 88.dp(),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16.dp()),
            child: _createTimerHint(
                snapshot.data.timesLeft, snapshot.data.isEnabled));
      },
    );
  }

  Widget _createTimerHint(int time, bool enabled) {
    var text;
    var textTimer;
    if (enabled) {
      text = Strings.get(context, Strings.SEND_AGAIN);
    } else {
      text = Strings.get(context, Strings.PRE_SEND_AGAIN);
      textTimer = time.toTimeString();
    }
    if (enabled) {
      return GestureDetector(
        onTap: () => {
          if (enabled) {_authenticateUserWithPhone()}
        },
        child: Container(
          padding: EdgeInsets.all(16.dp()),
          color: Colors.transparent,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10.dp()),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.solid_black,
                        fontSize: 14.sp(),
                        fontFamily: Const.FONT_FAMILY_NUNITO,
                        fontWeight: FontWeight.w600),
                  ),
                ),
//                Text(
//                  textTimer,
//                  textAlign: TextAlign.center,
//                  style: TextStyle(
//                      color: AppColors.solid_black,
//                      fontSize: 14.sp(),
//                      fontFamily: Const.FONT_FAMILY_NUNITO,
//                      fontWeight: FontWeight.w600),
//                ),
              ],
            ),
          ),
        ),
      );

    } else {
      return Container(
        padding: EdgeInsets.all(16.dp()),
        color: Colors.transparent,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10.dp()),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.solid_black,
                      fontSize: 14.sp(),
                      fontFamily: Const.FONT_FAMILY_NUNITO,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                textTimer,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.solid_black,
                    fontSize: 14.sp(),
                    fontFamily: Const.FONT_FAMILY_NUNITO,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _login() async {
    FocusScope.of(context).requestFocus(FocusNode()); //hide keyboard
    final otp = _inputController.text;
    AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _arguments.verificationId, smsCode: otp);

    await _bloc.signInWithCredential(credential).then((result) =>
        // You could potentially find out if the user is new
        // and if so, pass that info on, to maybe do a tutorial
        // if (result.additionalUserInfo.isNewUser)
        _authCompleted());
  }

  void _authenticateUserWithPhone() {
    PhoneVerificationFailed verificationFailed = (AuthException authException) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return ConfirmationDialog(
              title: Strings.get(context, Strings.ERROR_HAPPEN),
              description: authException.message,
              bottomButtonText: Strings.get(context, Strings.GOOD),
            );
          });
      print(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _bloc
          .signInWithCredential(phoneAuthCredential)
          .then((result) => _authCompleted());
      print('Received phone auth credential: $phoneAuthCredential');
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _bloc.changeVerificationId(verificationId);
      _bloc.runTimer(Const.TIMER_DELAY);
      print(
          'Please check your phone for the verification code. $verificationId');
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      print("auto retrieval timeout");
    };

    _bloc.verifyPhoneNumber(_arguments.formattedPhone, codeAutoRetrievalTimeout, codeSent,
        verificationCompleted, verificationFailed);
  }
  _authCompleted() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.REGISTRATION_SCREEN, (Route<dynamic> route) => false);
  }

}
