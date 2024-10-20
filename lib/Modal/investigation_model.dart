class Investigation {
  final int id;
  final int itemId;
  final String itemName;
  final bool isDone;
  final String createdDate;

  Investigation({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.isDone,
    required this.createdDate,
  });

  factory Investigation.fromJson(Map<String, dynamic> json) {
    return Investigation(
      id: json['id'],
      itemId: json['itemId'],
      itemName: json['itemName'],
      isDone: json['isDone'],
      createdDate: json['createdDate'],
    );
  }
}
