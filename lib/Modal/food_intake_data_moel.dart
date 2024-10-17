class FoodIntakeDataModel {
  int? dietId;
  int? foodId;
  double? foodQty;
  int? foodUnitID;
  String? foodName;
  String? unitName;
  String? foodEntryDate;
  String? foodEntryTime;
  String? timeSlot;
  int? entryUserId;
  int? isGiven;
  String? foodGivenAt;

  FoodIntakeDataModel(
      {this.dietId,
        this.foodId,
        this.foodQty,
        this.foodUnitID,
        this.foodName,
        this.unitName,
        this.foodEntryDate,
        this.foodEntryTime,
        this.timeSlot,
        this.entryUserId,
        this.isGiven,
        this.foodGivenAt});

  FoodIntakeDataModel.fromJson(Map<String, dynamic> json) {
    dietId = json['dietId'];
    foodId = json['foodId'];
    foodQty = json['foodQty'];
    foodUnitID = json['foodUnitID'];
    foodName = json['foodName'];
    unitName = json['unitName'];
    foodEntryDate = json['foodEntryDate'];
    foodEntryTime = json['foodEntryTime'];
    timeSlot = json['timeSlot'];
    entryUserId = json['entryUserId'];
    isGiven = json['isGiven'];
    foodGivenAt = json['foodGivenAt'];
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
    data['timeSlot'] = this.timeSlot;
    data['entryUserId'] = this.entryUserId;
    data['isGiven'] = this.isGiven;
    data['foodGivenAt'] = this.foodGivenAt;
    return data;
  }
}