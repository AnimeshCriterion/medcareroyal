import 'dart:convert';

class RemoteDashboardMonitoringDataModal {
  int? patientId;
  double? sortOrderIndex;
  PatientDataList? patientDataList;
  bool? isOnLifeSupport;
  bool? isOnOxygenSupport;
  bool? isOnInfusionFluidPump;
  bool? isOnDVTPumpSupport;
  bool? isOnFeed;
  bool? isECGDone;

  RemoteDashboardMonitoringDataModal(
      {this.patientId,
        this.sortOrderIndex,
        this.patientDataList,
        this.isOnLifeSupport,
        this.isOnOxygenSupport,
        this.isOnInfusionFluidPump,
        this.isOnDVTPumpSupport,
        this.isOnFeed,
        this.isECGDone});

  RemoteDashboardMonitoringDataModal.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'];
    sortOrderIndex = double.parse(json['sortOrderIndex'].toString());
    patientDataList = jsonDecode(json['patientDataList']) != null
        ? new PatientDataList.fromJson(jsonDecode(json['patientDataList']))
        : null;
    isOnLifeSupport = json['isOnLifeSupport'];
    isOnOxygenSupport = json['isOnOxygenSupport'];
    isOnInfusionFluidPump = json['isOnInfusionFluidPump'];
    isOnDVTPumpSupport = json['isOnDVTPumpSupport'];
    isOnFeed = json['isOnFeed'];
    isECGDone = json['isECGDone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientId'] = this.patientId;
    data['sortOrderIndex'] = this.sortOrderIndex;
    if (this.patientDataList != null) {
      data['patientDataList'] = this.patientDataList!.toJson();
    }
    data['isOnLifeSupport'] = this.isOnLifeSupport;
    data['isOnOxygenSupport'] = this.isOnOxygenSupport;
    data['isOnInfusionFluidPump'] = this.isOnInfusionFluidPump;
    data['isOnDVTPumpSupport'] = this.isOnDVTPumpSupport;
    data['isOnFeed'] = this.isOnFeed;
    data['isECGDone'] = this.isECGDone;
    return data;
  }
}

class PatientDataList {
  int? pId;
  String? uhId;
  String? pntName;
  String? pntAge;
  String? pntGender;
  int? pntPID;
  String? ptDep;
  String? ptBed;
  String? ptAdmitDays;
  String? diagnosis;
  String? ward;
  String? consultant;
  String? bpR;
  String? spo2r;
  String? pulseR;
  String? tempR;
  String? temp;
  String? creatinine;
  String? burea;
  String? iO;
  String? sgot;
  String? sgpt;
  int? userId;
  int? clientId;
  List? admitTimeVitalsList;
  List<VitalParametersList>? vitalParametersList;
  List? investigationParameterList;
  List? lifeSupportList;
  List<DiagonsisList>? diagonsisList;
  String? pacsList;
  List? oxygenSupporList;
  List? infusionPumpDataList;
  List? dVTPumpList;
  List? eCGList;
  List? feedParameterList;
  List? feedbackParameterList;
  List? pacsParameterList;
  List? getFoodList;
  List? prescreptionParameterList;
  List<PrescreptionParameterListMedvantage>?
  prescreptionParameterListMedvantage;
  List? patientFluidBottleList;
  List? PatientHomeCareSymtomsList;
  List? PatientInputOutputList;

  PatientDataList(
      {this.pId,
        this.uhId,
        this.pntName,
        this.pntAge,
        this.pntGender,
        this.pntPID,
        this.ptDep,
        this.ptBed,
        this.ptAdmitDays,
        this.diagnosis,
        this.ward,
        this.consultant,
        this.bpR,
        this.spo2r,
        this.pulseR,
        this.tempR,
        this.temp,
        this.creatinine,
        this.burea,
        this.iO,
        this.sgot,
        this.sgpt,
        this.userId,
        this.clientId,
        this.admitTimeVitalsList,
        this.vitalParametersList,
        this.investigationParameterList,
        this.lifeSupportList,
        this.diagonsisList,
        this.pacsList,
        this.oxygenSupporList,
        this.infusionPumpDataList,
        this.dVTPumpList,
        this.eCGList,
        this.feedParameterList,
        this.feedbackParameterList,
        this.pacsParameterList,
        this.getFoodList,
        this.prescreptionParameterList,
        this.prescreptionParameterListMedvantage,
        this.patientFluidBottleList,
      this.PatientHomeCareSymtomsList,
      this.PatientInputOutputList});

