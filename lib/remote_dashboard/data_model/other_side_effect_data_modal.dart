class OtherSideEffectDataModal {
  String? medicineName;
  String? reference;
  String? otherSideEffect;
  String? commonSideEffect;
  String? rareSideEffect;
  String? seriousSideEffect;
  String? indication;
  String? molecule;

  OtherSideEffectDataModal(
      {this.medicineName,
        this.reference,
        this.otherSideEffect,
        this.commonSideEffect,
        this.rareSideEffect,
        this.seriousSideEffect,
        this.indication,
        this.molecule});

  OtherSideEffectDataModal.fromJson(Map<String, dynamic> json) {
    medicineName = json['medicineName'];
    reference = json['reference'];
    otherSideEffect = json['otherSideEffect'];
    commonSideEffect = json['commonSideEffect'];
    rareSideEffect = json['rareSideEffect'];
    seriousSideEffect = json['seriousSideEffect'];
    indication = json['indication'];
    molecule = json['molecule'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicineName'] = this.medicineName;
    data['reference'] = this.reference;
    data['otherSideEffect'] = this.otherSideEffect;
    data['commonSideEffect'] = this.commonSideEffect;
    data['rareSideEffect'] = this.rareSideEffect;
    data['seriousSideEffect'] = this.seriousSideEffect;
    data['indication'] = this.indication;
    data['molecule'] = this.molecule;
    return data;
  }
}
