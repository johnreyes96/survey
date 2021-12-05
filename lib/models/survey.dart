class Survey {
  int id = 0;
  String date = '';
  String email = '';
  int qualification = 1;
  String theBest = '';
  String theWorst = '';
  String remarks = '';

  Survey({
    required this.id,
    required this.date,
    required this.email,
    required this.qualification,
    required this.theBest,
    required this.theWorst,
    required this.remarks
  });

  Survey.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    email = json['email'] ?? '';
    qualification = json['qualification'];
    theBest = json['theBest'] ?? '';
    theWorst = json['theWorst'] ?? '';
    remarks = json['remarks'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['email'] = email;
    data['qualification'] = qualification;
    data['theBest'] = theBest;
    data['theWorst'] = theWorst;
    data['remarks'] = remarks;
    return data;
  }
}