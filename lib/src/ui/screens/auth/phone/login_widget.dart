import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:damilk_app/src/bloc/provider/block_provider.dart';
import 'package:damilk_app/src/repository/remote/api/models/base_response.dart';
import 'package:damilk_app/src/resources/colors.dart';
import 'package:damilk_app/src/resources/const.dart';
import 'package:damilk_app/src/extensions/parser.dart';
import 'package:damilk_app/src/resources/drawables.dart';
import 'package:damilk_app/src/resources/strings.dart';
import 'package:damilk_app/src/router/app_routing_names.dart';
import 'package:damilk_app/src/tools/phone_input_formatter.dart';
import 'package:damilk_app/src/ui/screens/auth/otp/otp_screen.dart';
import 'package:damilk_app/src/ui/screens/auth/phone/login_bloc.dart';
import 'package:damilk_app/src/ui/screens/auth/phone/login_screen.dart';
import 'package:damilk_app/src/ui/widgets/confirmation_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:damilk_app/src/extensions/widgets.dart';

class LoginWidget extends State<LoginScreen> {
  BaseResponse errorResponse;

  LoginBloc _bloc;
  bool _phoneEntered = false;
  TextEditingController _inputController;
  final _inputFocus = FocusNode();

  final _lengthInputFormatter =
      LengthLimitingTextInputFormatter(Const.FORMATTED_PHONE_MAX_LENGTH);
  final _inputFormatter = NumberTextInputFormatter();

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: "");
    _bloc = LoginBloc();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_inputFocus);
      if (errorResponse != null) {
        handleFailure(errorResponse);
        errorResponse = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_light_grey,
      body: StreamBuilder(
        stream: _bloc.progressStream,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return ModalProgressHUD(
            child: _buildScreenContent(),
            inAsyncCall: snapshot.data,
          );
        },
      ),
    );
  }

  Widget _buildScreenContent() {
    return BlocProvider<LoginBloc>(
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
                color: AppColors.bg_light_grey,
              ),
            ),
          ),
          //  Drawables.getImage(Drawables.RECTANGLE_BACKGROUND_SMALL),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 40.dp()),
              child: Column(
                children: _buildPhoneInputWidget(),
              ),
            ),
          ),
