import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:damilk_app/src/resources/colors.dart';
import 'package:damilk_app/src/extensions/parser.dart';
import 'package:damilk_app/src/resources/const.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title, description, topButtonText, bottomButtonText;
  final Function onTopClicked, onBottomClicked;

  ConfirmationDialog(
      {this.title,
      this.description = "",
      this.topButtonText = "",
      this.bottomButtonText = "",
      this.onTopClicked,
      this.onBottomClicked});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.dialog_grey,
      child: Container(
        child: _buildDialogContent(context),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.dp()),
                topRight: Radius.circular(16.dp()))),
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Center(
          child: Padding(
            padding:
                EdgeInsets.only(left: 20.dp(), right: 20.dp(), top: 24.dp()),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.solid_black,
                  fontSize: 24.sp(),
                  fontFamily: Const.FONT_FAMILY_NUNITO,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding:
                EdgeInsets.only(left: 24.dp(), right: 24.dp(), top: 16.dp()),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.solid_black_60,
                  fontSize: 16.sp(),
                  fontFamily: Const.FONT_FAMILY_NUNITO,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => {
            Navigator.pop(context),
            if (onTopClicked != null) {onTopClicked()}
          },
          child: Container(
            height: 56.dp(),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
                top: 43.dp(), left: 16.dp(), right: 16.dp(), bottom: 14.dp()),
            padding: EdgeInsets.only(top: 18.dp(), bottom: 18.dp()),
            color: AppColors.transparent,
            child: Text(
              topButtonText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14.sp(),
                  color: AppColors.solid_black,
                  fontFamily: Const.FONT_FAMILY_NUNITO,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Container(
          height: 72.dp(),
          padding:
              EdgeInsets.only(left: 16.dp(), right: 16.dp(), bottom: 16.dp()),
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.dp()),
                side: BorderSide(color: AppColors.yellow)),
            color: AppColors.yellow,
            onPressed: () => {
              Navigator.pop(context),
              if (onBottomClicked != null) {onBottomClicked()}
            },
            child: Text(
              bottomButtonText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.solid_black,
                  fontSize: 14.sp(),
                  fontFamily: Const.FONT_FAMILY_NUNITO,
                  fontWeight: FontWeight.w600),
            ),
          ),
        )
      ],
    );
  }
}
