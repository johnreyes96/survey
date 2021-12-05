import 'dart:convert';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'package:survey_app/helpers/constants.dart';
import 'package:survey_app/models/token.dart';
import 'package:survey_app/screens/survey_screen.dart';
import 'package:survey_app/screens/wait_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showLoader = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFccdbeb),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 100),
                _showButtons(),
              ]
            )
          ),
          _showLoader ? const WaitScreen() : Container()
        ]
      )
    );
  }

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          _showGoogleLoginButton(),
        ],
      ),
    );
  }

  Widget _showGoogleLoginButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _loginGoogle(),
            icon: const FaIcon(
              FontAwesomeIcons.google,
              color: Colors.red,
            ),
            label: const Text('Iniciar sesión con Google'),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black
            )
          )
        )
      ],
    );
  }

  void _loginGoogle() async {
    setState(() {
      _showLoader = true;
    });

    var googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    var user = await googleSignIn.signIn();

    Map<String, dynamic> request = {
      'email': user?.email,
      'id': user?.id,
      'loginType': 1,
      'fullname': user?.displayName,
      'photoURL': user?.photoUrl,
    };

    if (user == null) {
      setState(() {
        _showLoader = false;
      });
 
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Hubo un problema al obtener el usuario de Google, por favor intenta más tarde.',
        actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    await _socialLogin(request);
  }

  Future _socialLogin(Map<String, dynamic> request) async {
    var url = Uri.parse('${Constants.apiUrl}/api/account/SocialLogin');
    var response = await http.post(
      url,
      headers: {
        'content-Type': 'application/json',
        'accept': 'application/json'
      },
      body: jsonEncode(request)
    );

    setState(() {
      _showLoader = false;
    });

    if (response.statusCode >= 400) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'El usuario ya inició sesión previamente por email o por otra red social',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar')
        ]
      );
      return;
    }

    var body = response.body;

    var decodedJson = jsonDecode(body);
    var token = Token.fromJson(decodedJson);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SurveyScreen(token: token)
      )
    );
  }
}