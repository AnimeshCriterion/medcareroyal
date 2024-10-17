class RadiologyDetailsDataModal {
  String? pacsURL;

  RadiologyDetailsDataModal({this.pacsURL});

  RadiologyDetailsDataModal.fromJson(Map<String, dynamic> json) {
    pacsURL = json['pacsURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pacsURL'] = this.pacsURL;
    return data;
  }
}
