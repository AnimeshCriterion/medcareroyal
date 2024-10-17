class TopClinicsModal {
  int? id;
  String? name;
  String? address;
  String? stateName;
  String? cityName;
  String? profilePhotoPath;
  String? serviceProviderType;

  TopClinicsModal(
      {this.id,
        this.name,
        this.address,
        this.stateName,
        this.cityName,
        this.profilePhotoPath,
        this.serviceProviderType});

  TopClinicsModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    stateName = json['stateName'];
    cityName = json['cityName'];
    profilePhotoPath = json['profilePhotoPath'];
    serviceProviderType = json['serviceProviderType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['stateName'] = this.stateName;
    data['cityName'] = this.cityName;
    data['profilePhotoPath'] = this.profilePhotoPath;
    data['serviceProviderType'] = this.serviceProviderType;
    return data;
  }
}
