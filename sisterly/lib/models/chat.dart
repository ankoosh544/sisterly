import 'account.dart';

class Chat {

  final String code;
  final Account user;

  Chat(
      this.code,
      this.user);

  factory Chat.fromJson(Map<String, dynamic> json) {
    Chat chat = Chat(
        json["code"],
        Account.fromJson(json["user"]),
    );

    return chat;
  }
}
