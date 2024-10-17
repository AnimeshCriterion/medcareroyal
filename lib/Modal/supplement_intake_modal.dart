class SupplementIntakeModal{
  int?id;
  String?foodName;
  List<IntakeDetailModal>?intakeDetails;

  SupplementIntakeModal({
    this.id,
    this.foodName,
    this.intakeDetails,
  });
  factory SupplementIntakeModal.fromJson(Map<String, dynamic> json) =>
      SupplementIntakeModal(
        id: json['id'],
        foodName: json['foodName'],
        intakeDetails: List<IntakeDetailModal>.from(
            (json['intakeDetails']??'[]').map((element) => IntakeDetailModal.fromJson(element))
        ),

      );

}


class IntakeDetailModal{
  String?intakeTime;
  int?quantity;
  String?intakeTimeForApp;
  int?foodId;
  int?isExists;
  int?isDose;
  int?unitId;
  String?foodName;
  String?unitName;


  IntakeDetailModal({
    this.intakeTime,
    this.quantity,
    this.intakeTimeForApp,
    this.foodId,
    this.isDose,
    this.isExists,
    this.unitId,
    this.foodName,
    this.unitName,

  });
  factory IntakeDetailModal.fromJson(Map<String,dynamic>json)=>
      IntakeDetailModal(
        intakeTime: json['intakeTime'],
        quantity: json['quantity'],
        intakeTimeForApp: json['intakeTimeForApp'],
        foodId: json['foodId'],
        isDose: json['isDose'],
        isExists: json['isExists'],
        unitId: json['unitId'],
        foodName: json['foodName'],
        unitName: json['unitName'],
      );

}



class FoodListDataModel {
  int? dietId;
  int? foodId;
  int? foodQty;
  int? foodUnitID;
  String? foodName;
  String? unitName;
  String? foodEntryDate;
  String? foodEntryTime;
  int? entryUserId;

  FoodListDataModel(
      {this.dietId,
        this.foodId,
        this.foodQty,
        this.foodUnitID,
        this.foodName,
        this.unitName,
        this.foodEntryDate,
        this.foodEntryTime,
        this.entryUserId});

  FoodListDataModel.fromJson(Map<String, dynamic> json) {
    dietId = json['dietId'];
    foodId = json['foodId'];
    foodQty = json['foodQty'];
    foodUnitID = json['foodUnitID'];
    foodName = json['foodName'];
    unitName = json['unitName'];
    foodEntryDate = json['foodEntryDate'];
    foodEntryTime = json['foodEntryTime'];
    entryUserId = json['entryUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dietId'] = this.dietId;
    data['foodId'] = this.foodId;
    data['foodQty'] = this.foodQty;
    data['foodUnitID'] = this.foodUnitID;
    data['foodName'] = this.foodName;
    data['unitName'] = this.unitName;
    data['foodEntryDate'] = this.foodEntryDate;
    data['foodEntryTime'] = this.foodEntryTime;
    data['entryUserId'] = this.entryUserId;
    return data;
  }
}