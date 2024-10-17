class TopImageModal {
  String? topImage;

  TopImageModal({this.topImage});

  TopImageModal.fromJson(Map<String, dynamic> json) {
    topImage = json['topImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topImage'] = this.topImage;
    return data;
  }
}
