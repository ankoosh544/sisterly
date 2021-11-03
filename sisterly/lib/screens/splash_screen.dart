
import 'dart:async';
import 'dart:convert';

import 'package:sisterly/screens/home_screen.dart';
import 'package:sisterly/screens/login_screen.dart';
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

    /*if(!SessionData().needRefreshToken) {
      goToLogin();
      return;
    }*/

    var preferences = await SharedPreferences.getInstance();
    var refreshToken = preferences.getString(Constants.PREFS_REFRESH_TOKEN);
    var tutorialCompleted = preferences.getBool(Constants.PREFS_TUTORIAL_COMPLETED) ?? false;
    debugPrint("tutorialCompleted: "+tutorialCompleted.toString()+" and"+preferences.getBool(Constants.PREFS_TUTORIAL_COMPLETED).toString());
    SessionData().userId = preferences.getString(Constants.PREFS_USERID);

    debugPrint("autheSharedPreferences.getInntication autologin. tutorialCompleted: "+tutorialCompleted.toString());

    if(!tutorialCompleted) {
      //ApiManager.showFreeToast(context, "refresh 2");
      goToTutorial();
      return;
    }

    if(refreshToken != null && SessionData().userId != null) {
      debugPrint("authentication refreshToken userId: " + SessionData().userId.toString() + " - refreshToken: " + refreshToken);

      ApiManager(context).refreshToken(refreshToken, SessionData().userId, (response) async {
        debugPrint("authentication refreshToken success");

        if(response["data"] != null) {
          //ApiManager.showFreeToast(context, "refresh 3");
          preferences.setString(Constants.PREFS_TOKEN, response["data"].toString());
          SessionData().token = response["data"].toString();

          /*ApiManager(context).getUser(SessionData().userId, (response) async {
            debugPrint("authentication getUser success");
            Map<String, dynamic> rawItem = new Map<String, dynamic>.from(response["data"]);

            //ApiManager.showFreeToast(context, "refresh 4");

            SessionData().userId = preferences.getString(Constants.PREFS_USERID);

            setState(() {
              SessionData().user = User(rawItem);
            });
            await ApiManager(context).loadEconomy();
            await ApiManager(context).loadLanguage();

            await preferences.setString(Constants.PREFS_USER, jsonEncode(SessionData().user));

            ApiManager(context).subscribePushNotifications(SessionData().user);
            goToHome();
          }, (error) async {
            //ApiManager.showFreeToast(context, "refresh 5");
            debugPrint("authentication getUser failure");
            SessionData().token = null;
            SessionData().userId = null;
            await SessionData().clearStorageData();
            goToLogin();
          });*/
        } else {
          //ApiManager.showFreeToast(context, "refresh 6 "+refreshToken.toString());
          debugPrint("authentication refreshToken not valid");
          SessionData().token = null;
          SessionData().userId = null;
          await SessionData().clearStorageData();
          goToLogin();
        }
      }, (error) async {
        //ApiManager.showFreeToast(context, "refresh 7");
        debugPrint("authentication refreshToken failure");
        SessionData().token = null;
        SessionData().userId = null;
        await SessionData().clearStorageData();
        goToLogin();
      });
    } else {
      //ApiManager.showFreeToast(context, "refresh 8");
      SessionData().token = null;
      SessionData().userId = null;
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
      Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => HomeScreen()), (_) => false); //welcomescreen
      //Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => WelcomeScreen()), (_) => false);
    });
  }

  goToLogin() {
    setState(() {
      Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => LoginScreen()), (_) => false);
    });
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
