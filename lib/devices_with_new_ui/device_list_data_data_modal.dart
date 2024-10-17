
class DeviceListDataModal {
  int? id;
  String? name;
  String? deviceType;
  String? image;
  String? device;
  String? suuid;
  String? cuuid;
  String? modal;
  DeviceListDataModal(
      {this.id,
        this.name,
        this.deviceType,
        this.image,
        this.device,
        this.suuid,
        this.cuuid,
        this.modal,
      });

  DeviceListDataModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name']??'';
    deviceType = json['deviceType']??'';
    image = json['image']??'';
    device = json['device']??'';
    suuid = json['suuid']??'';
    cuuid = json['cuuid']??'';
    modal = json['modal']??'';
    }


}
