import 'dart:convert';

class MyAppointmentDataModal{

  int? appointmentId;
  int? isEraUser;
  String? appointmentDate;
  String? appointmentTime;
  double? doctorFees;
  int? doctorId;
  String? doctorName;
  String? degree;
  String? drMobileNo;
  String? specialty;
  String? clinicName;
  String? address;
  String? problemName;
  String? patientName;
  String? appointmentIdView;
  String? doctorAddress;
  String? location;
  String? appointTime;
  String? appointDate;
  int? expiredStatus;
  int? isReview;
  bool? isPrescribed;
  bool isCancelled;
  List<AttachFileDataModal>? attachFile;
  List<AttachFileDataModal>? workingHours;

  MyAppointmentDataModal({
    this.appointmentId,
    this.isEraUser,
    this.appointmentDate,
    this.appointmentTime,
    this.doctorId,
    this.doctorFees,
    this.doctorName,
    this.degree,
    this.drMobileNo,
    this.specialty,
    this.clinicName,
    this.address,
    this.problemName,
    this.patientName,
    this.appointmentIdView,
    this.doctorAddress,
    this.location,
    this.appointTime,
    this.appointDate,
    this.expiredStatus,
    this.isPrescribed,
    this.isCancelled=false,
    this.isReview,
    this.attachFile,
    this.workingHours,
  });

  factory MyAppointmentDataModal.fromJson(Map json) => MyAppointmentDataModal(
    appointmentId : json['appointmentId']??0,
    isEraUser : json['isEraUser'],
    appointmentDate : json['appointmentDate'],
    appointmentTime : json['appointmentTime'],
    doctorId : json['doctorId'],
    doctorFees : double.parse((json['doctorFees']?? 0.0).toString()),
    doctorName : json['doctorName'],
    degree : json['degree'],
    drMobileNo : json['drMobileNo'],
    specialty : json['specialty'],
    clinicName : json['clinicName']?? '',
    address : json['address'],
    problemName : json['problemName'],
    patientName : json['patientName'],
    appointmentIdView : json['appointmentIdView'],
    doctorAddress : json['doctorAddress']??'',
    location : json['location'],
    appointTime : json['appointTime'],
    appointDate : json['appointDate'],
    expiredStatus : json['expiredStatus'],
    isPrescribed : json['isPrescribed'],
    isCancelled : json['isCancelled']??false,
    isReview : json['isReview'],
    attachFile: List<AttachFileDataModal>.from(jsonDecode(json['attachFile']==''? '[]':json['attachFile']?? '[]')
        .map((element) => AttachFileDataModal.fromJson(element))),
    workingHours: List<AttachFileDataModal>.from(jsonDecode(json['workingHours']==''? '[]':json['workingHours']?? '[]')
        .map((element) => AttachFileDataModal.fromJson(element))),


  );

}


class AttachFileDataModal{
  String? filePath;
  String? fileType;

  AttachFileDataModal({
    this.filePath,
    this.fileType,
  });

  factory AttachFileDataModal.fromJson(Map<String, dynamic> json) =>
      AttachFileDataModal(
        filePath:json['filePath'],
        fileType:json['fileType'],

      );
}