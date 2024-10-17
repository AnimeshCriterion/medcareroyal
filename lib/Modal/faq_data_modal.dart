class FAQDataModal {
  int? id;
  int? categoryID;
  String? categoryName;
  String? uhid;
  int? pmID;
  String? questionnaireSetID;
  String? setName;
  String? questionnaireDateTime;
 List<Answer>? answers;

  FAQDataModal(
      {this.id,
        this.categoryID,
        this.categoryName,
        this.uhid,
        this.pmID,
        this.questionnaireSetID,
        this.setName,
        this.questionnaireDateTime,
        this.answers});

  FAQDataModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryID = json['categoryID'];
    categoryName = json['categoryName'];
    uhid = json['uhid'];
    pmID = json['pmID'];
    questionnaireSetID = json['questionnaireSetID'];
    setName = json['setName'];
    questionnaireDateTime = json['questionnaireDateTime'];
    answers = json['answers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryID'] = this.categoryID;
    data['categoryName'] = this.categoryName;
    data['uhid'] = this.uhid;
    data['pmID'] = this.pmID;
    data['questionnaireSetID'] = this.questionnaireSetID;
    data['setName'] = this.setName;
    data['questionnaireDateTime'] = this.questionnaireDateTime;
    data['answers'] = this.answers;
    return data;
  }
}
class Answer {
  int? answerMainID;
  String? questionID;
  String? questionName;
  int? optionID;
  String? optionText;

  Answer(
      {this.answerMainID,
        this.questionID,
        this.questionName,
        this.optionID,
        this.optionText});

  Answer.fromJson(Map<String, dynamic> json) {
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

