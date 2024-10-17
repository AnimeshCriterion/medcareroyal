class MicrobiologyDetailsDataModal {
  int? itemID;
  String? itemName;
  int? categoryID;
  int? isCultureSterile;
  String? collectionDate;
  String? subTest;

  MicrobiologyDetailsDataModal(
      {this.itemID,
        this.itemName,
        this.categoryID,
        this.isCultureSterile,
        this.collectionDate,
        this.subTest});

  MicrobiologyDetailsDataModal.fromJson(Map<String, dynamic> json) {
    itemID = json['itemID'];
    itemName = json['itemName'];
    categoryID = json['categoryID'];
    isCultureSterile = json['isCultureSterile'];
    collectionDate = json['collectionDate'];
    subTest = json['subTest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemID'] = this.itemID;
    data['itemName'] = this.itemName;
    data['categoryID'] = this.categoryID;
    data['isCultureSterile'] = this.isCultureSterile;
    data['collectionDate'] = this.collectionDate;
    data['subTest'] = this.subTest;
    return data;
  }
}
