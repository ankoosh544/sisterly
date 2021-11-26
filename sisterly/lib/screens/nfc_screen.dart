import 'package:sisterly/screens/signup_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:sisterly/utils/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sisterly/widgets/custom_app_bar.dart';

import '../utils/constants.dart';
import 'forgot_screen.dart';
import 'login_screen.dart';

class NfcScreen extends StatefulWidget {

  @override
  NfcScreenState createState() => NfcScreenState();
}

class NfcScreenState extends State<NfcScreen> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.PRIMARY_COLOR,
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white,),
        child: Stack(
          children: [
            SvgPicture.asset("assets/images/bg-pink-ellipse.svg"),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                          child: InkWell(
                              child: SizedBox(child: SvgPicture.asset("assets/images/back_black.svg")),
                              onTap: () {
                                Navigator.of(context).pop();
                              }
                          )
                      ),
                    ),
                    const SizedBox(height: 44),
                    Text(
                      "Pronto",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Constants.PRIMARY_COLOR,
                        fontFamily: Constants.FONT,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Mantieni il telefono vicino all'oggetto per scansionarlo",
                        style: TextStyle(
                          color: Constants.TEXT_COLOR,
                          fontSize: 16,
                          fontFamily: Constants.FONT,
                        ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 80),
                    SvgPicture.asset("assets/images/phone_nfc.svg"),
                    const Expanded(
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
