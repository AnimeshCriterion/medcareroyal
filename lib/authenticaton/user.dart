class User {
  int? pmid;
  String? patientName;
  String? uhID;
  int? pid;
  String? mobileNo;
  String? gender;
  int? age;
  String? agetype;
  String? ipNo;
  String? crNo;
  int? deptId;
  String? address;
  String? dob;
  String? registrationDate;
  int? status;
  String? patientType;
  String? wardName;
  int? wardId;
  String? height;
  String? weight;
  String? admitDate;
  String? dischargeDate;
  String? modality;
  int? admitDoctorId;
  int? userId;
  int? countryId;
  int? stateId;
  int? cityId;
  String? guardianAddress;
  String? guardianName;
  int? guardianRelationId;
  String? guardianMobileNo;
  String? idNumber;
  int? idTypeId;
  int? maritalStatusId;
  String? emailID;
  int? raceTypeId;
  int? ethinicityId;
  int? languageId;
  int? bloodGroupId;
  String? zip;
  String? sexualOrientation;
  int? ageUnitId;
  int? clientId;
  int? isNotificationRequired;
  String? genderId;
  String? alternateMobileNo;
  String? alternateCountryCode;
  String? addressLine2;
  String? token;

  User(
      {this.pmid,
        this.patientName,
        this.uhID,
        this.pid,
        this.mobileNo,
        this.gender,
        this.age,
        this.agetype,
        this.ipNo,
        this.crNo,
        this.deptId,
        this.address,
        this.dob,
        this.registrationDate,
        this.status,
        this.patientType,
        this.wardName,
        this.wardId,
        this.height,
        this.weight,
        this.admitDate,
        this.dischargeDate,
        this.modality,
        this.admitDoctorId,
        this.userId,
        this.countryId,
        this.stateId,
        this.cityId,
        this.guardianAddress,
        this.guardianName,
        this.guardianRelationId,
        this.guardianMobileNo,
        this.idNumber,
        this.idTypeId,
        this.maritalStatusId,
        this.emailID,
        this.raceTypeId,
        this.ethinicityId,
        this.languageId,
        this.bloodGroupId,
        this.zip,
        this.sexualOrientation,
        this.ageUnitId,
        this.genderId,
        this.clientId,
        this.isNotificationRequired,
        this.alternateMobileNo,
        this.alternateCountryCode,
        this.addressLine2,
        this.token,

      });

  User.fromJson(Map<String, dynamic> json) {
    pmid = json['pmid'];
    patientName = json['patientName'];
    uhID = json['uhId'];
    pid = json['pid'];
    mobileNo = json['mobileNo'];
    gender = json['gender'];
    age = json['age'];
    agetype = json['agetype'];
    ipNo = json['ipNo'];
    crNo = json['crNo'];
    deptId = json['deptId'];
    address = json['address'];
    dob = json['dob'];
    registrationDate = json['registrationDate'];
    status = json['status'];
    patientType = json['patientType'];
    wardName = json['wardName'];
    wardId = json['wardId'];
    height = json['height'].toString();
    weight = json['weight'].toString();
    admitDate = json['admitDate'];
    dischargeDate = json['dischargeDate'];
    modality = json['modality'];
    admitDoctorId = json['admitDoctorId'];
    userId = json['userId'];
    countryId = json['countryId'];
    isNotificationRequired = json['isNotificationRequired'];
    stateId = json['stateId'];
    cityId = json['cityId'];
    guardianAddress = json['guardianAddress'];
    guardianName = json['guardianName'];
    guardianRelationId = json['guardianRelationId'];
    guardianMobileNo = json['guardianMobileNo'];
    idNumber = json['idNumber'];
    idTypeId = json['idTypeId'];
    maritalStatusId = json['maritalStatusId'];
    emailID = json['emailID'];
    raceTypeId = json['raceTypeId'];
    ethinicityId = json['ethinicityId'];
    languageId = json['languageId'];
    bloodGroupId = json['bloodGroupId'];
    zip = json['zip'];
    sexualOrientation = json['sexualOrientation'];
    ageUnitId = json['ageUnitId'];
    genderId = json['genderId'];
    clientId = json['clientId'];
    alternateMobileNo = json['alternateMobileNo'];
    alternateCountryCode = json['alternateCountryCode'];
    token = json['token'];
    addressLine2 = json['addressLine2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pmid'] = pmid;
    data['patientName'] = patientName;
    data['uhId'] = uhID;
    data['pid'] = pid;
    data['mobileNo'] = mobileNo;
    data['gender'] = gender;
    data['age'] = age;
    data['agetype'] = agetype;
    data['ipNo'] = ipNo;
    data['crNo'] = crNo;
    data['deptId'] = deptId;
    data['address'] = address;
    data['dob'] = dob;
    data['registrationDate'] = registrationDate;
    data['status'] = status;
    data['patientType'] = patientType;
    data['wardName'] = wardName;
    data['wardId'] = wardId;
    data['height'] = height;
    data['weight'] = weight;
    data['admitDate'] = admitDate;
    data['dischargeDate'] = dischargeDate;
    data['modality'] = modality;
    data['admitDoctorId'] = admitDoctorId;
    data['userId'] = userId;
    data['countryId'] = countryId;
    data['stateId'] = stateId;
    data['cityId'] = cityId;
    data['guardianAddress'] = guardianAddress;
    data['guardianName'] = guardianName;
    data['guardianRelationId'] = guardianRelationId;
    data['guardianMobileNo'] = guardianMobileNo;
    data['idNumber'] = idNumber;
    data['idTypeId'] = idTypeId;
    data['maritalStatusId'] = maritalStatusId;
    data['emailID'] = emailID;
    data['raceTypeId'] = raceTypeId;
    data['ethinicityId'] = ethinicityId;
    data['languageId'] = languageId;
    data['bloodGroupId'] = bloodGroupId;
    data['zip'] = zip;
    data['sexualOrientation'] = sexualOrientation;
    data['ageUnitId'] = ageUnitId;
    data['genderId'] = genderId;
    data['clientId'] = clientId;
    data['alternateMobileNo'] = alternateMobileNo;
    data['alternateCountryCode'] = alternateCountryCode;
    data['addressLine2'] = addressLine2;
    data['token'] = token;
    return data;
  }
}