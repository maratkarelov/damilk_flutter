import 'package:damilk_app/src/resources/dimen.dart';

extension DoubleParser on double {
  double dp() {
    return Dimen.pixelsScaleFactor * this;
  }

  double sp() {
    var result = Dimen.fontScaleFactor * this;
    if (result < 10) {
      return 10;
    }

    return Dimen.fontScaleFactor * this;
  }
}

extension IntParser on int {
  double dp() {
    return Dimen.pixelsScaleFactor * this;
  }

  double sp() {
    var result = Dimen.fontScaleFactor * this;
    if (result < 10) {
      return 10;
    }
    return Dimen.fontScaleFactor * this;
  }

  ///return int value, in format "mm:ss"
  ///E.g. 01:15 for value 75, which means 1 min 15 sec
  String toTimeString() {
    String result = "";
    int minutes = this ~/ 60;
    int seconds = this % 60;

    result = minutes.toString();

    if(minutes < 10) {
      result = "0" + result;
    }
    result += ":";

    if(seconds < 10) {
      result +="0";
    }
    result += seconds.toString();

    return result;
  }
}
