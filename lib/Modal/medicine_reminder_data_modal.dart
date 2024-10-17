class MedicineReminderDataModal {
  int? id;
  int? isReminder;
  int? medicineId;
  String? medicineName;
  String? dosageFormName;
  String? strength;
  String? unitName;
  String? frequencyName;
  int? durationInDays;

  MedicineReminderDataModal(
      {this.id,
        this.isReminder,
        this.medicineId,
        this.medicineName,
        this.dosageFormName,
        this.strength,
        this.unitName,
        this.frequencyName,
        this.durationInDays});

  MedicineReminderDataModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isReminder = json['isReminder'];
    medicineId = json['medicineId'];
    medicineName = json['medicineName'];
    dosageFormName = json['dosageFormName'];
    strength = json['strength'];
    unitName = json['unitName'];
    frequencyName = json['frequencyName'];
    durationInDays = json['durationInDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isReminder'] = this.isReminder;
    data['medicineId'] = this.medicineId;
    data['medicineName'] = this.medicineName;
    data['dosageFormName'] = this.dosageFormName;
    data['strength'] = this.strength;
    data['unitName'] = this.unitName;
    data['frequencyName'] = this.frequencyName;
    data['durationInDays'] = this.durationInDays;
    return data;
  }
}
