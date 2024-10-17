class SelectedSymptoms {
  Organ? organ;
  String? attributeID;
  String? id;
  String? symptoms;
  bool? isSelected;

  SelectedSymptoms({this.organ, this.id, this.symptoms, this.isSelected, this.attributeID});

  SelectedSymptoms.fromJson(Map<String, dynamic> json) {
    organ = json['organ'] != null ? new Organ.fromJson(json['organ']) : null;
    id = json['id'];
    symptoms = json['symptoms']??'';
    isSelected = json['isSelected'];
    attributeID = json['attributeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.organ != null) {
      data['organ'] = this.organ!.toJson();
    }
    data['id'] = this.id;
    data['symptoms'] = this.symptoms;
    data['isSelected'] = this.isSelected;
    data['attributeID'] = this.attributeID;
    return data;
  }
}

class Organ {
  bool? isSelected;
  String? img;
  String? title;
  String? id;
  String? language;

  Organ({this.isSelected, this.img, this.title, this.id, this.language});

  Organ.fromJson(Map<String, dynamic> json) {
    isSelected = json['isSelected'];
    img = json['img'];
    title = json['title'];
    id = json['id'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSelected'] = this.isSelected;
    data['img'] = this.img;
    data['title'] = this.title;
    data['id'] = this.id;
    data['language'] = this.language;
    return data;
  }
}
