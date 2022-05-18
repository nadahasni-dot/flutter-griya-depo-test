import 'dart:convert';

AchievementModel achievementModelFromJson(String str) =>
    AchievementModel.fromJson(json.decode(str));

String achievementModelToJson(AchievementModel data) =>
    json.encode(data.toJson());

class AchievementModel {
  AchievementModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  bool success;
  int code;
  String message;
  List<Achievement> data;

  factory AchievementModel.fromJson(Map<String, dynamic> json) =>
      AchievementModel(
        success: json["success"],
        code: json["code"],
        message: json["message"],
        data: List<Achievement>.from(
            json["data"].map((x) => Achievement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Achievement {
  Achievement({
    required this.id,
    required this.userId,
    required this.achievementName,
    required this.level,
    required this.organizer,
    required this.year,
    required this.file,
  });

  int id;
  String userId;
  String achievementName;
  String level;
  String organizer;
  String year;
  String file;

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
        id: json["id"],
        userId: json["user_id"],
        achievementName: json["achievement_name"],
        level: json["level"],
        organizer: json["organizer"],
        year: json["year"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "achievement_name": achievementName,
        "level": level,
        "organizer": organizer,
        "year": year,
        "file": file,
      };
}
