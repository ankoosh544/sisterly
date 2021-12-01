import 'package:cached_network_image/cached_network_image.dart';
import 'package:package_info/package_info.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sisterly/models/account.dart';
import 'package:sisterly/screens/inbox_screen.dart';
import 'package:sisterly/screens/product_screen.dart';
import 'package:sisterly/screens/profile_screen.dart';
import 'package:sisterly/screens/reset_screen.dart';
import 'package:sisterly/screens/reviews_screen.dart';
import 'package:sisterly/screens/signup_screen.dart';
import 'package:sisterly/screens/signup_success_screen.dart';
import 'package:sisterly/screens/sister_advice_screen.dart';
import 'package:sisterly/screens/splash_screen.dart';
import 'package:sisterly/screens/verify_screen.dart';
import 'package:sisterly/screens/welcome_2_screen.dart';
import 'package:sisterly/screens/welcome_screen.dart';
import 'package:sisterly/screens/wishlist_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:sisterly/utils/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sisterly/utils/session_data.dart';
import 'package:share/share.dart';
import "package:sisterly/utils/utils.dart";
import '../utils/constants.dart';

class AccountScreen extends StatefulWidget {

  const AccountScreen({Key? key}) : super(key: key);

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen>  {

  bool _isLoading = false;
  Account? _profile;
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      getUser();

      _packageInfo = await PackageInfo.fromPlatform();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getUser() {
    setState(() {
      _isLoading = true;
    });
    ApiManager(context).makeGetRequest('/client/properties', {}, (res) {
      // print(res);
      setState(() {
        _isLoading = false;
        _profile = Account.fromJson(res["data"]);
      });
    }, (res) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  String getFullName() {
    if(_profile == null) return "";
    return _profile!.firstName!.capitalize() + " " + _profile!.lastName!.capitalize();
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
                            "Il tuo profilo",
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
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 8),
                        _isLoading ? CircularProgressIndicator() : Row(
                          children: [
                            if(_profile != null && _profile!.image != null) ClipRRect(
                                borderRadius: BorderRadius.circular(68.0),
                                child: CachedNetworkImage(
                                  width: 68, height: 68, fit: BoxFit.cover,
                                  imageUrl: _profile!.image!,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                            ),
                            if(_profile != null && _profile!.image != null) SizedBox(width: 12,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getFullName(),
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
                                MaterialPageRoute(builder: (BuildContext context) => ProfileScreen(id: null,)));
                          },
                          child: Text(
                            "Vai al tuo profilo",
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
                            child: getItem("assets/images/guidebook.svg", "Guida Sisterly")
                        ),
                        /*getItem("assets/images/edit.svg", "Edit Your Profile"),*/
                        InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (BuildContext context) => WishlistScreen()));
                            },
                            child: getItem("assets/images/articles_saved.svg", "Lista dei desideri")
                        ),
                        getItem("assets/images/rent 2.svg", "I miei noleggi"),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (BuildContext context) => InboxScreen()));
                            },
                            child: getItem("assets/images/chat.svg", "Sister Chats")
                        ),
                        InkWell(
                          onTap: () {
                            Share.share('check out my website https://example.com');
                          },
                            child: getItem("assets/images/invite.svg", "Invita una Sister")
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (BuildContext context) => ProfileScreen(id: null,)));
                          },
                            child: getItem("assets/images/offer.svg", "I tuoi prodotti")
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (BuildContext context) => ReviewsScreen()));
                          },
                            child: getItem("assets/images/review.svg", "Le tue recensioni")
                        ),
                        InkWell(
                          onTap: () {
                            SessionData().logout(context);
                          },
                            child: getItem("assets/images/logout.svg", "Esci")
                        ),
                        SizedBox(height: 8,),
                        Divider(),
                        SizedBox(height: 16,),
                        if(_packageInfo != null) Text(
                          "Versione " + _packageInfo!.version + " (" + _packageInfo!.buildNumber + ")",
                          style: TextStyle(
                              color: Constants.LIGHT_GREY_COLOR,
                              fontSize: 16,
                              fontFamily: Constants.FONT
                          ),
                        ),
                        SizedBox(height: 16,),
                      ],
                    ),
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
