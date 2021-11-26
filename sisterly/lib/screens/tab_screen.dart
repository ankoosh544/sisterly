import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sisterly/screens/account_screen.dart';
import 'package:sisterly/screens/home_screen.dart';
import 'package:sisterly/screens/reset_screen.dart';
import 'package:sisterly/screens/search_screen.dart';
import 'package:sisterly/screens/signup_screen.dart';
import 'package:sisterly/screens/signup_success_screen.dart';
import 'package:sisterly/screens/upload_screen.dart';
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

class TabScreen extends StatefulWidget {

  const TabScreen({Key? key}) : super(key: key);

  @override
  TabScreenState createState() => TabScreenState();
}

class TabScreenState extends State<TabScreen>  {

  int selectedTab = 0;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getTabItem(String icon, String iconActive, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
        debugPrint("index "+index.toString()+"  selectedTab: "+selectedTab.toString());
      },
      child: Container(
        padding: const EdgeInsets.all(0),
        child: SvgPicture.asset(selectedTab == index ? iconActive : icon),
      ),
    );
  }

  Widget getChild() {
    switch(selectedTab) {
      case 0: return HomeScreen();
      case 1: return SearchScreen();
      case 3: return AccountScreen();
    }

    return HomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: FloatingActionButton(
          backgroundColor: Constants.SECONDARY_COLOR,
          child: SvgPicture.asset("assets/images/plus.svg"),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => UploadScreen()));
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(child: getChild()),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset(0, -10), // changes position of shadow
                  ),
                ],
              ),
              height: 73,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getTabItem("assets/images/home.svg", "assets/images/home_active.svg", 0),
                  getTabItem("assets/images/search.svg", "assets/images/search_active.svg", 1),
                  SizedBox(),
                  getTabItem("assets/images/mail.svg", "assets/images/mail.svg", 2),
                  getTabItem("assets/images/account.svg", "assets/images/account_active.svg", 3),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
