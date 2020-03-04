import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

//format ukrainian phone numbers without prefix (e.g. ## ### ## ##)
//created by Rogdan [rogdan.work@gmail.com]

class NumberTextInputFormatter extends TextInputFormatter {
  WhitelistingTextInputFormatter formatter =
      WhitelistingTextInputFormatter(new RegExp(r'\d+'));
  bool lastBack = false;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    newValue = _removeDigitBeforeSpaceIfNeed(oldValue, newValue);
    TextEditingValue formattedValue =
        formatter.formatEditUpdate(oldValue, newValue);

    if (oldValue.text == newValue.text) {
      return newValue;
    }

    final int newTextLength = formattedValue.text.length;

    int selectionIndex = formattedValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();

    if (newTextLength >= 3) {
      newText.write(
          formattedValue.text.substring(0, usedSubstringIndex = 2) + ' ');
      if (formattedValue.selection.end >= 2) selectionIndex++;
    }

    if (newTextLength >= 6) {
      newText.write(
          formattedValue.text.substring(2, usedSubstringIndex = 5) + ' ');
      if (formattedValue.selection.end >= 5) selectionIndex++;
    }

    if (newTextLength >= 8) {
      newText.write(
          formattedValue.text.substring(5, usedSubstringIndex = 7) + ' ');
      if (formattedValue.selection.end >= 7) selectionIndex++;
    }

    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(formattedValue.text.substring(usedSubstringIndex));

    if (oldValue != null &&
        oldValue.text != null &&
        oldValue.text.length > newText.toString().length) {}

    if (oldValue.text == newText.toString()) {
      return oldValue;
    }

    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }

  TextEditingValue _removeDigitBeforeSpaceIfNeed(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    int oldLength = oldValue.text.length;
    int newLength = newValue.text.length;

    if (oldLength > newLength && (oldLength - newLength == 1)) {
      for (int i = 0; i < newLength; i++) {
        String oldChar = oldValue.text.substring(i, i + 1);
        String newChar = newValue.text.substring(i, i + 1);
        if (oldChar != newChar && i == newValue.selection.end) {
          if (oldChar == " ") {
            String removing =
                newValue.text.substring(0, i - 1) + newValue.text.substring(i);
            final newSelection = TextSelection(
                baseOffset: newValue.selection.baseOffset - 1,
                extentOffset: newValue.selection.extentOffset - 1);

            return TextEditingValue(text: removing, selection: newSelection);
          }
          break;
        }
      }
    }

    return newValue;
  }
}
