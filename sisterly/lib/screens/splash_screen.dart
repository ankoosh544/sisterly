
import 'dart:async';
import 'dart:convert';

import 'package:sisterly/screens/home_screen.dart';
import 'package:sisterly/screens/login_screen.dart';
import 'package:sisterly/screens/tab_screen.dart';
import 'package:sisterly/screens/welcome_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:sisterly/utils/localization/app_localizations.dart';
import 'package:sisterly/utils/session_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {

  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();

}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      debugPrint("splash screen initState");

      loadConfig();
    });
  }

  loadConfig() async {
    var preferences = await SharedPreferences.getInstance();

    var refreshToken = preferences.getString(Constants.PREFS_REFRESH_TOKEN);

    Future.delayed(const Duration(milliseconds: 400), () async {
      debugPrint("SplashScreen loadConfig. refreshToken: "+refreshToken.toString());
      autologin();
    });
  }

  goToHome() {
    Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => LoginScreen()), (_) => false);
  }

  autologin() async {
    var preferences = await SharedPreferences.getInstance();
    var refreshToken = preferences.getString(Constants.PREFS_REFRESH_TOKEN);

    if(refreshToken != null) {
      debugPrint("authentication refreshToken: " + refreshToken);

      ApiManager(context).refreshToken(refreshToken, (response) async {
        debugPrint("authentication refreshToken success");

        if(response["access"] != null) {
          preferences.setString(Constants.PREFS_TOKEN, response["access"]);
          preferences.setString(Constants.PREFS_REFRESH_TOKEN, response["refresh"]);
          SessionData().token = response["access"];
          access();
        } else {
          debugPrint("authentication refreshToken not valid");
          SessionData().token = null;
          await SessionData().clearStorageData();
          goToLogin();
        }
      }, (error) async {
        debugPrint("authentication refreshToken failure");
        SessionData().token = null;
        await SessionData().clearStorageData();
        goToLogin();
      });
    } else {
      SessionData().token = null;
      await SessionData().clearStorageData();
      goToLogin();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  goToTutorial() {
    setState(() {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => WelcomeScreen()), (_) => false); //welcomescreen
      //Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => WelcomeScreen()), (_) => false);
    });
  }

  goToLogin() {
    setState(() {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()), (_) => false);
    });
  }

  access() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => TabScreen()), (_) => false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.WHITE,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SvgPicture.asset("assets/images/bg_splash.svg",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fill,
          ),
          SafeArea(
            child: Center(
              child: Wrap(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SvgPicture.asset("assets/images/sisterly_logo.svg",
                        width: 221,
                        height: 223,
                      ),
                      const SizedBox(height: 30,),
                      Text(
                        AppLocalizations.of(context).translate("generic_loading"),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: Constants.FONT,
                            fontWeight: FontWeight.w500
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
