import 'dart:convert';

class AllActivityChronicleDataModal {
  int? categoryID;
  String? categoryName;
  String? uhid;
  int? pmID;
  String? questionnaireSetID;
  String? setName;
  String? questionnaireDateTime;
  List<Answers>? answers;
  List<VitalList>? vitalList;

  AllActivityChronicleDataModal(
      {this.categoryID,
        this.categoryName,
        this.uhid,
        this.pmID,
        this.questionnaireSetID,
        this.setName,
        this.questionnaireDateTime,
        this.answers,
        this.vitalList});

  AllActivityChronicleDataModal.fromJson(Map<String, dynamic> json) {
    categoryID = json['categoryID'];
    categoryName = json['categoryName'];
    uhid = json['uhid'];
    pmID = json['pmID'];
    questionnaireSetID = json['questionnaireSetID'];
    setName = json['setName'];
    questionnaireDateTime = json['questionnaireDateTime'];
    if (json['answers'] != null) {
      answers = <Answers>[];
      (jsonDecode(json['answers']) ).forEach((v) {
        answers!.add(new Answers.fromJson(v));
      });
    }
    if (json['vitalList'] != null) {
      vitalList = <VitalList>[];
      json['vitalList'].forEach((v) {
        vitalList!.add(new VitalList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryID'] = this.categoryID;
    data['categoryName'] = this.categoryName;
    data['uhid'] = this.uhid;
    data['pmID'] = this.pmID;
    data['questionnaireSetID'] = this.questionnaireSetID;
    data['setName'] = this.setName;
    data['questionnaireDateTime'] = this.questionnaireDateTime;
    if (this.answers != null) {
      data['answers'] = this.answers!.map((v) => v.toJson()).toList();
    }
    if (this.vitalList != null) {
      data['vitalList'] = this.vitalList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Answers {
  int? answerMainID;
  String? questionID;
  String? questionName;
  int? optionID;
  String? optionText;

  Answers(
      {this.answerMainID,
        this.questionID,
        this.questionName,
        this.optionID,
        this.optionText});

  Answers.fromJson(Map<String, dynamic> json) {
    answerMainID = json['answerMainID'];
    questionID = json['questionID'];
    questionName = json['questionName'];
    optionID = json['optionID'];
    optionText = json['optionText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answerMainID'] = this.answerMainID;
    data['questionID'] = this.questionID;
    data['questionName'] = this.questionName;
    data['optionID'] = this.optionID;
    data['optionText'] = this.optionText;
    return data;
  }
}

class VitalList {
  String? uhid;
  int? id;
  int? pmId;
  int? vitalID;
  String? vitalName;
  double? vitalValue;
  String? unit;
  String? vitalDateTime;
  int? userId;
  int? rowId;

  VitalList(
      {this.uhid,
        this.id,
        this.pmId,
        this.vitalID,
        this.vitalName,
        this.vitalValue,
        this.unit,
        this.vitalDateTime,
        this.userId,
        this.rowId});

  VitalList.fromJson(Map<String, dynamic> json) {
    uhid = json['uhid'];
    id = json['id'];
    pmId = json['pmId'];
    vitalID = json['vitalID'];
    vitalName = json['vitalName'];
    vitalValue = json['vitalValue'];
    unit = json['unit'];
    vitalDateTime = json['vitalDateTime'];
    userId = json['userId'];
    rowId = json['rowId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uhid'] = this.uhid;
    data['id'] = this.id;
    data['pmId'] = this.pmId;
    data['vitalID'] = this.vitalID;
    data['vitalName'] = this.vitalName;
    data['vitalValue'] = this.vitalValue;
    data['unit'] = this.unit;
    data['vitalDateTime'] = this.vitalDateTime;
    data['userId'] = this.userId;
    data['rowId'] = this.rowId;
    return data;
  }
}