  PatientDataList.fromJson(Map<String, dynamic> json) {
    pId = json['PId'];
    uhId = json['UhId'];
    pntName = json['PntName'];
    pntAge = json['PntAge'];
    pntGender = json['PntGender'];
    pntPID = json['PntPID'];
    ptDep = json['PtDep'];
    ptBed = json['PtBed'];
    ptAdmitDays = json['PtAdmitDays'];
    diagnosis = json['Diagnosis'];
    ward = json['Ward'];
    consultant = json['Consultant'];
    bpR = json['BpR'];
    spo2r = json['Spo2r'];
    pulseR = json['PulseR'];
    tempR = json['TempR'];
    temp = json['Temp'];
    creatinine = json['Creatinine'];
    burea = json['Burea'];
    iO = json['IO'];
    sgot = json['Sgot'];
    sgpt = json['Sgpt'];
    userId = json['UserId'];
    clientId = json['ClientId'];
    admitTimeVitalsList = json['AdmitTimeVitalsList'];
    if (json['VitalParametersList'] != null) {
      vitalParametersList = <VitalParametersList>[];
      json['VitalParametersList'].forEach((v) {
        vitalParametersList!.add(new VitalParametersList.fromJson(v));
      });
    }
    investigationParameterList = json['InvestigationParameterList'];
    lifeSupportList = json['LifeSupportList'];
    if (json['DiagonsisList'] != null) {
      diagonsisList = <DiagonsisList>[];
      json['DiagonsisList'].forEach((v) {
        diagonsisList!.add(new DiagonsisList.fromJson(v));
      });
    }
    pacsList = json['PacsList'];
    oxygenSupporList = json['OxygenSupporList'];
    infusionPumpDataList = json['InfusionPumpDataList'];
    dVTPumpList = json['DVTPumpList'];
    eCGList = json['ECGList'];
    feedParameterList = json['FeedParameterList'];
    feedbackParameterList = json['FeedbackParameterList'];
    pacsParameterList = json['PacsParameterList'];
    getFoodList = json['GetFoodList'];
    prescreptionParameterList = json['PrescreptionParameterList'];
    if (json['PrescreptionParameterListMedvantage'] != null) {
      prescreptionParameterListMedvantage =
      <PrescreptionParameterListMedvantage>[];
      json['PrescreptionParameterListMedvantage'].forEach((v) {
        prescreptionParameterListMedvantage!
            .add(new PrescreptionParameterListMedvantage.fromJson(v));
      });
    }
    patientFluidBottleList = json['PatientFluidBottleList'];
    PatientHomeCareSymtomsList=json['PatientHomeCareSymtomsList'];

    PatientInputOutputList = json['PatientInputOutputList']??[];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PId'] = this.pId;
    data['UhId'] = this.uhId;
    data['PntName'] = this.pntName;
    data['PntAge'] = this.pntAge;
    data['PntGender'] = this.pntGender;
    data['PntPID'] = this.pntPID;
    data['PtDep'] = this.ptDep;
    data['PtBed'] = this.ptBed;
    data['PtAdmitDays'] = this.ptAdmitDays;
    data['Diagnosis'] = this.diagnosis;
    data['Ward'] = this.ward;
    data['Consultant'] = this.consultant;
    data['BpR'] = this.bpR;
    data['Spo2r'] = this.spo2r;
    data['PulseR'] = this.pulseR;
    data['TempR'] = this.tempR;
    data['Temp'] = this.temp;
    data['Creatinine'] = this.creatinine;
    data['Burea'] = this.burea;
    data['IO'] = this.iO;
    data['Sgot'] = this.sgot;
    data['Sgpt'] = this.sgpt;
    data['UserId'] = this.userId;
    data['ClientId'] = this.clientId;
    data['AdmitTimeVitalsList'] = this.admitTimeVitalsList;
    if (this.vitalParametersList != null) {
      data['VitalParametersList'] =
          this.vitalParametersList!.map((v) => v.toJson()).toList();
    }
    data['InvestigationParameterList'] = this.investigationParameterList;
    data['LifeSupportList'] = this.lifeSupportList;
    if (this.diagonsisList != null) {
      data['DiagonsisList'] =
          this.diagonsisList!.map((v) => v.toJson()).toList();
    }
    data['PacsList'] = this.pacsList;
    data['OxygenSupporList'] = this.oxygenSupporList;
    data['InfusionPumpDataList'] = this.infusionPumpDataList;
    data['DVTPumpList'] = this.dVTPumpList;
    data['ECGList'] = this.eCGList;
    data['FeedParameterList'] = this.feedParameterList;
    data['FeedbackParameterList'] = this.feedbackParameterList;
    data['PacsParameterList'] = this.pacsParameterList;
    data['GetFoodList'] = this.getFoodList;
    data['PrescreptionParameterList'] = this.prescreptionParameterList;
    if (this.prescreptionParameterListMedvantage != null) {
      data['PrescreptionParameterListMedvantage'] = this
          .prescreptionParameterListMedvantage!
          .map((v) => v.toJson())
          .toList();
    }
    data['PatientFluidBottleList'] = this.patientFluidBottleList;
    data['PatientHomeCareSymtomsList']=this.PatientHomeCareSymtomsList;

    data['PatientInputOutputList'] = this.PatientInputOutputList;




    return data;
  }
}



