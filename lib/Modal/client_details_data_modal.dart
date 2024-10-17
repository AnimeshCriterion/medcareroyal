class ClientDetailsDataModal {
  int? id;
  int? packageId;
  String? packageNumber;
  String? address;
  String? emailID;
  int? cityID;
  int? countryID;
  int? stateID;
  String? clientName;
  String? contactPersonMobileNo;
  String? mobileNo;
  String? contactPersonName;
  String? countryCode;
  int? languagePreferredId;
  String? defaultImage;
  String? description;

  ClientDetailsDataModal(
      {this.id,
        this.packageId,
        this.packageNumber,
        this.address,
        this.emailID,
        this.cityID,
        this.countryID,
        this.stateID,
        this.clientName,
        this.contactPersonMobileNo,
        this.mobileNo,
        this.contactPersonName,
        this.countryCode,
        this.languagePreferredId,
        this.defaultImage,
        this.description});

  ClientDetailsDataModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageId = json['packageId'];
    packageNumber = json['packageNumber'];
    address = json['address'];
    emailID = json['emailID']??'';
    cityID = json['cityID'];
    countryID = json['countryID'];
    stateID = json['stateID'];
    clientName = json['clientName']??'';
    contactPersonMobileNo = json['contactPersonMobileNo'];
    mobileNo = json['mobileNo'];
    contactPersonName = json['contactPersonName'];
    countryCode = json['countryCode'];
    languagePreferredId = json['languagePreferredId'];
    defaultImage = json['defaultImage'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['packageId'] = this.packageId;
    data['packageNumber'] = this.packageNumber;
    data['address'] = this.address;
    data['emailID'] = this.emailID;
    data['cityID'] = this.cityID;
    data['countryID'] = this.countryID;
    data['stateID'] = this.stateID;
    data['clientName'] = this.clientName;
    data['contactPersonMobileNo'] = this.contactPersonMobileNo;
    data['mobileNo'] = this.mobileNo;
    data['contactPersonName'] = this.contactPersonName;
    data['countryCode'] = this.countryCode;
    data['languagePreferredId'] = this.languagePreferredId;
    data['defaultImage'] = this.defaultImage;
    data['description'] = this.description;
    return data;
  }
}
