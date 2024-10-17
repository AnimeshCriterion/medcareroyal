class ManualFoodAssignDataModal {
  int? foodID;
  String? foodName;
  String? quantity;
  int? foodId;

  ManualFoodAssignDataModal({this.foodID, this.foodName, this.quantity, this.foodId});

  ManualFoodAssignDataModal.fromJson(Map<String, dynamic> json) {
    foodID = json['foodID'];
    foodName = json['foodName'];
    quantity = json['quantity'];
    foodId = json['foodId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['foodID'] = this.foodID;
    data['foodName'] = this.foodName;
    data['quantity'] = this.quantity;
    data['foodId'] = this.foodId;
    return data;
  }
}
