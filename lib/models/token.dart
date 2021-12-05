import 'package:survey_app/models/user.dart';

class Token {
  String token = '';
  String expiration = '';
  User user = User(
    firstName: '',
    lastName: '',
    photoURL: '',
    loginType: 1,
    fullName: '',
    id: '',
    email: ''
  );

  Token({
    required this.token,
    required this.expiration,
    required this.user
  });

  Token.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiration = json['expiration'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['expiration'] = expiration;
    data['user'] = user.toJson();
    return data;
  }
}