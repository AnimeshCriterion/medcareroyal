class PrescriptionHistoryDataModal {
  String? name;
  String? problem_name;
  String?doctor_name;
  String? test_name;
  String? start_date;
  String?speciality;
  String?profile_photo;
  String?appointment_id;
  List<MedicineDetails>?medicine_details;
  String? filePath;
  List<AdviseDetails>? adviseDetails;
  String?appointment_date;
  String?appointment_time;


  PrescriptionHistoryDataModal({
    this.speciality,
    this.doctor_name,
    this.medicine_details,
    this.name,
    this.problem_name,
    this.profile_photo,
    this.start_date,
    this.appointment_id,
    this.test_name,
    this.filePath,
    this.adviseDetails,
    this.appointment_date,
    this.appointment_time
  });
  factory PrescriptionHistoryDataModal.fromJson(Map<String, dynamic> json) =>
      PrescriptionHistoryDataModal(
          name: json['name'],
          problem_name: json['problemName']?? '',
          doctor_name: json['drName']?? '',
          test_name: json['testName'],
          speciality: json['speciality']?? '',
          profile_photo: json['profilePhotoPath'],
          appointment_id: json['appointmentId'],
          start_date: json['startDate']?? '',
          medicine_details: List<MedicineDetails>.from(
              (json['medicineDetails']??'[]').map((element) => MedicineDetails.fromJson(element))
          ),
          adviseDetails: List<AdviseDetails>.from(
              (json['adviseDetails']??'[]').map((element) => AdviseDetails.fromJson(element))
          ),
          appointment_date:json["appointDate"]?? "",
          appointment_time:json["appointTime"],
          filePath:json['filePath']??''
      );
}
class MedicineDetails{
  String? medicine_name;
  String?dosage_form_name;
  String?strength;
  String?unit_name;
  String?frequency_name;
  String?duration;
  MedicineDetails({
    this.dosage_form_name,
    this.duration,
    this.frequency_name,
    this.medicine_name,
    this.strength,
    this.unit_name,
  });
  factory MedicineDetails.fromJson(Map<String, dynamic> json) =>
      MedicineDetails(
          medicine_name: json['medicineName']?? '',
          dosage_form_name: json['dosageFormName']?? '',
          strength: json['strength']?? '',
          duration: json['durationInDays']?? '',
          unit_name: json['unitName']?? '',
          frequency_name: json['frequencyName']?? ''
      );
}

class AdviseDetails{
  String? recommendedDiet;
  String? avoidedDiet;
  String? otherDiet;
  AdviseDetails({
    this.recommendedDiet,
    this.avoidedDiet,
    this.otherDiet,
  });
  factory AdviseDetails.fromJson(Map<String, dynamic> json) =>
      AdviseDetails(
        recommendedDiet: json['recommendedDiet']?? '',
        avoidedDiet: json['avoidedDiet']?? '',
        otherDiet: json['otherDiet']?? '',
      );
}

