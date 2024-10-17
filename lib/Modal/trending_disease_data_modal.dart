

class TrendingDiseaseDataModal {
  int? problemId;
  String? problemName;
  String? diseaseDefinition;

  TrendingDiseaseDataModal({this.problemId, this.problemName,this.diseaseDefinition});

  TrendingDiseaseDataModal.fromJson(Map<String, dynamic> json) {
    problemId = json['problemId'] ?? 0;
    problemName = json['problemName'];
    diseaseDefinition = json['diseaseDefinition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['problemId'] = this.problemId;
    data['problemName'] = this.problemName;
    data['diseaseDefinition'] = this.diseaseDefinition;
    return data;
  }
}
