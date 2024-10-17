

class SymptomsHistoryDataModal{
      int? problemId;
      String? problemName;
      String? attributeName;
      String? attributeValue;
      String? problemDate;
      String? filterDate;
      String? problemTime;
      int? type;
      SymptomsHistoryDataModal({
        this.problemId,
        this.problemName,
        this.attributeName,
        this.attributeValue,
        this.problemDate,
        this.filterDate,
        this.problemTime,
        this.type,
});
      factory SymptomsHistoryDataModal.fromJson(Map<String, dynamic> json) =>
          SymptomsHistoryDataModal(
      problemId: json['problemId'],
      problemName: json['problemName'],
      attributeName: json['attributeName'],
      attributeValue: json['attributeValue'],
      problemDate: json['problemDate'],
      filterDate: json['filterDate'],
      problemTime: json['problemTime'],
      type: json['type'],);

}