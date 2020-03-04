import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class Drawables {
  static const String IMAGES_PATH = "assets/images/";
  static const String PNG = ".png";
  static const String SVG = ".svg";

  static const String TUTORIAL_PAGE_ = "tutorial_page_";
  static const String TUTORIAL_PAGE_1 = "tutorial_page_1.svg";
  static const String TUTORIAL_PAGE_2 = "tutorial_page_2.svg";
  static const String TUTORIAL_PAGE_3 = "tutorial_page_3.svg";
  static const String RECTANGLE_BACKGROUND = "rectangle_background.png";
  static const String RECTANGLE_BACKGROUND_SMALL =
      "rectangle_background_small.png";
  static const String ARROW_RIGHT = "arrow_right.svg";
  static const String IC_CLEAR = "ic_clear.svg";
  static const String IC_BACK = "ic_back.svg";
  static const String IC_REPEAT = "ic_repeat.png";
  static const String OK_BACKGROUND = "ok_background.png";
  static const REGISTRATION_TRIANGLE_BACKGROUND =
      "registration_triangle_background.png";
  static const String ARROW_DOWN = "arrow_down.svg";
  static const String IC_CLOSE = "ic_close.svg";

  static SvgPicture getSizedSvg(String name, double width, double height) {
    return name.isEmpty
        ? null
        : SvgPicture.asset(
            IMAGES_PATH + name,
            width: width,
            height: height,
            fit: BoxFit.fill,
          );
  }

  static SvgPicture getSvg(String name, {Color tint}) {
    return name.isEmpty
        ? null
        : SvgPicture.asset(
            IMAGES_PATH + name,
            color: tint,
          );
  }

  // return png picture, depend on current device screen scale factor
  // e.g. for device with scale factor 2.7 will return image from folder
  // images/3.0x/name
  static Image getPng(String name, {Color tint}) {
    return name.isEmpty ? null : Image.asset(IMAGES_PATH + name, color: tint);
  }

  static Widget getImage(String name, {Color tint}) {
    if (name.endsWith(PNG)) {
      return getPng(name, tint: tint);
    } else {
      return getSvg(name, tint: tint);
    }
  }
}
