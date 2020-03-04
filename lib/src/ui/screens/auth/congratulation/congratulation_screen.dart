import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sim23/src/extensions/parser.dart';
import 'package:sim23/src/resources/colors.dart';
import 'package:sim23/src/resources/const.dart';
import 'package:sim23/src/resources/drawables.dart';
import 'package:sim23/src/resources/strings.dart';
import 'package:sim23/src/router/app_routing_names.dart';

class CongratulationScreen extends StatelessWidget {
  final CongratulationArguments _arguments;

  CongratulationScreen(this._arguments);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brand_grey,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 88.dp()),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.dp()),
                  bottomRight: Radius.circular(16.dp())),
              child: Container(
                color: AppColors.white,
              ),
            ),
          ),
          Container(
            child: Drawables.getImage(Drawables.OK_BACKGROUND),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildScreenContent(context),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: _buildBottomButtons(context))
        ],
      ),
    );
  }

  Widget _buildScreenContent(BuildContext context) {
    String title = _arguments.name;
    String description;
    if (_arguments.afterRegistration) {
      title += Strings.get(context, Strings.REGISTRATION_CONGRATULATION_TITLE);
      description =
          Strings.get(context, Strings.REGISTRATION_CONGRATULATION_DESCRIPTION);
    } else {
      title += Strings.get(context, Strings.CONGRATULATION_WITH_COMING_BACK);
      description =
          Strings.get(context, Strings.YOUR_PROFILE_PINNED_TO_ENTERED_PHONE);
    }

    return Wrap(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(left: 24.dp(), right: 24.dp(), bottom: 16.dp()),
          child: Text(
            title,
            style: TextStyle(
                color: AppColors.solid_black,
                fontSize: 24.sp(),
                fontFamily: Const.FONT_FAMILY_NUNITO,
                fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(left: 24.dp(), right: 24.dp(), bottom: 112.dp()),
          child: Text(
            description,
            style: TextStyle(
                color: AppColors.solid_black_60,
                fontSize: 14.sp(),
                fontFamily: Const.FONT_FAMILY_NUNITO,
                fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          onTap: () => {
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.DASHBOARD_SCREEN, (route) => false)
          },
          child: Container(
            height: 88.dp(),
            padding: EdgeInsets.only(top: 24.dp(), bottom: 24.dp()),
            color: AppColors.transparent,
            child: Center(
              child: Text(
                Strings.get(context, Strings.SIGN_IN),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14.sp(),
                    fontFamily: Const.FONT_FAMILY_NUNITO,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: 8.dp(), right: 24.dp(), top: 24.dp(), bottom: 24.dp()),
          child: Drawables.getImage(Drawables.ARROW_RIGHT),
        )
      ],
    );
  }
}

class CongratulationArguments {
  final String name;
  final bool afterRegistration;

  CongratulationArguments(this.name, this.afterRegistration);
}
