class ExerciseVideos {
  int? id;
  int? problemId;
  String? problemName;
  int? activityId;
  String? activityName;
  String? exerciseName;
  String? thumbnailURL;
  String? videoURL;
  String? description;
  ExerciseVideos(
      {this.id,
        this.problemId,
        this.problemName,
        this.activityId,
        this.activityName,
        this.exerciseName,
        this.thumbnailURL,
        this.videoURL,
        this.description});
  ExerciseVideos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    problemId = json['problemId'];
    problemName = json['problemName'];
    activityId = json['activityId'];
    activityName = json['activityName'];
    exerciseName = json['exerciseName'];
    thumbnailURL = json['thumbnailURL'];
    videoURL = json['videoURL'];
    description = json['description'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['problemId'] = problemId;
    data['problemName'] = problemName;
    data['activityId'] = activityId;
    data['activityName'] = activityName;
    data['exerciseName'] = exerciseName;
    data['thumbnailURL'] = thumbnailURL;
    data['videoURL'] = videoURL;
    data['description'] = description;
    return data;
  }
}