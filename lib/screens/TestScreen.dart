import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pirosfogo/widgets/ScoreTextField.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: "Initial value");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScoreTextField(controller: _textEditingController),
      ),
    );
  }
}
