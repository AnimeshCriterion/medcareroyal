

class StethoRecordingDataModal {
  int? patientinformationid;
  String? audiofileurlmannual;
  String? audiofileurlauto;
  String? graphmannual;
  String? graphauto;
  String? timestamp;
  String? downloadPer;

  StethoRecordingDataModal(
      {this.patientinformationid,
        this.audiofileurlmannual,
        this.audiofileurlauto,
        this.graphmannual,
        this.graphauto,
        this.timestamp,
        this.downloadPer,
      });

  StethoRecordingDataModal.fromJson(Map<String, dynamic> json) {
    patientinformationid = json['patientinformationid'];
    audiofileurlmannual = json['audiofileurlmannual'];
    audiofileurlauto = json['audiofileurlauto'];
    graphmannual = json['graphmannual'];
    graphauto = json['graphauto'];
    timestamp = json['timestamp'];
    downloadPer = json['downloadPer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientinformationid'] = this.patientinformationid;
    data['audiofileurlmannual'] = this.audiofileurlmannual;
    data['audiofileurlauto'] = this.audiofileurlauto;
    data['graphmannual'] = this.graphmannual;
    data['graphauto'] = this.graphauto;
    data['timestamp'] = this.timestamp;
    data['downloadPer'] = this.downloadPer;
    return data;
  }
}
