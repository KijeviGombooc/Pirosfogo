import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScoreTextField extends StatelessWidget {
  final TextEditingController? controller;
  final int initValue;

  bool get hasController {
    return controller != null;
  }

  TextEditingController get defaultController {
    return TextEditingController()..text = initValue.toString();
  }

  ScoreTextField({this.controller, this.initValue = 0}) {
    if (controller != null) {
      if (this.controller!.text.isEmpty) this.controller!.text = "0";
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.center,
      controller: hasController ? controller : defaultController,
      enabled: hasController ? true : false,
      onTap: hasController ? _focusText : null,
      keyboardType: TextInputType.number,
      inputFormatters: [ScoreInputFormatter()],
    );
  }

  _focusText() {
    controller!.selection =
        TextSelection(baseOffset: 0, extentOffset: controller!.text.length);
  }
}

class ScoreInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int? val = int.tryParse(newValue.text);
    if (val == null || val < 0 || val > 8)
      return oldValue;
    else
      return newValue;
  }
}
