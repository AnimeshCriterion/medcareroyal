import 'dart:convert';


class DoctorDetailsModal{
  String? id;
  String? drName;
  String? name;
  String? speciality;
  String? hospitalName;
  String? degree;
  int? isEraUser;
  String? address;
  double? drFee;
  String? profilePhotoPath;
  int? noofPatients;
  int? isFavourite;
  int? review;
  int? rating;
  // String? timeSlots;
  List<WorkingHoursDataModal>? timeSlots;
  List<WorkingHoursDataModal>? workingHours;
  String? yearOfExperience;
  List? sittingDays;

  DoctorDetailsModal(
      {this.id,
        this.drName,
        this.name,
        this.speciality,
        this.hospitalName,
        this.degree,
        this.isEraUser,
        this.address,
        this.drFee,
        this.profilePhotoPath,
        this.noofPatients,
        this.isFavourite,
        this.review,
        this.rating,
        // this.timeSlots,
        this.timeSlots,
        this.yearOfExperience,
        this.workingHours,
        this.sittingDays,
      });

  factory DoctorDetailsModal.fromJson(Map<String, dynamic> json) =>
      DoctorDetailsModal(
        id: json['id'].toString(),
        drName: json['drName'].toString(),
        name: json['name'].toString(),
        speciality: json['speciality'],
        hospitalName: json['hospitalName']??'',
        degree: json['degree']??"",
        isEraUser: json['isEraUser'],
        address: json['address'],
        drFee: double.parse((json['drFee']??'0.0').toString()),
        profilePhotoPath: json['profilePhotoPath'],
        noofPatients: json['noofPatients'],
        isFavourite: json['isFavourite'],
        review: json['review']??0,
        rating: json['rating'],
        yearOfExperience: json['yearOfExperience'],
        sittingDays: json['sittingDays']??[],
        // timeSlots: json['timeSlots'],

        timeSlots: List<WorkingHoursDataModal>.from(
            jsonDecode(json['timeSlots']?? '[]')
                .map((element) => WorkingHoursDataModal.fromJson(element))),
        workingHours: List<WorkingHoursDataModal>.from(
            jsonDecode(json['workingHours']?? '[]')
                .map((element) => WorkingHoursDataModal.fromJson(element))),
      );
}

class DoctorProfileModel {
  String? dayName;
  List<TimeDetailsModel>? timeDetails;
  DoctorProfileModel({
    this.dayName,
    this.timeDetails,
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) =>
      DoctorProfileModel(
        dayName: json['dayName'],
        timeDetails: List<TimeDetailsModel>.from((json['timeDetails'] ?? '[]')
            .map((element) => TimeDetailsModel.fromJson(element))),
      );
}

class WorkingHoursDataModal {
  String? dayName;
  String? timeFrom;
  String? timeTo;

  WorkingHoursDataModal({
    this.dayName,
    this.timeFrom,
    this.timeTo,
  });

  factory WorkingHoursDataModal.fromJson(Map<String, dynamic> json) =>
      WorkingHoursDataModal(
        dayName: json['dayName'],
        timeFrom: json['timeFrom'],
        timeTo: json['timeTo'],

      );
}

class TimeDetailsModel {
  String? timeFrom;
  String? timeTo;

  TimeDetailsModel({
    this.timeFrom,
    this.timeTo,
  });

  factory TimeDetailsModel.fromJson(Map<String, dynamic> json) =>
      TimeDetailsModel(
        timeFrom: json['timeFrom'],
        timeTo: json['timeTo'],
      );
}
