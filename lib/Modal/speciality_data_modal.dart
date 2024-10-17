class specialityDataModal {
  int? id;
  String? specialityName;

  specialityDataModal({this.id, this.specialityName});

  specialityDataModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specialityName = json['specialityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['specialityName'] = this.specialityName;
    return data;
  }
}
