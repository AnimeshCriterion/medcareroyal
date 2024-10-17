import 'dart:convert';

class MedicineIntakeDataModel {
  List<Date>? date;
  List<DrugName>? drugName;
  List<MedicationNameAndDate>? medicationNameAndDate;
  List<DosageForm>? dosageForm;

  MedicineIntakeDataModel(
      {this.date, this.drugName, this.medicationNameAndDate, this.dosageForm});

  MedicineIntakeDataModel.fromJson(Map<String, dynamic> json) {
    if (json['date'] != null) {
      date = <Date>[];
      json['date'].forEach((v) {
        date!.add(new Date.fromJson(v));
      });
    }
    if (json['drugName'] != null) {
      drugName = <DrugName>[];
      json['drugName'].forEach((v) {
        drugName!.add(new DrugName.fromJson(v));
      });
    }
    if (json['medicationNameAndDate'] != null) {
      medicationNameAndDate = <MedicationNameAndDate>[];
      json['medicationNameAndDate'].forEach((v) {
        medicationNameAndDate!.add(new MedicationNameAndDate.fromJson(v));
      });
    }
    if (json['dosageForm'] != null) {
      dosageForm = <DosageForm>[];
      json['dosageForm'].forEach((v) {
        dosageForm!.add(new DosageForm.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.date != null) {
      data['date'] = this.date!.map((v) => v.toJson()).toList();
    }
    if (this.drugName != null) {
      data['drugName'] = this.drugName!.map((v) => v.toJson()).toList();
    }
    if (this.medicationNameAndDate != null) {
      data['medicationNameAndDate'] =
          this.medicationNameAndDate!.map((v) => v.toJson()).toList();
    }
    if (this.dosageForm != null) {
      data['dosageForm'] = this.dosageForm!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Date {
  String? date;

  Date({this.date});

  Date.fromJson(Map<String, dynamic> json) {
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    return data;
  }
}

class DrugName {
  String? drugName;
  String? dosageForm;

  DrugName({this.drugName, this.dosageForm});

  DrugName.fromJson(Map<String, dynamic> json) {
    drugName = json['drugName'];
    dosageForm = json['dosageForm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['drugName'] = this.drugName;
    data['dosageForm'] = this.dosageForm;
    return data;
  }
}

class MedicationNameAndDate {
  int? prescriptionRowID;
  int? pmId;
  String? date;
  String? drugName;
  String? dosageForm;
  String? remark;
  String? frequency;
  String? doseFrequency;
  List<JsonTime>? jsonTime=[];

  MedicationNameAndDate(
      {this.prescriptionRowID,
        this.pmId,
        this.date,
        this.drugName,
        this.dosageForm,
        this.frequency,
        this.doseFrequency,
        this.jsonTime});

  MedicationNameAndDate.fromJson(Map<String, dynamic> json) {
    prescriptionRowID = json['prescriptionRowID'];
    pmId = json['pmId'];
    date = json['date'];
    drugName = json['drugName'];
    dosageForm = json['dosageForm'];
    remark = json['remark'];
    frequency = json['frequency'];
    doseFrequency = json['doseFrequency']??'';
    if (json['jsonTime'] != null && json['jsonTime'].toString().isNotEmpty) {
      jsonTime = <JsonTime>[];
      jsonDecode(json['jsonTime']).forEach((v) {
        jsonTime!.add(JsonTime.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prescriptionRowID'] = this.prescriptionRowID;
    data['pmId'] = this.pmId;
    data['date'] = this.date;
    data['drugName'] = this.drugName;
    data['remark'] = this.remark;
    data['dosageForm'] = this.dosageForm;
    data['frequency'] = this.frequency;
    data['doseFrequency'] = this.doseFrequency;
    if (this.jsonTime != null) {
      data['jsonTime'] = this.jsonTime!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JsonTime {
  String? time;
  String? durationType;
  String? icon;

  JsonTime({this.time, this.durationType, this.icon});

  JsonTime.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    durationType = json['durationType'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['durationType'] = this.durationType;
    data['icon'] = this.icon;
    return data;
  }
}

class DosageForm {
  String? dosageForm;

  DosageForm({this.dosageForm});

  DosageForm.fromJson(Map<String, dynamic> json) {
    dosageForm = json['dosageForm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dosageForm'] = this.dosageForm;
    return data;
  }
}

