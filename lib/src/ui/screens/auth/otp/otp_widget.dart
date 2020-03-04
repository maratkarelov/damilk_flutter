import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:damilk_app/src/bloc/provider/block_provider.dart';
import 'package:damilk_app/src/resources/colors.dart';
import 'package:damilk_app/src/resources/const.dart';
import 'package:damilk_app/src/resources/drawables.dart';
import 'package:damilk_app/src/resources/strings.dart';
import 'package:damilk_app/src/router/app_routing_names.dart';
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
    _bloc.runTimer(_arguments.timeToNext);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_inputFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brand_grey,
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
    );
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
            padding: EdgeInsets.only(bottom: 88.dp()),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.dp()),
                  bottomRight: Radius.circular(16.dp())),
              child: Container(
                color: AppColors.bg_light_grey,
              ),
            ),
          ),
          Drawables.getImage(Drawables.RECTANGLE_BACKGROUND_SMALL),
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
              padding: EdgeInsets.only(top: 55.dp()),
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
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.dp())),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: AppColors.white,
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
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.dp(), bottom: 4.dp()),
                    child: Text(
                      Strings.get(context,
                          Strings.CONFIRMATION_CODE_WITH_SMS_SEND_ON_NUMBER),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: AppColors.solid_black_60,
                          fontFamily: Const.FONT_FAMILY_NUNITO,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp()),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _arguments.formattedPhone,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: AppColors.solid_black,
                        fontFamily: Const.FONT_FAMILY_NUNITO,
                        fontWeight: FontWeight.w600,
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
    if (enabled) {
      text = Strings.get(context, Strings.SEND_AGAIN);
    } else {
      text = time.toTimeString();
    }
    return GestureDetector(
      onTap: () => {
        if (enabled) {_resendOtp()}
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
                child: Drawables.getImage(Drawables.IC_REPEAT),
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.white_60,
                    fontSize: 14.sp(),
                    fontFamily: Const.FONT_FAMILY_NUNITO,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    FocusScope.of(context).requestFocus(FocusNode()); //hide keyboard

    final phone = _arguments.formattedPhone;
    final otp = _inputController.text;
    final response = await _bloc.login(phone, otp);

    if (response.isSuccessful()) {
      final clientModel = response.data.clientModel;
      final registered = clientModel.firstName.isNotEmpty;
      if (registered) {
        String name = clientModel.firstName;
        String lastName = clientModel.lastName;
        if (lastName != null && lastName.isNotEmpty) {
          name += " " + lastName;
        }
//        Navigator.of(context).pushNamedAndRemoveUntil(
//            AppRoutes.CONGRATULATION_SCREEN, (Route<dynamic> route) => false,
//            arguments: CongratulationArguments(name, false));
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.REGISTRATION_SCREEN, (Route<dynamic> route) => false);
      }
    } else {
      String bottomButtonText = Strings.get(context, Strings.GOOD);
      bool isNetworkError = response.code == Const.NETWORK_CONNECTION;

      if (isNetworkError) {
        response.title = Strings.get(context, Strings.ERROR_HAPPEN);
        response.message = Strings.get(context, Strings.CHECK_CONNECTION);
      }

      showModalBottomSheet(
          context: context,
          builder: (context) {
            return ConfirmationDialog(
                title: response.title,
                description: response.message,
                bottomButtonText: bottomButtonText);
          });
    }
  }

  void _resendOtp() async {
    FocusScope.of(context).requestFocus(FocusNode()); //hide keyboard

    final response = await _bloc.requestOtp(_arguments.formattedPhone);
    if (response.isSuccessful() || response.code == 429) {
      final timeToNext = response.data.timeToNext;
      _bloc.runTimer(timeToNext);
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
//              onTopClicked: () => {MailTool.preSendSupportMail()},
              onBottomClicked: () => {
                //ignore
              },
            );
          });
    }
  }
}
