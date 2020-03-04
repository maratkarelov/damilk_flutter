import 'package:flutter/cupertino.dart';
import 'package:damilk_app/src/ui/screens/auth/otp/otp_widget.dart';

class OtpScreen extends StatefulWidget {
  final OtpScreenArguments _arguments;

  OtpScreen(this._arguments);

  @override
  State<StatefulWidget> createState() {
    return OtpWidget(_arguments);
  }
}

class OtpScreenArguments {
  final String formattedPhone;
  final int timeToNext;

  OtpScreenArguments(this.formattedPhone, this.timeToNext);
}