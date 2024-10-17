

class AttributeDataModal{
  var problemId;
  String? attributeId;
  String? attributeName;
  List<AttributeDetailsDataModal>? attributeDetails;
  AttributeDataModal({
    this.problemId,
    this.attributeName,
    this.attributeDetails,
    this.attributeId,
  });

  factory AttributeDataModal.fromJson(Map<String, dynamic> json) =>AttributeDataModal(
    problemId: json['problemId']?? 0,
    attributeId: json['attributeId'],
    attributeName: json['attributeName']??json['problemName'],
    attributeDetails: List<AttributeDetailsDataModal>.from(
        (json['attributeDetails']??[]).map((element) => AttributeDetailsDataModal.fromJson(element))
    ),
  );
}


class AttributeDetailsDataModal{
  String? problemId;
  String? attributeId;
  String? attributeValueId;
  String? attributeValue;
  bool? isSelected;
  AttributeDetailsDataModal({
    this.problemId,
    this.attributeId,
    this.attributeValueId,
    this.attributeValue,
    this.isSelected,
  });

  factory AttributeDetailsDataModal.fromJson(Map<String, dynamic> json) =>AttributeDetailsDataModal(
    problemId :json['problemId'],
    attributeId :json['attributeId'],
    attributeValueId :json['attributeValueId'],
    attributeValue :json['attributeValue'],
    isSelected :json['isSelected'],
  );
}