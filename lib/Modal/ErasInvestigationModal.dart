class ErasInvestigationModal {
  String? collectionDateFormatted;
  String? createdDate;
  int? subCategoryID;
  String? subCategoryName;
  int? categoryID;
  String? categoryName;
  String? itemNames;
  int? type;
  int? testCount;
  String? billNo;

  ErasInvestigationModal(
      {this.collectionDateFormatted,
        this.createdDate,
        this.subCategoryID,
        this.subCategoryName,
        this.categoryID,
        this.categoryName,
        this.itemNames,
        this.type,
        this.testCount,
        this.billNo});

  ErasInvestigationModal.fromJson(Map<String, dynamic> json) {
    collectionDateFormatted = json['collectionDateFormatted']??'';
    createdDate = json['createdDate']??'';
    subCategoryID = json['subCategoryID'];
    subCategoryName = json['subCategoryName']??"";
    categoryID = json['categoryID'];
    categoryName = json['categoryName']??"";
    itemNames = json['itemNames']??'';
    type = json['type'];
    testCount = json['testCount'];
    billNo = json['billNo']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['collectionDateFormatted'] = this.collectionDateFormatted;
    data['createdDate'] = this.createdDate;
    data['subCategoryID'] = this.subCategoryID;
    data['subCategoryName'] = this.subCategoryName;
    data['categoryID'] = this.categoryID;
    data['categoryName'] = this.categoryName;
    data['itemNames'] = this.itemNames;
    data['type'] = this.type;
    data['testCount'] = this.testCount;
    data['billNo'] = this.billNo;
    return data;
  }
}
