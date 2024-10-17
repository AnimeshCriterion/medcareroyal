class ChatDataModal {
  int? id;
  int? groupId;
  int? sendFrom;
  int? sendTo;
  String? message;
  String? fileUrl="";
  String? fileName;
  String? fileLength;
  int? isOnline;
  String? messageDay;
  String? chatTime;
  String? chatDate;
  String? messageDateTime;
  String? sendFromName;

  ChatDataModal(
      {this.id,
        this.groupId,
        this.sendFrom,
        this.sendTo,
        this.message,
        this.fileUrl,
        this.isOnline,
        this.fileName,
        this.fileLength,
        this.messageDay,
        this.chatTime,
        this.chatDate,
        this.messageDateTime,
      this.sendFromName});

  ChatDataModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupId = json['groupId'];
    sendFrom = json['sendFrom'];
    sendTo = json['sendTo'];
    message = json['message'];
    fileUrl = json['fileUrl'];
    fileName = json['fileName'];
    isOnline = json['isOnline'];
    fileLength = json['fileLength'];
    messageDay = json['messageDay'];
    chatTime = json['chatTime'];
    chatDate = json['chatDate'];
    messageDateTime = json['messageDateTime'];
    sendFromName=json['sendFromName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['groupId'] = this.groupId;
    data['sendFrom'] = this.sendFrom;
    data['sendTo'] = this.sendTo;
    data['message'] = this.message;
    data['fileUrl'] = this.fileUrl;
    data['fileName'] = this.fileName;
    data['isOnline'] = this.isOnline;
    data['fileLength'] = this.fileLength;
    data['messageDay'] = this.messageDay;
    data['chatTime'] = this.chatTime;
    data['chatDate'] = this.chatDate;
    data['messageDateTime'] = this.messageDateTime;
    data['sendFromName']=this.sendFromName;
    return data;
  }
}
