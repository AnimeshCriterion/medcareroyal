class BlogDetailsModal {
  String? path;
  String? description;

  BlogDetailsModal(
      {this.path,
        this.description, });

  BlogDetailsModal.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['description'] = this.description;
    return data;
  }
}
