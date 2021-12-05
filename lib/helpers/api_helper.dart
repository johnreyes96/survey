import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:survey_app/helpers/constants.dart';
import 'package:survey_app/models/response.dart';
import 'package:survey_app/models/survey.dart';
import 'package:survey_app/models/token.dart';

class ApiHelper {

  static Future<Response> post(String controller, Map<String, dynamic> request, Token token) async {
    if (!_validToken(token)) {
      return Response(isSuccess: false, message: 'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    
    var url = Uri.parse('${Constants.apiUrl}$controller');
    var response = await http.post(
      url,
      headers: {
        'content-Type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}'
      },
      body: jsonEncode(request)
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

  static Future<Response> getSurvey(Token token) async {
    if (!_validToken(token)) {
      return Response(isSuccess: false, message: 'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }

    var url = Uri.parse('${Constants.apiUrl}/api/Finals');
    var response = await http.get(
      url,
      headers: {
        'content-Type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}'
      }
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Survey.fromJson(decodedJson));
  }

  static bool _validToken(Token token) {
    if (DateTime.parse(token.expiration).isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }
}