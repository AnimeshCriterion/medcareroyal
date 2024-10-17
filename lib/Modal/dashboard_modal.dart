class TopImageModal {
  String? topImage;

  TopImageModal({this.topImage});

  TopImageModal.fromJson(Map<String, dynamic> json) {
    topImage = json['topImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['topImage'] = topImage;
    return data;
  }
}

