class MemberDataModal{
  int ?id;
  String? name;
  String ?age;
  String ?profilePhotoPath;
  int ?primaryStatus;
  int? pid;
  int? memberId;


  MemberDataModal({
    this.id,
    this.name,
    this.age,
    this.profilePhotoPath,
    this.primaryStatus,
    this.pid,
    this.memberId,
  }) ;
  factory MemberDataModal.fromJson(Map<String, dynamic> json) =>
      MemberDataModal(
        id: json['id'],
        name: json['name'],
        //  name: (json['name']),
        age: json['age'],
        profilePhotoPath: json['profilePhotoPath'],
        primaryStatus:json['primaryStatus'],
        pid:json['pid'],
        memberId: json['memberId'],
      );

}
