import 'package:sisterly/screens/tab_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sisterly/utils/session_data.dart';

import '../utils/constants.dart';
import 'forgot_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final TextEditingController _emailFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();

  //final FocusNode _passwordFocus = new FocusNode();
  final _formKey = GlobalKey<FormState>(debugLabel: '_loginFormKey');

  bool _showPassword = false;

  @override
  void initState() {
    super.initState();

    precompileEmail();
  }

  precompileEmail() async {
    var preferences = await SharedPreferences.getInstance();
    final email = preferences.getString(Constants.PREFS_EMAIL);

    if (email != null) {
      setState(() {
        _emailFilter.text = email;
      });
    }
  }

  login() async {
    //Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => new TabScreen()), (_) => false);
    if (ApiManager.isEmpty(_emailFilter.text.trim())) {
      ApiManager.showErrorToast(context, "login_email_mandatory");
      return;
    }

    if (ApiManager.isEmpty(_passwordFilter.text.trim())) {
      ApiManager.showErrorToast(context, "login_password_mandatory");
      return;
    }

    _emailFilter.text = _emailFilter.text.toLowerCase().trim();

    ApiManager(context).login(_emailFilter.text.trim(), _passwordFilter.text,
        (response) async {
      if (response["access"] != null) {
        debugPrint("login success");

        var preferences = await SharedPreferences.getInstance();
        preferences.setString(Constants.PREFS_EMAIL, _emailFilter.text);
        preferences.setString(Constants.PREFS_TOKEN, response["access"]);
        preferences.setString(Constants.PREFS_REFRESH_TOKEN, response["refresh"]);
        SessionData().token = response["access"];

        loginSuccess();
      } else {
        ApiManager.showErrorMessage(context, response["code"]);
      }
    }, (statusCode) {
      ApiManager.showErrorMessage(context, "generic_error");
      debugPrint("login failure");
    });
  }

  loginSuccess() async {
    await ApiManager(context).loadLanguage();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => TabScreen()), (_) => false);
  }

  forgot() {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ForgotScreen(email: _emailFilter.text,)));
    });
  }

  @override
  void dispose() {
    _emailFilter.dispose();
    _passwordFilter.dispose();
    super.dispose();
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
                      if(Navigator.of(context).canPop()) InkWell(
                        child: SvgPicture.asset("assets/images/back.svg"),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ) else const SizedBox(
                        width: 24,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Text(
                          "Welcome back",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: Constants.FONT),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 25),
                      const Text("Email",
                          style: TextStyle(
                            color: Constants.TEXT_COLOR,
                            fontSize: 16,
                            fontFamily: Constants.FONT,
                          )),
                      const SizedBox(height: 7),
                      Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x4ca3c4d4),
                              spreadRadius: 8,
                              blurRadius: 12,
                              offset:
                                  Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Constants.PRIMARY_COLOR,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Constants.FORM_TEXT,
                          ),
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: const TextStyle(
                                color: Constants.PLACEHOLDER_COLOR),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            filled: true,
                            fillColor: Constants.WHITE,
                          ),
                          controller: _emailFilter,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text("Password",
                          style: TextStyle(
                            color: Constants.TEXT_COLOR,
                            fontSize: 16,
                            fontFamily: Constants.FONT,
                          )),
                      const SizedBox(height: 7),
                      Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x4ca3c4d4),
                              spreadRadius: 8,
                              blurRadius: 12,
                              offset:
                                  Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _showPassword,
                          cursorColor: Constants.PRIMARY_COLOR,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Constants.FORM_TEXT,
                          ),
                          decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: SvgPicture.asset(
                                      _showPassword ? "assets/images/hide.svg" : "assets/images/show.svg"),
                                ),
                              ),
                              suffixIconConstraints:
                                  BoxConstraints(minHeight: 24, minWidth: 24),
                              hintText: "Password",
                              hintStyle: const TextStyle(
                                  color: Constants.PLACEHOLDER_COLOR),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(16),
                              filled: true,
                              fillColor: Constants.WHITE),
                          controller: _passwordFilter,
                          onSubmitted: (s) {
                            login();
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            child: const Text(
                              "Forgot password?",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Constants.PRIMARY_COLOR,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => ForgotScreen(email: _emailFilter.text,),
                                  )
                              );
                            },
                          ),
                        ],
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      SafeArea(
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Constants.SECONDARY_COLOR,
                                textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 80, vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                            child: Text('Login'),
                            onPressed: () {
                              login();
                            },
                          ),
                        ),
                      ),
                      /*Center(
                        child: CustomProgressButton(
                          borderRadius: 10,
                          height: MediaQuery.of(context).size.height * 0.055,
                          backgroundColor: Constants.SECONDARY_COLOR,
                          initialWidth: MediaQuery.of(context).size.width,
                          label: AppLocalizations.of(context).translate("login_login").toUpperCase(),
                          buttonController: _buttonController,
                          textColor: Constants.WHITE,
                          fontWeight: FontWeight.bold,
                          fontFamily: Constants.FONT,
                          fontSize: 18,
                          onTap: (){
                            login();
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      CustomDefaultButton(
                        fontFamily: Constants.FONT,
                        borderRadius: 10,
                        height: MediaQuery.of(context).size.height * 0.055,
                        backgroundColor: Constants.WHITE,
                        boxShadowOpacity: 0,
                        width: MediaQuery.of(context).size.width,
                        label: AppLocalizations.of(context).translate("login_register_button").toUpperCase(),
                        textColor: Constants.PRIMARY_COLOR_DARK,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) => SignupScreen()
                              )
                          );
                        },
                      ),*/
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
