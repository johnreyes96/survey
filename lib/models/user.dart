class User {
  String firstName = '';
  String lastName = '';
  String photoURL = '';
  int loginType = 1;
  String fullName = '';
  String id = '';
  String email = '';

  User({
    required this.firstName,
    required this.lastName,
    required this.photoURL,
    required this.loginType,
    required this.fullName,
    required this.id,
    required this.email,
  });

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    photoURL = json['photoURL'] ?? '';
    loginType = json['loginType'];
    fullName = json['fullName'];
    id = json['id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['photoURL'] = this.photoURL;
    data['loginType'] = this.loginType;
    data['fullName'] = this.fullName;
    data['id'] = this.id;
    data['email'] = this.email;
    return data;
  }
}