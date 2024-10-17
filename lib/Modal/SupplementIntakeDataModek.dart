class SupplementIntakeDataModel {
  int? medicationId;
  int? brandId;
  double? doseStrength;
  int? doseUnitId;
  String? foodName;
  String? unitName;
  String? medicationEntryDate;
  String? medicationEntryTime;
  String? supplimentName;
  String? timeSlot;
  int? entryUserId;
  int? isGiven;
  String? foodGivenAt;

  SupplementIntakeDataModel(
      {this.medicationId,
        this.brandId,
        this.doseStrength,
        this.doseUnitId,
        this.foodName,
        this.unitName,
        this.medicationEntryDate,
        this.medicationEntryTime,
        this.entryUserId,
        this.timeSlot,
        this.supplimentName,
        this.isGiven,
        this.foodGivenAt});

  SupplementIntakeDataModel.fromJson(Map<String, dynamic> json) {
    medicationId = json['medicationId'];
    brandId = json['brandId'];
    doseStrength = json['doseStrength'];
    doseUnitId = json['doseUnitId'];
    foodName = json['foodName'];
    unitName = json['unitName'];
    supplimentName = json['supplimentName'];
    medicationEntryDate = json['medicationEntryDate'];
    medicationEntryTime = json['medicationEntryTime'];
    timeSlot = json['timeSlot'];
    entryUserId = json['entryUserId'];
    isGiven = json['isGiven'];
    foodGivenAt = json['foodGivenAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicationId'] = this.medicationId;
    data['brandId'] = this.brandId;
    data['doseStrength'] = this.doseStrength;
    data['doseUnitId'] = this.doseUnitId;
    data['supplimentName'] =  this.supplimentName;
    data['foodName'] = this.foodName;
    data['unitName'] = this.unitName;
    data['medicationEntryDate'] = this.medicationEntryDate;
    data['medicationEntryTime'] = this.medicationEntryTime;
    data['timeSlot'] = this.timeSlot;
    data['entryUserId'] = this.entryUserId;
    data['isGiven'] = this.isGiven;
    data['foodGivenAt'] = this.foodGivenAt;
    return data;
  }
}