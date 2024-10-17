class BannerDetailsModal {
  String? sliderImages;

  BannerDetailsModal({this.sliderImages});

  BannerDetailsModal.fromJson(Map<String, dynamic> json) {
    sliderImages = json['sliderImages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sliderImages'] = this.sliderImages;
    return data;
  }
}
