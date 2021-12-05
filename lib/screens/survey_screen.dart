import 'package:flutter/material.dart';
import 'package:survey_app/models/token.dart';

class SurveyScreen extends StatefulWidget {
  final Token token;

  // ignore: use_key_in_widget_constructors
  const SurveyScreen({required this.token});

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Formulario')
    );
  }
}