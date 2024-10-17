class HomeIsolationRequestDataModal {
  int? id;
  String? hospitalName;
  String? packageName;
  int? packagePrice;
  String? comoribid;
  String? stymptoms;
  String? testDate;
  String? testTypes;
  String? allergires;
  String? o2;
  String? onSetDate;
  String? homeIsolationStatus;
  String? userMobileNo;
  String? name;
  String? vitalDetails;
  String? requestedDate;

  HomeIsolationRequestDataModal(
      {this.id,
        this.hospitalName,
        this.packageName,
        this.packagePrice,
        this.comoribid,
        this.stymptoms,
        this.testDate,
        this.testTypes,
        this.allergires,
        this.o2,
        this.onSetDate,
        this.homeIsolationStatus,
        this.userMobileNo,
        this.name,
        this.vitalDetails,
        this.requestedDate});

  HomeIsolationRequestDataModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hospitalName = json['hospitalName'];
    packageName = json['packageName'];
    packagePrice = json['packagePrice'];
    comoribid = json['comoribid'];
    stymptoms = json['stymptoms'];
    testDate = json['testDate'];
    testTypes = json['testTypes'];
    allergires = json['allergires'];
    o2 = json['o2'];
    onSetDate = json['onSetDate'];
    homeIsolationStatus = json['homeIsolationStatus'];
    userMobileNo = json['userMobileNo'];
    name = json['name'];
    vitalDetails = json['vitalDetails'];
    requestedDate = json['requestedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hospitalName'] = this.hospitalName;
    data['packageName'] = this.packageName;
    data['packagePrice'] = this.packagePrice;
    data['comoribid'] = this.comoribid;
    data['stymptoms'] = this.stymptoms;
    data['testDate'] = this.testDate;
    data['testTypes'] = this.testTypes;
    data['allergires'] = this.allergires;
    data['o2'] = this.o2;
    data['onSetDate'] = this.onSetDate;
    data['homeIsolationStatus'] = this.homeIsolationStatus;
    data['userMobileNo'] = this.userMobileNo;
    data['name'] = this.name;
    data['vitalDetails'] = this.vitalDetails;
    data['requestedDate'] = this.requestedDate;
    return data;
  }
}
