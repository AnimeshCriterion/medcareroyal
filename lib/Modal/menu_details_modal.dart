class MenuDetailsModal {
  int? id;
  String? menuName;
  String? icon;

  MenuDetailsModal({this.id, this.menuName, this.icon});

  MenuDetailsModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    menuName = json['menuName'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['menuName'] = this.menuName;
    data['icon'] = this.icon;
    return data;
  }
}
