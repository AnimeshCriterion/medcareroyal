


class OrganSymptomDataModal {
  int? id;
  String? symptoms;
  bool? isSelected;

  OrganSymptomDataModal({this.id, this.symptoms, this.isSelected=false});

  OrganSymptomDataModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    symptoms = json['symptoms'];
    isSelected = json['isSelected']??false ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['symptoms'] = this.symptoms;
    data['isSelected'] = this.isSelected;
    return data;
  }
}
