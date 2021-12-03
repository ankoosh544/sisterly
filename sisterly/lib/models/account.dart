import 'package:flutter/cupertino.dart';

class Account {
  
  final int? id;
  final String email;
  final String? description;
  final String? firstName;
  final String? lastName;
  final String? image;
  final bool? emailConfirmed;
  final double? reviewsMedia;
  final bool? holidayMode;

  Account(this.id, this.email, this.description, this.firstName, this.lastName, this.image, this.emailConfirmed, this.reviewsMedia, this.holidayMode);

  factory Account.fromJson(Map<String, dynamic> json) {
    debugPrint("Account.fromJson " + json.toString());
    return Account(json["id"], json["email"], json["description"], json["first_name"], json["last_name"], json["image"], json["email_confirmed"], json["reviews_media"] + .0, json["holiday_mode"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "description": description,
      "first_name": firstName,
      "last_name": lastName,
      "image": image,
      "email_confirmed": emailConfirmed,
      "reviews_media": reviewsMedia,
      "holiday_mode": holidayMode
    };
  }
}