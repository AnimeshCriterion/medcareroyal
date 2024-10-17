class SymptomsNotificationDataModel {
  int? problemId;
  String? problemName;

  SymptomsNotificationDataModel({this.problemId, this.problemName});

  SymptomsNotificationDataModel.fromJson(Map<String, dynamic> json) {
    problemId = json['problemId'];
    problemName = json['problemName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['problemId'] = this.problemId;
    data['problemName'] = this.problemName;
    return data;
  }
}