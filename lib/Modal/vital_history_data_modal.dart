

class VitalHistoryDataModal {
  String? vitalDate;
  String? vitalDateForGraph;
  List<VitalDetailsModal>? vitalDetails;
  String? vitalName;
  String? iconPath;

  // List? vitalDetails;
  bool? isSelected;

  VitalHistoryDataModal({
    this.vitalDate,
    this.vitalDateForGraph,
    this.vitalDetails,
    this.vitalName,
    this.iconPath,
    this.isSelected,
    // this.vitalDetails,
  });

  factory VitalHistoryDataModal.fromJson(Map<String, dynamic> json) =>
      VitalHistoryDataModal(
        vitalDate: json['vitalDate'],
        vitalDateForGraph: json['vitalDateForGraph'],
        vitalDetails: List<VitalDetailsModal>.from(
            (json['vitalDetails'] ?? '[]')
                .map((element) => VitalDetailsModal.fromJson(element))),
        vitalName: json['vitalName'],
        iconPath: json['iconPath'],
        isSelected: json['isSelected'],
        // vitalDetails: json['vitalDetails']
      );
}

class VitalDetailsModal {
  String? vitalName;
  String? vitalValue;
  String? vitalDateForGraph;
  String? vitalDate;
  String? vitalTime;

  VitalDetailsModal({
    this.vitalDate,
    this.vitalDateForGraph,
    this.vitalName,
    this.vitalValue,
    this.vitalTime,
  });

  factory VitalDetailsModal.fromJson(Map<String, dynamic> json) =>
      VitalDetailsModal(
          vitalDate: json['vitalDate'],
          vitalDateForGraph: json['vitalDateForGraph'],
          vitalName: json['vitalName'],
          vitalValue: json['vitalValue'] ?? '',
          vitalTime: json['vitalTime'] ?? ''
      );
}
