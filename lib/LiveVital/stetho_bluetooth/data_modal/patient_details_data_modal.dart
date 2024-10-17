class PatientDetailsDataModal {
  int? id;
  String? patientName;
  String? guardianName;
  String? mobileNo;
  int? stateID;
  String? stateName;
  int? districtID;
  String? districtName;
  String? address;
  int? identityTypeID;
  String? identityName;
  String? guardianMobileNo;
  String? identityNumber;
  bool? isCOVIDVaccinated;
  int? occupationID;
  Null? occupationName;
  int? subDepartmentID;
  int? doctorID;
  int? roomID;
  String? gender;
  int? guardianRelationID;
  int? patientCategoryID;
  int? maritalStatusID;
  String? dob;
  String? patientAge;
  String? emailID;
  int? educationalID;
  String? educationName;
  int? memberID;
  int? userLoginId;
  int? covidStatus;
  String? dietType;
  String? attendantMobileNo;
  int? isAyushmanBeneficiary;
  int? raceID;
  int? ethinicityID;
  int? languageID;

  PatientDetailsDataModal(
      {this.id,
        this.patientName,
        this.guardianName,
        this.mobileNo,
        this.stateID,
        this.stateName,
        this.districtID,
        this.districtName,
        this.address,
        this.identityTypeID,
        this.identityName,
        this.guardianMobileNo,
        this.identityNumber,
        this.isCOVIDVaccinated,
        this.occupationID,
        this.occupationName,
        this.subDepartmentID,
        this.doctorID,
        this.roomID,
        this.gender,
        this.guardianRelationID,
        this.patientCategoryID,
        this.maritalStatusID,
        this.dob,
        this.patientAge,
        this.emailID,
        this.educationalID,
        this.educationName,
        this.memberID,
        this.userLoginId,
        this.covidStatus,
        this.dietType,
        this.attendantMobileNo,
        this.isAyushmanBeneficiary,
        this.raceID,
        this.ethinicityID,
        this.languageID});

  PatientDetailsDataModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientName = json['patientName'];
    guardianName = json['guardianName'];
    mobileNo = json['mobileNo'];
    stateID = json['stateID'];
    stateName = json['stateName'];
    districtID = json['districtID'];
    districtName = json['districtName'];
    address = json['address'];
    identityTypeID = json['identityTypeID'];
    identityName = json['identityName'];
    guardianMobileNo = json['guardianMobileNo'];
    identityNumber = json['identityNumber'];
    isCOVIDVaccinated = json['isCOVIDVaccinated'];
    occupationID = json['occupationID'];
    occupationName = json['occupationName'];
    subDepartmentID = json['subDepartmentID'];
    doctorID = json['doctorID'];
    roomID = json['roomID'];
    gender = json['gender'];
    guardianRelationID = json['guardianRelationID'];
    patientCategoryID = json['patientCategoryID'];
    maritalStatusID = json['maritalStatusID'];
    dob = json['dob'];
    patientAge = json['patientAge'];
    emailID = json['emailID'];
    educationalID = json['educationalID'];
    educationName = json['educationName'];
    memberID = json['memberID'];
    userLoginId = json['userLoginId'];
    covidStatus = json['covidStatus'];
    dietType = json['dietType'];
    attendantMobileNo = json['attendantMobileNo'];
    isAyushmanBeneficiary = json['isAyushmanBeneficiary'];
    raceID = json['raceID'];
    ethinicityID = json['ethinicityID'];
    languageID = json['languageID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patientName'] = this.patientName;
    data['guardianName'] = this.guardianName;
    data['mobileNo'] = this.mobileNo;
    data['stateID'] = this.stateID;
    data['stateName'] = this.stateName;
    data['districtID'] = this.districtID;
    data['districtName'] = this.districtName;
    data['address'] = this.address;
    data['identityTypeID'] = this.identityTypeID;
    data['identityName'] = this.identityName;
    data['guardianMobileNo'] = this.guardianMobileNo;
    data['identityNumber'] = this.identityNumber;
    data['isCOVIDVaccinated'] = this.isCOVIDVaccinated;
    data['occupationID'] = this.occupationID;
    data['occupationName'] = this.occupationName;
    data['subDepartmentID'] = this.subDepartmentID;
    data['doctorID'] = this.doctorID;
    data['roomID'] = this.roomID;
    data['gender'] = this.gender;
    data['guardianRelationID'] = this.guardianRelationID;
    data['patientCategoryID'] = this.patientCategoryID;
    data['maritalStatusID'] = this.maritalStatusID;
    data['dob'] = this.dob;
    data['patientAge'] = this.patientAge;
    data['emailID'] = this.emailID;
    data['educationalID'] = this.educationalID;
    data['educationName'] = this.educationName;
    data['memberID'] = this.memberID;
    data['userLoginId'] = this.userLoginId;
    data['covidStatus'] = this.covidStatus;
    data['dietType'] = this.dietType;
    data['attendantMobileNo'] = this.attendantMobileNo;
    data['isAyushmanBeneficiary'] = this.isAyushmanBeneficiary;
    data['raceID'] = this.raceID;
    data['ethinicityID'] = this.ethinicityID;
    data['languageID'] = this.languageID;
    return data;
  }
}
