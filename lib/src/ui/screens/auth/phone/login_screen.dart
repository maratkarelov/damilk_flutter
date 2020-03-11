import 'package:flutter/widgets.dart';
import 'package:damilk_app/src/repository/remote/api/models/base_response.dart';
import 'package:damilk_app/src/ui/screens/auth/phone/login_widget.dart';

class LoginScreen extends StatefulWidget {
  final BaseResponse errorResponse;

  LoginScreen({this.errorResponse});

  @override
  State<StatefulWidget> createState() {
    return LoginWidget();
  }

}
