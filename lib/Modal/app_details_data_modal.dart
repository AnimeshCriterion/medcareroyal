
class AppDetailsDataModal  {
  String? appBaseUrl;
  String? appName;
  String? appLogo;
  String? appColorPrimary;
  String? appTextColor;
  String? appLanguageCode;
  bool? isAppUnderMaintenance;
  String? emergencyContactNumber;
  String? appColorSecondary;
  String? eraEmergencyContactNumber;

  AppDetailsDataModal(
      {
        this.appBaseUrl,
        this.appName,
        this.appLogo,
        this.appColorPrimary,
        this.appTextColor,
        this.appLanguageCode,
        this.isAppUnderMaintenance,
        this.emergencyContactNumber,
        this.appColorSecondary,
        this.eraEmergencyContactNumber,
      });

  AppDetailsDataModal.fromJson(Map<String, dynamic> json) {
    appBaseUrl = json['appBaseUrl'];
    appName = json['appName'];
    appLogo = json['appLogo'];
    appColorPrimary = json['appColorPrimary']??'#001767';
    appTextColor = json['appTextColor'];
    appLanguageCode = json['appLanguageCode'];
    isAppUnderMaintenance = json['isAppUnderMaintenance'];
    emergencyContactNumber = json['emergencyContactNumber']??'';
    appColorSecondary = json['appColorSecondary']??'#00000';
    eraEmergencyContactNumber=json['eraEmergencyContactNumber']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appBaseUrl'] = this.appBaseUrl;
    data['appName'] = this.appName;
    data['appLogo'] = this.appLogo;
    data['appColorPrimary'] = this.appColorPrimary;
    data['appTextColor'] = this.appTextColor;
    data['appLanguageCode'] = this.appLanguageCode;
    data['isAppUnderMaintenance'] = this.isAppUnderMaintenance;
    data['emergencyContactNumber'] = this.emergencyContactNumber;
    data['appColorSecondary'] = this.appColorSecondary;
    data['eraEmergencyContactNumber']=this.eraEmergencyContactNumber;
    return data;
  }
}