import 'dart:convert';

class InvestigationHistoryDataModal {
  String? type;
  String? receiptNo;
  String? pathologyName;
  String? testDate;
  List<FilePath>? filePathList;
  List<InvestigationDetails>? investigation;

  InvestigationHistoryDataModal(
      {this.type, this.receiptNo, this.pathologyName, this.testDate, this.filePathList, this.investigation});

  factory InvestigationHistoryDataModal.fromJson(Map<String, dynamic>json) =>
      InvestigationHistoryDataModal(
          type: (json['type'] ?? '').toString(),
          receiptNo: (json['receiptNo'] ?? '').toString(),
          pathologyName: (json['pathologyName'] ?? '').toString(),
          testDate: (json['testDate'] ?? '').toString(),
          filePathList: List<FilePath>.from(
              jsonDecode(json['filePath'] == '' ? '[]' : json['filePath']).map((
                  element) => FilePath.fromJson(element))
          ),
          investigation: List<InvestigationDetails>.from(
              (json['investigation'] ?? '[]').map((element) =>
                  InvestigationDetails.fromJson(element)))
      );

}

class FilePath {
  String? filePath;
  String? fileType;

  FilePath({this.filePath, this.fileType});

  factory FilePath.fromJson(Map<String, dynamic> json) =>
      FilePath(
        filePath: (json['filePath'] ?? '').toString(),
        fileType: (json['fileType'] ?? '').toString(),
      );

}

class InvestigationDetails {
  String? testName;
  List<TestDetails>? testDetails;

  InvestigationDetails({this.testName, this.testDetails});

  factory InvestigationDetails.fromJson(Map<String, dynamic> json) =>
      InvestigationDetails(
          testName: (json['testName']??'').toString(),
          testDetails:List<TestDetails>.from((json['testDetails'] ?? []).map((
              element) => TestDetails.fromJson(element))

          )

      );
}

class TestDetails {
  String? subTestId;
  String? subTestName;
  String? testValue;
  String? range;
  String? unitName;
  String? testRemarks;

  TestDetails(
      {this.subTestId, this.subTestName, this.testValue, this.range, this.unitName, this.testRemarks});

  factory TestDetails.fromJson(Map<String, dynamic>json) =>
      TestDetails(
        subTestId: (json['subTestId'] ?? '').toString(),
        subTestName: (json['subTestName'] ?? '').toString(),
        testValue: (json['testValue'] ?? '').toString(),
        range: (json['range'] ?? '').toString(),
        unitName: (json['unitName'] ?? '').toString(),
        testRemarks: (json['testRemarks'] ?? '').toString(),
      );

}
