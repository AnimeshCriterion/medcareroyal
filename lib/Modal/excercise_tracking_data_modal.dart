

  class ExerciseTrackingDataModal {
  int? id;
  String? activityName;
  String? iconImage;
  String? userID;

  ExerciseTrackingDataModal({this.id, this.activityName, this.iconImage, this.userID});

  ExerciseTrackingDataModal.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  activityName = json['activityName'];
  iconImage = json['iconImage'];
  userID = json['userID'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['activityName'] = this.activityName;
  data['iconImage'] = this.iconImage;
  data['userID'] = this.userID;
  return data;
  }
  }



  class ExerciseVideoDataModel {
    int? id;
    int? problemId;
    String? problemName;
    int? activityId;
    String? activityName;
    String? exerciseName;
    String? thumbnailURL;
    String? videoURL;
    String? description;
    int? totalStep;
    int? maxTimeInMinute;
    bool? isCommon;
    String? videoName;

    ExerciseVideoDataModel(
        {this.id,
          this.problemId,
          this.problemName,
          this.activityId,
          this.activityName,
          this.exerciseName,
          this.thumbnailURL,
          this.videoURL,
          this.description,
          this.totalStep,
          this.maxTimeInMinute,
          this.isCommon,
          this.videoName});

    ExerciseVideoDataModel.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      problemId = json['problemId'];
      problemName = json['problemName'];
      activityId = json['activityId'];
      activityName = json['activityName'];
      exerciseName = json['exerciseName'];
      thumbnailURL = json['thumbnailURL'];
      videoURL = json['videoURL'];
      description = json['description'];
      totalStep = json['totalStep'];
      maxTimeInMinute = json['maxTimeInMinute'];
      isCommon = json['isCommon'];
      videoName = json['videoName'];
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = this.id;
      data['problemId'] = this.problemId;
      data['problemName'] = this.problemName;
      data['activityId'] = this.activityId;
      data['activityName'] = this.activityName;
      data['exerciseName'] = this.exerciseName;
      data['thumbnailURL'] = this.thumbnailURL;
      data['videoURL'] = this.videoURL;
      data['description'] = this.description;
      data['totalStep'] = this.totalStep;
      data['maxTimeInMinute'] = this.maxTimeInMinute;
      data['isCommon'] = this.isCommon;
      data['videoName'] = this.videoName;
      return data;
    }
  }