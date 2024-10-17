class CountDetailModal {
  String? description;
  int? doctorsCount;
  int? hospitalCount;
  int? userCount;

  CountDetailModal(
      {this.description,
        this.doctorsCount,
        this.hospitalCount,
        this.userCount});

  CountDetailModal.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    doctorsCount = json['doctorsCount'];
    hospitalCount = json['hospitalCount'];
    userCount = json['userCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['doctorsCount'] = this.doctorsCount;
    data['hospitalCount'] = this.hospitalCount;
    data['userCount'] = this.userCount;
    return data;
  }
}