//          Align(alignment: Alignment.bottomCenter, child: _buildTermsOfUse()),
          Align(alignment: Alignment.bottomCenter, child: _buildBottomButton())
        ],
      ),
    );
  }

  List<Widget> _buildPhoneInputWidget() {
    return <Widget>[
      Text(
        Strings.get(context, Strings.PHONE_NUMBER),
        style: TextStyle(
            color: AppColors.solid_black,
            fontSize: 18,
            fontFamily: Const.FONT_FAMILY_NUNITO,
            fontWeight: FontWeight.w700),
      ),
      Padding(
        padding: EdgeInsets.only(left: 16.dp(), right: 16.dp(), top: 40.dp()),
        child: ClipRect(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: AppColors.white,
            padding: EdgeInsets.only(
                left: 24.dp(), right: 24.dp(), bottom: 24.dp(), top: 19.dp()),
            child: Column(
              children: <Widget>[
                Container(
                  height: 59.dp(),
                  padding: EdgeInsets.only(bottom: 11.dp()),
                  child: Row(
                    children: <Widget>[
                      Text(
                        Strings.get(context, Strings.UKRAINIAN_COUNTRY_CODE),
                        style: TextStyle(
                            color: AppColors.solid_black,
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp(),
                            fontFamily: Const.FONT_FAMILY_NUNITO),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 22.dp()),
                          child: TextField(
                            controller: _inputController,
                            cursorColor: AppColors.solid_black,
                            focusNode: _inputFocus,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 16.dp(), top: 19.dp()),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.bg_light_grey,
                                        width: 2.dp()),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8.dp()))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.bg_light_grey,
                                        width: 2.dp()),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8.dp()))),
                                suffixIcon: IconButton(
                                  onPressed: () => {
                                    _inputController.clear(),
                                    setState(() {
                                      _phoneEntered = false;
                                    })
                                  },
                                  icon: Drawables.getImage(Drawables.IC_CLEAR),
                                )),
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                                color: AppColors.solid_black,
                                fontSize: 18.sp(),
                                fontWeight: FontWeight.w700,
                                fontFamily: Const.FONT_FAMILY_NUNITO),
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                            onChanged: (text) {
                              setState(() {
                                _phoneEntered = text.length ==
                                    Const.FORMATTED_PHONE_MAX_LENGTH;
                              });
                            },
                            inputFormatters: <TextInputFormatter>[
                              _lengthInputFormatter,
                              _inputFormatter
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  Strings.get(context, Strings.PHONE_INPUT_HINT),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.solid_black,
                      fontFamily: Const.FONT_FAMILY_NUNITO,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp()),
                )
              ],
            ),
          ),
        ),
      )
    ];
  }

  Widget _buildTermsOfUse() {
    return Padding(
      padding: EdgeInsets.only(left: 16.dp(), right: 16.dp(), bottom: 100.dp()),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: Strings.get(context, Strings.TERMS_OF_USE_1),
              style: TextStyle(
                  color: AppColors.solid_black_60,
                  fontSize: 12.sp(),
                  fontFamily: Const.FONT_FAMILY_NUNITO,
                  fontWeight: FontWeight.w600)),
          TextSpan(
              text: Strings.get(context, Strings.TERMS_OF_USE_2),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch(Strings.get(context, Strings.TERMS_OF_USE_URL));
                },
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: AppColors.solid_black_60,
                  fontSize: 12.sp(),
                  fontFamily: Const.FONT_FAMILY_NUNITO,
                  fontWeight: FontWeight.w500)),
          TextSpan(
              text: Strings.get(context, Strings.TERMS_OF_USE_3),
              style: TextStyle(
                  color: AppColors.solid_black_60,
                  fontSize: 12.sp(),
                  fontFamily: Const.FONT_FAMILY_NUNITO,
                  fontWeight: FontWeight.w600))
        ]),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      height: 88.dp(),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(16.dp()),
      child: _phoneEntered ? _createPhoneButton() : _createPhoneHint(),
    );
  }

  Widget _createPhoneButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.dp()),
          side: BorderSide(color: AppColors.primary)),
      color: AppColors.primary,
      onPressed: () {
        var formattedPhone =
            Strings.get(context, Strings.UKRAINIAN_COUNTRY_CODE) +
                " " +
                _inputController.text;
        _authenticateUserWithPhone(formattedPhone);
      },
      child: Text(
        Strings.get(context, Strings.GET_SMS_NOTIFICATION),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: AppColors.white,
            fontSize: 14.sp(),
            fontFamily: Const.FONT_FAMILY_NUNITO,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _createPhoneHint() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.dp()),
          side: BorderSide(color: AppColors.bg_light_grey)),
      color: AppColors.bg_light_grey,
      onPressed: () {
        var formattedPhone =
            Strings.get(context, Strings.UKRAINIAN_COUNTRY_CODE) +
                " " +
                _inputController.text;
        _authenticateUserWithPhone(formattedPhone);
      },
      child: Text(
        Strings.get(context, Strings.GET_SMS_NOTIFICATION),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: AppColors.solid_black_60,
            fontSize: 14.sp(),
            fontFamily: Const.FONT_FAMILY_NUNITO,
            fontWeight: FontWeight.w600),
      ),
    );

  }

  void _authenticateUserWithPhone(String formattedPhone) {
    PhoneVerificationFailed verificationFailed = (AuthException authException) {
//      _bloc.changeAuthStatus(AuthStatus.phoneAuth);
//      _showSnackBar(Constants.verificationFailed);
      //TODO: show error to user.
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
      _codeSent();
      print(
          'Please check your phone for the verification code. $verificationId');
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      print("auto retrieval timeout");
    };

//    _bloc.changeAuthStatus(AuthStatus.smsSent);
    _bloc.verifyPhoneNumber(formattedPhone, codeAutoRetrievalTimeout, codeSent,
        verificationCompleted, verificationFailed);
  }

  void _requestOtp(String formattedPhone) async {
    FocusScope.of(context).requestFocus(FocusNode()); //hide keyboard

    final response = await _bloc.requestOtp(formattedPhone);
    if (response.isSuccessful() || response.code == 429) {
      final timeToNext = response.data.timeToNext;
      Navigator.of(context).pushNamed(AppRoutes.OTP_SCREEN,
          arguments:
              OtpScreenArguments(formattedPhone, _bloc.getVerificationId));
    } else {
      String topButtonText = Strings.get(context, Strings.SUPPORT);
      String bottomButtonText = Strings.get(context, Strings.LATER);
      bool isNetworkError = response.code == Const.NETWORK_CONNECTION;

      if (isNetworkError) {
        response.title = Strings.get(context, Strings.ERROR_HAPPEN);
        response.message = Strings.get(context, Strings.CHECK_CONNECTION);
        topButtonText = "";
        bottomButtonText = Strings.get(context, Strings.GOOD);
      }

      showModalBottomSheet(
          context: context,
          builder: (context) {
            return ConfirmationDialog(
              title: response.title,
              description: response.message,
              topButtonText: topButtonText,
              bottomButtonText: bottomButtonText,
              onTopClicked: isNetworkError
                  ? null
                  : () => {
//                        {MailTool.preSendSupportMail()}
                      },
              onBottomClicked: () => {
                //ignore
              },
            );
          });
    }
  }

  _showSnackBar(String error) {
    final snackBar = SnackBar(content: Text(error));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _authCompleted() {
    Navigator.of(context).pushNamed(AppRoutes.DASHBOARD_SCREEN);
  }

  _codeSent() {
    var formattedPhone = Strings.get(context, Strings.UKRAINIAN_COUNTRY_CODE) +
        " " +
        _inputController.text;

    Navigator.of(context).pushNamed(AppRoutes.OTP_SCREEN,
        arguments: OtpScreenArguments(formattedPhone, _bloc.getVerificationId));
  }

  @override
  void dispose() {
    _bloc.dispose();
    _inputFocus.dispose();
    _inputController.dispose();
    super.dispose();
  }
}
