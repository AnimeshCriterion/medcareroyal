class SelectTestCategoryDataModal {
  int? id;
  String? categoryName;
  String? remark;
  int? userId;

  SelectTestCategoryDataModal(
      {this.id, this.categoryName, this.remark, this.userId});

  SelectTestCategoryDataModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    remark = json['remark'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['remark'] = this.remark;
    data['userId'] = this.userId;
    return data;
  }
}
