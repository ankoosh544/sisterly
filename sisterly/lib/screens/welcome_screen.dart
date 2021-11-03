
import 'dart:async';
import 'dart:convert';

import 'package:sisterly/screens/login_screen.dart';
import 'package:sisterly/screens/welcome_2_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:sisterly/utils/localization/app_localizations.dart';
import 'package:sisterly/utils/session_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WelcomeScreen extends StatefulWidget {

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  WelcomeScreenState createState() => WelcomeScreenState();

}

class WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      debugPrint("welcome screen initState");

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  next() {
    setState(() {
      Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => Welcome2Screen()), (_) => false);
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 120,),
                  Center(
                    child: SvgPicture.asset("assets/images/sisterly_logo.svg",
                      width: 221,
                      height: 223,
                    ),
                  ),
                  SizedBox(height: 70,),
                  const Text(
                    "Hey Sister",
                    style: TextStyle(
                        color: Constants.PRIMARY_COLOR,
                        fontSize: 16,
                        fontFamily: Constants.FONT
                    ),
                  ),
                  SizedBox(height: 8,),
                  Wrap(
                    children: const [
                      Text(
                        "Welcome to ",
                        style: TextStyle(
                            color: Constants.PRIMARY_COLOR,
                            fontSize: 25,
                            fontFamily: Constants.FONT
                        ),
                      ),
                      Text(
                        "Sisterly!",
                        style: TextStyle(
                            color: Constants.PRIMARY_COLOR,
                            fontSize: 25,
                            fontFamily: Constants.FONT,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24,),
                  const Text(
                    "The first Italian platform for peer to peer luxury bag rental.",
                    style: TextStyle(
                        color: Constants.PRIMARY_COLOR,
                        fontSize: 16,
                        fontFamily: Constants.FONT
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 52, vertical: 14)),
                        backgroundColor:  MaterialStateProperty.all<Color>(Constants.SECONDARY_COLOR),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)))),
                      child: Text('Find Out How It Works'),
                      onPressed: () {
                        next();
                      },
                    ),
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
