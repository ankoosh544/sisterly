import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sisterly/screens/reset_screen.dart';
import 'package:sisterly/screens/signup_screen.dart';
import 'package:sisterly/screens/signup_success_screen.dart';
import 'package:sisterly/screens/verify_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:sisterly/utils/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sisterly/widgets/custom_app_bar.dart';

import '../utils/constants.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>  {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget productCell() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xfff5f5f5),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Image.asset("assets/images/product.png", height: 169,),
            ),
            Positioned(
              top: 16,
              right: 16,
                child: InkWell(
                  child: SizedBox(width: 16, height: 16, child: SvgPicture.asset("assets/images/save.svg")),
                )
            )
          ],
        ),
        SizedBox(height: 16,),
        Text(
          "Chain-Cassette Bottega Veneta",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Constants.TEXT_COLOR,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8,),
        Text(
          "€30 per day",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Constants.PRIMARY_COLOR,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.PRIMARY_COLOR,
      body: Column(
        children: [
          Stack(
            children: [
              Align(
                  child: SvgPicture.asset("assets/images/wave_blue.svg"),
                alignment: Alignment.topRight,
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Container(
                          width: 42,
                          height: 42,
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: Color(0xff337a9d),
                            borderRadius: BorderRadius.circular(42)
                          ),
                          child: SizedBox(width: 70, height: 40, child: SvgPicture.asset("assets/images/saved_white.svg", width: 19, height: 19, fit: BoxFit.scaleDown))
                        ),
                        onTap: () {

                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Text(
                          "Home",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: Constants.FONT),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      InkWell(
                        child: Container(
                            width: 42,
                            height: 42,
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                                color: Color(0xff337a9d),
                                borderRadius: BorderRadius.circular(42)
                            ),
                            child: SizedBox(width: 17, height: 19, child: SvgPicture.asset("assets/images/nfc.svg", width: 17, height: 19, fit: BoxFit.scaleDown,))
                        ),
                        onTap: () {

                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 16),
                    productCell(),
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