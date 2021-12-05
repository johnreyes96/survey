import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:survey_app/helpers/api_helper.dart';
import 'package:survey_app/models/response.dart';
import 'package:survey_app/models/survey.dart';
import 'package:survey_app/models/token.dart';
import 'package:survey_app/screens/wait_screen.dart';

class SurveyScreen extends StatefulWidget {
  final Token token;
  final Survey survey;

  // ignore: use_key_in_widget_constructors
  const SurveyScreen({required this.token, required this.survey});

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  bool _showLoader = false;

  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;
  TextEditingController _emailController = TextEditingController();

  String _rating = '';
  String _ratingError = '';
  bool _ratingShowError = false;
  TextEditingController _ratingController = TextEditingController();

  String _theBest = '';
  String _theBestError = '';
  bool _theBestShowError = false;
  TextEditingController _theBestController = TextEditingController();

  String _theWorst = '';
  String _theWorstError = '';
  bool _theWorstShowError = false;
  TextEditingController _theWorstController = TextEditingController();

  String _remarks = '';
  String _remarksError = '';
  bool _remarksShowError = false;
  TextEditingController _remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFieldValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuestionario'),
        backgroundColor: const Color(0xFF004489),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                _showEmail(),
                _showRating(),
                _showTheBest(),
                _showTheWorst(),
                _showRemarks(),
                _showButtons(),
              ],
            ),
          ),
          _showLoader ? const WaitScreen() : Container(),
        ],
      ),
    );
  }

  void _loadFieldValues() {
    _email = widget.survey.email;
    _emailController.text = _email;

    _rating = widget.survey.qualification.toString();
    _ratingController.text = _rating;
    
    _theBest = widget.survey.theBest;
    _theBestController.text = _theBest;
    
    _theWorst = widget.survey.theWorst;
    _theWorstController.text = _theWorst;
    
    _remarks = widget.survey.remarks;
    _remarksController.text = _remarks;
  }

  Widget _showEmail() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Ingresa email...',
          labelText: 'Email',
          errorText: _emailShowError ? _emailError : null,
          suffixIcon: const Icon(Icons.email),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _showRating() {
    return Container();
  }

  Widget _showTheBest() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLength: 200,
        controller: _theBestController,
        decoration: InputDecoration(
          hintText: 'Ingresa lo mejor del curso...',
          labelText: 'Lo mejor del curso',
          errorText: _theBestShowError ? _theBestError : null,
          suffixIcon: const Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          )
        ),
        onChanged: (value) {
          _theBest = value;
        },
      ),
    );
  }

  Widget _showTheWorst() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLength: 200,
        controller: _theWorstController,
        decoration: InputDecoration(
          hintText: 'Ingresa lo peor del curso...',
          labelText: 'Lo peor del curso',
          errorText: _theWorstShowError ? _theWorstError : null,
          suffixIcon: const Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          )
        ),
        onChanged: (value) {
          _theWorst = value;
        },
      ),
    );
  }

  Widget _showRemarks() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLength: 200,
        controller: _remarksController,
        decoration: InputDecoration(
          hintText: 'Ingresa un comentario...',
          labelText: 'Comentario',
          errorText: _remarksShowError ? _remarksError : null,
          suffixIcon: const Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          )
        ),
        onChanged: (value) {
          _remarks = value;
        },
      ),
    );
  }

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: const Text('Guardar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return const Color(0xFF120E43);
                  }
                )
              ),
              onPressed: () => _save()
            ),
          )
        ],
      ),
    );
  }

  void _save() {
    if (!_validateFields()) {
      return;
    }

    _saveInfo();
  }

  bool _validateFields() {
    bool isValid = true;

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un email.';
    } else if (!EmailValidator.validate(_email)) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un email válido.';
    } else if (validateITMDomain()) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un email con dominio ITM.';
    } else {
      _emailShowError = false;
    }

    if (_rating.isEmpty) {
      isValid = false;
      _ratingShowError = true;
      _ratingError = 'Debes seleccionar una puntuación.';
    } else {
      _ratingShowError = false;
    }
    
    if (_theBest.isEmpty) {
      isValid = true;
      _theBestShowError = true;
      _theBestError = 'Debes ingresar lo mejor del curso.';
    } else {
      _theBestShowError = false;
    }
    
    if (_theWorst.isEmpty) {
      isValid = true;
      _theWorstShowError = true;
      _theWorstError = 'Debes ingresar lo peor del curso.';
    } else {
      _theWorstShowError = false;
    }
    
    if (_remarks.isEmpty) {
      isValid = true;
      _remarksShowError = true;
      _remarksError = 'Debes ingresar un comentario.';
    } else {
      _remarksShowError = false;
    }

    setState(() { });
    return isValid;
  }

  void _saveInfo() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });

      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Verifica que estés conectado a internet.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar')
        ]
      );
      return;
    }

    Map<String, dynamic> request = {
      'email': _email,
      'qualification': _rating,
      'theBest': _theBest,
      'theWorst': _theWorst,
      'remarks': _remarks
    };

    Response response = await ApiHelper.post(
      '/api/Finals',
      request,
      widget.token
    );

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: response.message,
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar')
        ]
      );
      return;
    }

    if (response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: '',
        message: 'Se ha guardado éxitosamente',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar')
        ]
      );
      return;
    };
  }

  bool validateITMDomain() {
    bool isITMDomain = false;
    String firstITMDomain = 'correo.itm.edu.co';
    String secondITMDomain = 'itm.edu.co';
    if (_email.toLowerCase().contains(firstITMDomain) ||
        _email.toLowerCase().contains(secondITMDomain)) {
      isITMDomain = true;
    }
    return !isITMDomain;
  }
}