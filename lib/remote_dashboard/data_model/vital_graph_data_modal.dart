import 'dart:convert';

class VitalDataModel{
  String? vitalDateTime;
  String? vitalDateForGraph;
  List<VitalDetailsDataModel>? vitalDetails;

  VitalDataModel({
    this.vitalDateTime,
    this.vitalDateForGraph,
    this.vitalDetails
  });

  factory VitalDataModel.fromJson(Map<String, dynamic > json) => VitalDataModel(
      vitalDateTime: json['vitalDateTime'].toString(),
      vitalDateForGraph: json['vitalDateForGraph'].toString(),
      vitalDetails: List<VitalDetailsDataModel>.from(
          jsonDecode(json['vitalDetails']??"[]").map((element) => VitalDetailsDataModel.fromJson(element))
      )
  );

}

class VitalDetailsDataModel{

  String? vitalName;
  String? vitalValue;
  String? vitalDateForGraph;

  VitalDetailsDataModel({
    this.vitalName,
    this.vitalValue,
    this.vitalDateForGraph
  });

  factory VitalDetailsDataModel.fromJson(Map<String, dynamic> json) => VitalDetailsDataModel(
    vitalName: json['vitalName'].toString(),
    vitalValue: (json['vitalValue']??'0.0').toString(),
    vitalDateForGraph: json['vitalDateForGraph'].toString(),
  );

}

//Data model for systolic and diastolic

class VitalChartData{
  String? vitalDate;
  String? vitalDateForGraph;
  String? vitalName;
  String? vitalValue;

  VitalChartData({
    this.vitalDate,
    this.vitalDateForGraph,
    this.vitalName,
    this.vitalValue
  });

  factory VitalChartData.fromJson(Map<String, dynamic> json) => VitalChartData(
    vitalDate: json['vitalDate'].toString(),
    vitalDateForGraph: json['vitalDateForGraph'].toString(),
    vitalName: json['vitalName'].toString(),
    vitalValue: (json['vitalValue'] ??'0.0')==''?
    '0.0':(json['vitalValue'] ??'0.0')
        .toString(),
  );
}