import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sisterly/screens/product_screen.dart';
import 'package:sisterly/screens/profile_screen.dart';
import 'package:sisterly/screens/reset_screen.dart';
import 'package:sisterly/screens/reviews_screen.dart';
import 'package:sisterly/screens/signup_screen.dart';
import 'package:sisterly/screens/signup_success_screen.dart';
import 'package:sisterly/screens/sister_advice_screen.dart';
import 'package:sisterly/screens/verify_screen.dart';
import 'package:sisterly/screens/wishlist_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:sisterly/utils/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sisterly/widgets/custom_app_bar.dart';

import '../utils/constants.dart';
import 'login_screen.dart';

class AccountScreen extends StatefulWidget {

  const AccountScreen({Key? key}) : super(key: key);

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen>  {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getItem(String icon, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 6,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
              child: SvgPicture.asset(icon, width: 15, fit: BoxFit.scaleDown,)
          ),
          SizedBox(width: 18,),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                  color: Constants.TEXT_COLOR,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: Constants.FONT
              ),
            ),
          ),
          SvgPicture.asset("assets/images/arrow.svg")
        ],
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
                    children: const [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: Text(
                            "Your Profile",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.FONT),
                            textAlign: TextAlign.center,
                          ),
                        ),
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
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) => ProfileScreen()));
                        },
                        child: Text(
                          "View Your Profile",
                          style: TextStyle(
                              color: Constants.PRIMARY_COLOR,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontFamily: Constants.FONT
                          ),
                        ),
                      ),
                      SizedBox(height: 24,),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (BuildContext context) => SisterAdviceScreen()));
                          },
                          child: getItem("assets/images/guidebook.svg", "Sisterly Guide")
                      ),
                      getItem("assets/images/edit.svg", "Edit Your Profile"),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (BuildContext context) => WishlistScreen()));
                          },
                          child: getItem("assets/images/articles_saved.svg", "Articles Saved")
                      ),
                      getItem("assets/images/rent 2.svg", "My Rentals"),
                      getItem("assets/images/chat.svg", "Sister Talks"),
                      getItem("assets/images/invite.svg", "Invite a Sister"),
                      getItem("assets/images/offer.svg", "Your Offers"),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) => ReviewsScreen()));
                        },
                          child: getItem("assets/images/review.svg", "Your Reviews")
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
