class SlotBookedDetailsModal {
  int? slotId;
  String? slotType;
  String? slotTime;
  String? appointDate;
  String? bookedTime;

  SlotBookedDetailsModal(
      {this.slotId,
        this.slotType,
        this.slotTime,
        this.appointDate,
        this.bookedTime});

  SlotBookedDetailsModal.fromJson(Map<String, dynamic> json) {
    slotId = json['slotId']??0;
    slotType = json['slotType']??'';
    slotTime = json['slotTime']??'';
    appointDate = json['appointDate']??'';
    bookedTime = json['bookedTime']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slotId'] = this.slotId;
    data['slotType'] = this.slotType;
    data['slotTime'] = this.slotTime;
    data['appointDate'] = this.appointDate;
    data['bookedTime'] = this.bookedTime;
    return data;
  }
}
