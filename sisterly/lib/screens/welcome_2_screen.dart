
import 'dart:async';
import 'dart:convert';

import 'package:sisterly/screens/login_screen.dart';
import 'package:sisterly/screens/signup_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:sisterly/utils/localization/app_localizations.dart';
import 'package:sisterly/utils/session_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Welcome2Screen extends StatefulWidget {

  const Welcome2Screen({Key? key}) : super(key: key);

  @override
  Welcome2ScreenState createState() => Welcome2ScreenState();

}

class Welcome2ScreenState extends State<Welcome2Screen> {

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      debugPrint("welcome 2 screen initState");

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  login() {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    });
  }

  signup() {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SignupScreen()));
    });
  }

  Widget getIconTextWidget(String iconName, String text) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 6,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 18),
            child: SvgPicture.asset(iconName, height: 29,),
          ),
        ),
        const SizedBox(height: 14,),
        Text(
          text,
          style: const TextStyle(
              color: Constants.TEXT_COLOR,
              fontSize: 16,
              fontFamily: Constants.FONT
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 32,),
                    Center(
                      child: SvgPicture.asset("assets/images/sisterly_logo.svg",
                        width: 160,
                        height: 90,
                      ),
                    ),
                    SizedBox(height: 28,),
                    getIconTextWidget("community", "A new way of experiencing fashion in a community of lender and borrower sisters!"),
                    SizedBox(height: 40,),
                    getIconTextWidget("bag", "The bag that's right for you, when you want and where you want. Explore the catalog and search among the offers."),
                    SizedBox(height: 40,),
                    getIconTextWidget("rent", "Rent the bags you no longer use and start earning comfortably and safely."),
                    SizedBox(height: 40,),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              primary: Constants.PRIMARY_COLOR,
                              textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),
                              side: const BorderSide(color: Constants.PRIMARY_COLOR, width: 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                              )
                            ),
                            child: Text('Become a Sister'),
                            onPressed: () {
                              signup();
                            },
                          ),
                        ),
                        SizedBox(width: 12,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Constants.SECONDARY_COLOR,
                              textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),
                            padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                          ),
                          child: Text('Login'),
                          onPressed: () {
                            login();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
