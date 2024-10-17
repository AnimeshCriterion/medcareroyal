class AllDepartmentDataModal {
  int? id;
  String? departmentName;
  String? specialityName;
  String? imagePath;
  String? description;
  int? noOfDoctors;

  AllDepartmentDataModal(
      {this.id,
        this.departmentName,
        this.specialityName,
        this.imagePath,
        this.description,
        this.noOfDoctors});

  AllDepartmentDataModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departmentName = json['departmentName'];
    specialityName = json['specialityName'];
    imagePath = json['imagePath'];
    description = json['description'];
    noOfDoctors = json['noOfDoctors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['departmentName'] = this.departmentName;
    data['specialityName'] = this.specialityName;
    data['imagePath'] = this.imagePath;
    data['description'] = this.description;
    data['noOfDoctors'] = this.noOfDoctors;
    return data;
  }
}
