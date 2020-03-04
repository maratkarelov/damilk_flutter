import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sim23/src/resources/dimen.dart';
import 'package:sim23/src/ui/screens/auth/congratulation/congratulation_screen.dart';
import 'package:sim23/src/ui/screens/auth/otp/otp_screen.dart';
import 'package:sim23/src/ui/screens/auth/phone/login_screen.dart';
import 'package:sim23/src/ui/screens/auth/registration/registration_screen.dart';
import 'package:sim23/src/ui/screens/auth/tutorial/tutorial_screen.dart';
import 'package:sim23/src/ui/screens/dashboard/dashboard_screen.dart';

import 'app_routing_names.dart';

class FlagmanAppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget screen;
    switch (settings.name) {
      case AppRoutes.DASHBOARD_SCREEN:
        screen = DashboardScreen();
        break;
      case AppRoutes.LOGIN_SCREEN:
        screen = LoginScreen(
          errorResponse: settings.arguments,
        );
        break;
      case AppRoutes.TUTORIAL_SCREEN:
        screen = TutorialScreen();
        break;
      case AppRoutes.OTP_SCREEN:
        screen = OtpScreen(settings.arguments);
        break;
      case AppRoutes.CONGRATULATION_SCREEN:
        screen = CongratulationScreen(settings.arguments);
        break;
      case AppRoutes.REGISTRATION_SCREEN:
        screen = RegistrationScreen();
        break;
      default:
        screen = null;
        break;
    }

    return Platform.isAndroid
        ? MaterialPageRoute(
            builder: (context) {
              Dimen.init(MediaQuery.of(context).devicePixelRatio);
              return screen;
            },
            settings: settings)
        : CupertinoPageRoute(
            builder: (context) {
              Dimen.init(MediaQuery.of(context).devicePixelRatio);
              return screen;
            },
            settings: settings);
  }
}
