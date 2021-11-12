
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


class SisterAdviceScreen extends StatefulWidget {

  const SisterAdviceScreen({Key? key}) : super(key: key);

  @override
  SisterAdviceScreenState createState() => SisterAdviceScreenState();

}

class SisterAdviceScreenState extends State<SisterAdviceScreen> {

  @override
  void initState() {
    super.initState();
    Timer.run(() {

    });
  }

  @override
  void dispose() {
    super.dispose();
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
                    InkWell(
                      child: SvgPicture.asset("assets/images/back_black.svg"),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(height: 16,),
                    Center(
                      child: Text(
                        "Do you want advice from a sister?",
                        style: const TextStyle(
                            color: Constants.SECONDARY_COLOR,
                            fontSize: 16,
                            fontFamily: Constants.FONT
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16,),
                    Center(
                      child: Text(
                        "Here's how to upload the perfect photo",
                        style: const TextStyle(
                            color: Constants.PRIMARY_COLOR,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: Constants.FONT
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 28,),
                    getIconTextWidget("assets/images/bright.svg", "1. Choose a bright place to bring out the colors of the bag."),
                    SizedBox(height: 40,),
                    getIconTextWidget("assets/images/bg_transp.svg", "2. The app delete the background but you help us by choosing a clean background."),
                    SizedBox(height: 40,),
                    getIconTextWidget("assets/images/highlights.svg", "3. Remember to highlights any flaws of the bag and show all sides/details."),
                    SizedBox(height: 40,),
                    getIconTextWidget("assets/images/bag.svg", "4. The first photo must always be a full photo of the bag in front."),
                    SizedBox(height: 40,),
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
