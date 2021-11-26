import 'package:flutter/cupertino.dart';

class Account {
  final String email;
  final String? description;
  final String? firstName;
  final String? lastName;
  final String? image;
  final bool emailConfirmed;

  Account(this.email, this.description, this.firstName, this.lastName, this.image, this.emailConfirmed);

  factory Account.fromJson(Map<String, dynamic> json) {
    debugPrint("Account.fromJson " + json.toString());
    return Account(json["email"], json["description"], json["first_name"], json["last_name"], json["image"], json["email_confirmed"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "description": description,
      "firstName": firstName,
      "lastName": lastName,
      "image": image,
      "emailConfirmed": emailConfirmed
    };
  }
}