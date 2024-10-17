class EffectedMedicineDataModal {
  String? problemName;
  String? effectedMedicine;

  EffectedMedicineDataModal({this.problemName, this.effectedMedicine});

  EffectedMedicineDataModal.fromJson(Map<String, dynamic> json) {
    problemName = json['problemName'];
    effectedMedicine = json['effectedMedicine'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['problemName'] = this.problemName;
    data['effectedMedicine'] = this.effectedMedicine;
    return data;
  }
}
