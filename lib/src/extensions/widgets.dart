import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:damilk_app/src/repository/remote/api/models/base_response.dart';
import 'package:damilk_app/src/resources/strings.dart';
import 'package:damilk_app/src/ui/widgets/confirmation_dialog.dart';

extension ErrorHandler on State {
  void handleFailure(BaseResponse errorResponse) {
    if (!errorResponse.isSuccessful()) {
      String bottomButtonText = Strings.get(context, Strings.GOOD);

      showModalBottomSheet(
          context: context,
          builder: (context) {
            return ConfirmationDialog(
              title: errorResponse.title == null
                  ? Strings.get(context, Strings.ERROR_HAPPEN)
                  : errorResponse.title,
              description: errorResponse.message == null
                  ? Strings.get(context, Strings.CHECK_CONNECTION)
                  : errorResponse.message,
              bottomButtonText: bottomButtonText,
              onTopClicked: () => {
                //ignore
              },
              onBottomClicked: () => {
                //ignore
              },
            );
          });
    }
  }
}
