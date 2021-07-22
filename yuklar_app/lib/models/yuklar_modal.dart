

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true, createToJson: true)
class Yuklar {
  String getLocation;
  String getLocationRegion;
  String sendLocation;
  String sendLocationRegion;
  String cost;
  String phoneNumber;
  String getDate;
  String packing;
  String productText;

  Yuklar(
      {this.cost,
      this.phoneNumber,
      this.packing,
      this.getDate,
      this.getLocation,
      this.sendLocation,
      this.productText});

  Yuklar.fromJson(Map<String, dynamic> json)
      : getLocation = json['mFrom'],
        sendLocation = json['mTo'],   
        cost = json['amount'],
        getDate = json['date'],
        productText = json['text'],
        phoneNumber=json['phone_num']
        ;

  Map<String, dynamic> toJson() => {
        'mFrom': getLocation,
        'mTo': sendLocation,
        'amount': cost,
        'date': getDate,
        'text': productText,
        'phone_num':phoneNumber
      };
}

class User {
  final String name;
  final String email;

  User(this.name, this.email);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
      };
}
