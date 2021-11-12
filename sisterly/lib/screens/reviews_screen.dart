import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sisterly/screens/product_screen.dart';
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

class ReviewsScreen extends StatefulWidget {

  const ReviewsScreen({Key? key}) : super(key: key);

  @override
  ReviewsScreenState createState() => ReviewsScreenState();
}

class ReviewsScreenState extends State<ReviewsScreen>  {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget reviewCell() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.circular(15),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.asset("assets/images/product.png", width: 50, height: 50, fit: BoxFit.cover,)
                ),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Beatrice Pedrali",
                        style: TextStyle(
                            color: Constants.DARK_TEXT_COLOR,
                            fontSize: 16,
                            fontFamily: Constants.FONT
                        ),
                      ),
                      SizedBox(height: 6,),
                      Wrap(
                        spacing: 3,
                        children: [
                          SvgPicture.asset("assets/images/star.svg", width: 11, height: 11,),
                          SvgPicture.asset("assets/images/star.svg", width: 11, height: 11,),
                          SvgPicture.asset("assets/images/star.svg", width: 11, height: 11,),
                          SvgPicture.asset("assets/images/star.svg", width: 11, height: 11,),
                          SvgPicture.asset("assets/images/star.svg", width: 11, height: 11,),
                          Text(
                            "5.0",
                            style: TextStyle(
                                color: Constants.DARK_TEXT_COLOR,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.FONT
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(width: 12,),
                Text(
                  "1 day ago",
                  style: TextStyle(
                      color: Constants.LIGHT_GREY_COLOR,
                      fontSize: 14,
                      fontFamily: Constants.FONT
                  ),
                ),
              ],
            ),
            SizedBox(height: 12,),
            Text(
              "There is now an abundance of readable dummy texts. These are usually used when a text is required purely to fill a space.",
              style: TextStyle(
                  color: Constants.TEXT_COLOR,
                  fontSize: 14,
                  fontFamily: Constants.FONT
              ),
            ),
          ],
        ),
      ),
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
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: SizedBox(child: SvgPicture.asset("assets/images/back.svg")),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Text(
                          "Reviews",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: Constants.FONT),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      InkWell(
                        child: SizedBox(width: 17, height: 19, child: SvgPicture.asset("assets/images/menu.svg", width: 17, height: 19, fit: BoxFit.scaleDown,)),
                        onTap: () {

                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16,),
          Expanded(
            child: SingleChildScrollView(
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
                      SizedBox(height: 8),
                      Row(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(68.0),
                              child: Image.asset("assets/images/product.png", width: 68, height: 68, fit: BoxFit.cover,)
                          ),
                          SizedBox(width: 12,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Beatrice Pedrali",
                                style: TextStyle(
                                    color: Constants.DARK_TEXT_COLOR,
                                    fontSize: 20,
                                    fontFamily: Constants.FONT
                                ),
                              ),
                              SizedBox(height: 6,),
                              Text(
                                "Milan",
                                style: TextStyle(
                                    color: Constants.LIGHT_TEXT_COLOR,
                                    fontSize: 15,
                                    fontFamily: Constants.FONT
                                ),
                              ),
                              SizedBox(height: 6,),
                              Wrap(
                                spacing: 3,
                                children: [
                                  SvgPicture.asset("assets/images/star.svg", width: 11, height: 11,),
                                  SvgPicture.asset("assets/images/star.svg", width: 11, height: 11,),
                                  SvgPicture.asset("assets/images/star.svg", width: 11, height: 11,),
                                  SvgPicture.asset("assets/images/star.svg", width: 11, height: 11,),
                                  SvgPicture.asset("assets/images/star.svg", width: 11, height: 11,),
                                  Text(
                                    "5.0",
                                    style: TextStyle(
                                        color: Constants.DARK_TEXT_COLOR,
                                        fontSize: 14,
                                        fontFamily: Constants.FONT
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 24,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/images/italy.svg", width: 22, height: 22,),
                              SizedBox(width: 8,),
                              Text(
                                "Italian since 1996",
                                style: TextStyle(
                                    color: Constants.LIGHT_TEXT_COLOR,
                                    fontSize: 14,
                                    fontFamily: Constants.FONT
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/images/italy.svg", width: 22, height: 22,),
                              SizedBox(width: 8,),
                              Text(
                                "Italian since 1996",
                                style: TextStyle(
                                    color: Constants.LIGHT_TEXT_COLOR,
                                    fontSize: 14,
                                    fontFamily: Constants.FONT
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 12,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/images/italy.svg", width: 22, height: 22,),
                              SizedBox(width: 8,),
                              Text(
                                "SDA Bocconi School of Management",
                                style: TextStyle(
                                    color: Constants.LIGHT_TEXT_COLOR,
                                    fontSize: 14,
                                    fontFamily: Constants.FONT
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 40,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Reviews",
                            style: TextStyle(
                                color: Constants.DARK_TEXT_COLOR,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.FONT
                            ),
                          ),
                          Text(
                            "See All",
                            style: TextStyle(
                                color: Constants.SECONDARY_COLOR,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.FONT,
                              decoration: TextDecoration.underline
                            ),
                          ),
                        ],
                      ),
                      MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 6,
                          itemBuilder: (BuildContext context, int index) {
                            return reviewCell();
                          }
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