class VitalParametersList {
  int? pId;
  int? vitalID;
  String? vitalName;
  double? vitalValue;
  String? vitalColor;
  String? vitalDateTime;
  double? vitalScore;
  int? userId;
  bool? isFirstVital;

  VitalParametersList(
      {this.pId,
        this.vitalID,
        this.vitalName,
        this.vitalValue,
        this.vitalColor,
        this.vitalDateTime,
        this.vitalScore,
        this.userId,
        this.isFirstVital});

  VitalParametersList.fromJson(Map<String, dynamic> json) {
    pId = json['PId'];
    vitalID = json['VitalID'];
    vitalName = json['VitalName'];
    vitalValue = double.parse((json['VitalValue']??0.0).toString());
    vitalColor = (json['VitalColor']??'#F5F5F5')==""? "#F5F5F5":json['VitalColor'] ;
    vitalDateTime = json['VitalDateTime']??'';
    vitalScore = double.parse(json['VitalScore'].toString());
    userId = json['UserId'];
    isFirstVital = json['IsFirstVital'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PId'] = this.pId;
    data['VitalID'] = this.vitalID;
    data['VitalName'] = this.vitalName;
    data['VitalValue'] = this.vitalValue;
    data['VitalColor'] = this.vitalColor;
    data['VitalDateTime'] = this.vitalDateTime;
    data['VitalScore'] = this.vitalScore;
    data['UserId'] = this.userId;
    data['IsFirstVital'] = this.isFirstVital;
    return data;
  }
}

class DiagonsisList {
  int? pId;
  int? problemId;
  String? problemName;
  int? userId;

  DiagonsisList({this.pId, this.problemId, this.problemName, this.userId});

  DiagonsisList.fromJson(Map<String, dynamic> json) {
    pId = json['PId'];
    problemId = json['ProblemId'];
    problemName = json['ProblemName'];
    userId = json['UserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PId'] = this.pId;
    data['ProblemId'] = this.problemId;
    data['ProblemName'] = this.problemName;
    data['UserId'] = this.userId;
    return data;
  }
}

class PrescreptionParameterListMedvantage {
  int? pId;
  int? brandId;
  String? drugName;
  String? prescreptionDateTime;
  int? userId;

  PrescreptionParameterListMedvantage(
      {this.pId,
        this.brandId,
        this.drugName,
        this.prescreptionDateTime,
        this.userId});

  PrescreptionParameterListMedvantage.fromJson(Map<String, dynamic> json) {
    pId = json['PId'];
    brandId = json['BrandId'];
    drugName = json['DrugName'];
    prescreptionDateTime = json['PrescreptionDateTime'];
    userId = json['UserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PId'] = this.pId;
    data['BrandId'] = this.brandId;
    data['DrugName'] = this.drugName;
    data['PrescreptionDateTime'] = this.prescreptionDateTime;
    data['UserId'] = this.userId;
    return data;
  }
}


