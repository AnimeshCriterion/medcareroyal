class BlogDetailsModal {
  int? id;
  String? topic;
  String? title;
  String? writer;
  String? description;
  int? totalLikes;
  String? imagePath;
  String? publishDate;

  BlogDetailsModal(
      {this.id,
        this.topic,
        this.title,
        this.writer,
        this.description,
        this.totalLikes,
        this.imagePath,
        this.publishDate});

  BlogDetailsModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topic = json['topic'];
    title = json['title'];
    writer = json['writer'];
    description = json['description'];
    totalLikes = json['totalLikes'];
    imagePath = json['imagePath'];
    publishDate = json['publishDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['topic'] = this.topic;
    data['title'] = this.title;
    data['writer'] = this.writer;
    data['description'] = this.description;
    data['totalLikes'] = this.totalLikes;
    data['imagePath'] = this.imagePath;
    data['publishDate'] = this.publishDate;
    return data;
  }
}
