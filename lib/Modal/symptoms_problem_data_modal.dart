class SymptomsProblemModal {
  int? problemId;
  String? problemName;
  int? isVisible;
  String? displayIcon;
  bool? isSelected;

  SymptomsProblemModal(
      {this.problemId, this.problemName, this.isVisible, this.displayIcon, this.isSelected});

  SymptomsProblemModal.fromJson(Map<String, dynamic> json) {
    problemId = json['problemId'];
    problemName = json['problemName']??'';
    isVisible = json['isVisible'];
    displayIcon = json['displayIcon']??'';
    isSelected = json['isSelected']?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['problemId'] = this.problemId;
    data['problemName'] = this.problemName;
    data['isVisible'] = this.isVisible;
    data['displayIcon'] = this.displayIcon;
    data['isSelected'] = this.isSelected;
    return data;
  }
}
