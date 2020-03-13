import 'package:flutter/material.dart';
import 'package:damilk_app/src/tools/localization/app_translator.dart';

class Strings {
  static const String TUTORIAL_TITLE_ = "tutorial_title_";
  static const String TUTORIAL_DESCRIPTION_ = "tutorial_description_";
  static const String SKIP = "skip";
  static const String NEXT = "next";
  static const String AUTHORIZE = "authorize";
  static const String ENTER_PHONE_NUMBER = "enter_phone_number";
  static const String GET_SMS_NOTIFICATION = "get_sms_notification";
  static const String PHONE_NUMBER = "phone_number";
  static const String PHONE_INPUT_HINT = "phone_input_hint";
  static const String TERMS_OF_USE_1 = "terms_of_use_1";
  static const String TERMS_OF_USE_2 = "terms_of_use_2";
  static const String TERMS_OF_USE_3 = "terms_of_use_3";
  static const String TERMS_OF_USE_URL = "terms_of_use_url";
  static const String UKRAINIAN_COUNTRY_CODE = "ukrainian_country_code";
  static const String CODE_FROM_SMS = "code_from_sms";
  static const String CONFIRMATION_CODE_WITH_SMS_SEND_ON_NUMBER =
      "confirmation_code_with_sms_send_on_number";
  static const String SEND_AGAIN = "send_again";
  static const String PRE_SEND_AGAIN = "pre_send_again";
  static const String SUPPORT = "support";
  static const String LATER = "later";
  static const String ERROR_HAPPEN = "error_happen";
  static const String CHECK_CONNECTION = "check_connection";
  static const String GOOD = "good";
  static const String SIGN_IN = "sign_in";
  static const String CONGRATULATION_WITH_COMING_BACK =
      "congratulation_with_coming_back";
  static const String YOUR_PROFILE_PINNED_TO_ENTERED_PHONE =
      "your_profile_pinned_to_entered_phone";
  static const String REGISTRATION_CONGRATULATION_TITLE =
      "registration_congratulation_title";
  static const String REGISTRATION_CONGRATULATION_DESCRIPTION =
      "registration_congratulation_description";
  static const String REGISTRATION_SCREEN_TITLE = "registration_screen_title";
  static const String NAME = "name";
  static const String CITY = "city";
  static const String CHOOSE_YOUR_CITY = "choose_your_city";
  static const String CONFIRM = "confirm";

  static String get(BuildContext context, String key) {
    if (context != null) {
      return AppTranslations.of(context).text(key);
    } else {
      return "";
    }
  }

  static List<String> getArray(BuildContext context, String key) {
    if (context != null) {
      return AppTranslations.of(context).array(key);
    } else {
      return [];
    }
  }
}
