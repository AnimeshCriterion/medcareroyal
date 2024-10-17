class HealthProductDetailsModal {
  int? id;
  String? categoryName;
  String? imagePath;

  HealthProductDetailsModal({this.id, this.categoryName, this.imagePath});

  HealthProductDetailsModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['imagePath'] = this.imagePath;
    return data;
  }
}
