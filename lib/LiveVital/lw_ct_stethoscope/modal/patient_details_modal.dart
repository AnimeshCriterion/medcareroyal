class PatientDetailsModal {
  String? listenUrl;
  String? socketUrl;
  String? port;
  String? name;
  String? age;
  String? gender;
  int? sthethoid;

  PatientDetailsModal(
      {this.listenUrl,
        this.socketUrl,
        this.port,
        this.name,
        this.age,
        this.gender,
        this.sthethoid});

  PatientDetailsModal.fromJson(Map json) {
    listenUrl = json['listenUrl'];
    socketUrl = json['socketUrl'];
    port = json['port'];
    name = json['name'];
    age = json['age'];
    gender = json['gender'];
    sthethoid = json['sthethoid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['listenUrl'] = listenUrl;
    data['socketUrl'] = socketUrl;
    data['port'] = port;
    data['name'] = name;
    data['age'] = age;
    data['gender'] = gender;
    data['sthethoid'] = sthethoid;
    return data;
  }
}