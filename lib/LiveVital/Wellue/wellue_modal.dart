class WellueModal {
  String? spo2;
  String? pr;

  WellueModal({this.spo2, this.pr});

  WellueModal.fromJson(Map<String, dynamic> json) {
    spo2 = json['spo2']?? '__';
    pr = json['pr']??'__';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['spo2'] = spo2;
    data['pr'] = pr;
    return data;
  }
}
