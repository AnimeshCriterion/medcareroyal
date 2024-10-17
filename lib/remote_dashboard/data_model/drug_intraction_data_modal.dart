import 'dart:convert';

class DrugIntractionDataModal {
  int? medicineId;
  int? interactedId;
  String? interaction;
  String? interactionNature;
  String? interactionEffect;
  String? isLifeThreatning;
  String? suggestiveAction;
  String? substitute;
  String? reference;

  List<SubstituteListDataModal>? substituteList;
  int? adrTypeId;
  String? adrType;

  DrugIntractionDataModal(
      {this.medicineId,
        this.interactedId,
        this.interaction,
        this.interactionNature,
        this.interactionEffect,
        this.isLifeThreatning,
        this.suggestiveAction,
        this.substitute,
        this.reference,
        this.substituteList,

        this.adrTypeId,
        this.adrType});

  DrugIntractionDataModal.fromJson(Map<String, dynamic> json) {
    medicineId = json['medicineId'];
    interactedId = json['interactedId'];
    interaction = json['interaction'];
    interactionNature = json['interactionNature'];
    interactionEffect = json['interactionEffect'];
    isLifeThreatning = json['isLifeThreatning'];
    suggestiveAction = json['suggestiveAction'];
    substitute = json['substitute'];
    reference = json['reference'];
    if (json['substituteList'] != null) {
      substituteList = <SubstituteListDataModal>[];
      jsonDecode((json['substituteList']??"[]")).forEach((v) {
        substituteList!.add(new SubstituteListDataModal.fromJson(v));
      });
    }
    adrTypeId = json['adrTypeId'];
    adrType = json['adrType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicineId'] = this.medicineId;
    data['interactedId'] = this.interactedId;
    data['interaction'] = this.interaction;
    data['interactionNature'] = this.interactionNature;
    data['interactionEffect'] = this.interactionEffect;
    data['isLifeThreatning'] = this.isLifeThreatning;
    data['suggestiveAction'] = this.suggestiveAction;
    data['substitute'] = this.substitute;
    data['reference'] = this.reference;

    if (this.substituteList != null) {
      data['substituteList'] =
          this.substituteList!.map((v) => v.toJson()).toList();
    }
    data['adrTypeId'] = this.adrTypeId;
    data['adrType'] = this.adrType;
    return data;
  }
}
class SubstituteListDataModal {
  String? medicineName;
  String? substitude;
  List<SubstitudeWithID>? substitudeWithID;

  SubstituteListDataModal(
      {this.medicineName, this.substitude, this.substitudeWithID});

  SubstituteListDataModal.fromJson(Map<String, dynamic> json) {
    medicineName = json['medicineName'];
    substitude = json['substitude'];
    if (json['substitudeWithID'] != null) {
      substitudeWithID = <SubstitudeWithID>[];
      json['substitudeWithID'].forEach((v) {
        substitudeWithID!.add(new SubstitudeWithID.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicineName'] = this.medicineName;
    data['substitude'] = this.substitude;
    if (this.substitudeWithID != null) {
      data['substitudeWithID'] =
          this.substitudeWithID!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubstitudeWithID {
  int? id;
  String? medicineName;

  SubstitudeWithID({this.id, this.medicineName});

  SubstitudeWithID.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    medicineName = json['medicineName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['medicineName'] = this.medicineName;
    return data;
  }
}
