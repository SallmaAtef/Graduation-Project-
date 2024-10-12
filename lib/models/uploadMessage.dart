import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class UploadMessage {

  UploadMessage(
      this.from,
      this.type,
      this.message,
      this.seen,
      this.time,
      );

  String from,
      type,
      message,
      seen;
  int time;

  UploadMessage.fromJson(Map<dynamic,dynamic> json)
    :from = json['from'] as String,
        type= json['type'] as String,
        message = json['message'] as String,
        seen = json['seen'] as String,
        time = json['time'] as int;

  Map<dynamic, dynamic> toJson() =>
      <dynamic, dynamic>{
        'from': from,
        'type': type,
        'message': message,
        'seen': seen,
        'time': time,
      };
}