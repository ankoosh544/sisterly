
import 'package:sisterly/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class SessionData {

  static final SessionData _instance = SessionData._internal();

  factory SessionData() => _instance;

  String? token;
  String? userId;
  String? language;

  var currencyFormat = NumberFormat.currency(symbol: "€", locale: "it_IT");

  var serverUrl = "https://api.v1.sisterly.it";

  SessionData._internal() {
    // init things inside this
  }

  logout(context) async {
    token = null;
    userId = null;

    var preferences = await SharedPreferences.getInstance();
    preferences.remove(Constants.PREFS_REFRESH_TOKEN);
    preferences.remove(Constants.PREFS_USERID);

    await clearStorageData();

    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()), (_) => false);
  }

  clearStorageData() async {
    var preferences = await SharedPreferences.getInstance();
    preferences.remove(Constants.PREFS_TOKEN);
  }

}