class MicrobiologyDataModel {
  String? collectionDateFormatted;
  String? createdDate;
  int? subCategoryID;
  String? subCategoryName;
  int? categoryID;
  String? categoryName;
  int? type;
  int? itemID;
  String? itemName;
  int? testCount;
  String? labReportNo;

  MicrobiologyDataModel(
      {this.collectionDateFormatted,
        this.createdDate,
        this.subCategoryID,
        this.subCategoryName,
        this.categoryID,
        this.categoryName,
        this.type,
        this.itemID,
        this.itemName,
        this.testCount,
        this.labReportNo});

  MicrobiologyDataModel.fromJson(Map<String, dynamic> json) {
    collectionDateFormatted = json['collectionDateFormatted'];
    createdDate = json['createdDate'];
    subCategoryID = json['subCategoryID'];
    subCategoryName = json['subCategoryName'];
    categoryID = json['categoryID'];
    categoryName = json['categoryName'];
    type = json['type'];
    itemID = json['itemID'];
    itemName = json['itemName'];
    testCount = json['testCount'];
    labReportNo = json['labReportNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['collectionDateFormatted'] = this.collectionDateFormatted;
    data['createdDate'] = this.createdDate;
    data['subCategoryID'] = this.subCategoryID;
    data['subCategoryName'] = this.subCategoryName;
    data['categoryID'] = this.categoryID;
    data['categoryName'] = this.categoryName;
    data['type'] = this.type;
    data['itemID'] = this.itemID;
    data['itemName'] = this.itemName;
    data['testCount'] = this.testCount;
    data['labReportNo'] = this.labReportNo;
    return data;
  }
}
