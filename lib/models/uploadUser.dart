import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class UploadUser {

  UploadUser(
      this.name,
      this.image,
      this.number,
      this.address,
      this.type,
      );

  String
      name,
      image,
      number,
      address,
  type;

  UploadUser.fromJson(Map<dynamic,dynamic> json)
    :
    name = json['name'] as String,
    image= json['image'] as String,
    number = json['number'] as String,
    address = json['address']as String,
  type = json['type']as String;

  Map<dynamic, dynamic> toJson() =>
      <dynamic, dynamic>{

        'name': name,
        'image': image,
        'number': number,
        'address': address,
        'type': type,
      };
}