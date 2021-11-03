import 'package:flutter/gestures.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sisterly/screens/signup_screen.dart';
import 'package:sisterly/screens/verify_phone_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:sisterly/utils/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sisterly/widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/constants.dart';
import 'forgot_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen>  {

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'IT');

  //final FocusNode _passwordFocus = new FocusNode();
  final _formKey = GlobalKey<FormState>(debugLabel: '_signupFormKey');

  bool _showPassword = false;
  bool _terms = false;

  @override
  void initState() {
    super.initState();

  }

  signup() async {
    if (ApiManager.isEmpty(_emailController.text.trim())) {
      ApiManager.showErrorToast(context, "login_email_mandatory");
      return;
    }

    if (ApiManager.isEmpty(_emailController.text.trim())) {
      ApiManager.showErrorToast(context, "login_email_mandatory");
      return;
    }

    if (ApiManager.isEmpty(_emailController.text.trim())) {
      ApiManager.showErrorToast(context, "login_email_mandatory");
      return;
    }

    if (ApiManager.isEmpty(_emailController.text.trim())) {
      ApiManager.showErrorToast(context, "login_email_mandatory");
      return;
    }

    if (ApiManager.isEmpty(_passwordController.text.trim())) {
      ApiManager.showErrorToast(context, "login_password_mandatory");
      return;
    }

    _emailController.text = _emailController.text.toLowerCase().trim();

    /*ApiManager(context).login(_emailController.text.trim(), _passwordController.text,
        (response) async {
      if (response["success"] == true) {
        debugPrint("login success");

        var preferences = await SharedPreferences.getInstance();
        preferences.setString(Constants.PREFS_EMAIL, _emailController.text);

        signupSuccess(response["data"]);
      } else {
        ApiManager.showErrorMessage(context, response["code"]);
      }
    }, (statusCode) {
      ApiManager.showErrorMessage(context, "generic_error");
      debugPrint("login failure");
    });*/

    signupSuccess();
  }

  signupSuccess() async {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => VerifyPhoneScreen(phone: _phoneController.text, email: _emailController.text,)));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                          "Sign up",
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
            child: SingleChildScrollView(
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
                            keyboardType: TextInputType.name,
                            cursorColor: Constants.PRIMARY_COLOR,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Constants.FORM_TEXT,
                            ),
                            decoration: InputDecoration(
                              hintText: "First name",
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
                            controller: _firstNameController,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text("Last name",
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
                            keyboardType: TextInputType.name,
                            cursorColor: Constants.PRIMARY_COLOR,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Constants.FORM_TEXT,
                            ),
                            decoration: InputDecoration(
                              hintText: "Last name",
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
                            controller: _lastNameController,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text("Phone number",
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
                          child: InternationalPhoneNumberInput(
                            ignoreBlank: true,
                            formatInput: false,
                            selectorConfig: SelectorConfig(
                                setSelectorButtonAsPrefixIcon: true,
                                showFlags: true,
                                selectorType: PhoneInputSelectorType.DROPDOWN
                            ),
                            onInputChanged: (PhoneNumber number) {
                              this.number = number;
                              //debugPrint("dialCode "+number.dialCode);
                            },
                            onInputValidated: (bool value) {
                            },
                            spaceBetweenSelectorAndTextField: 0,
                            initialValue: number,
                            keyboardType: TextInputType.number,
                            textFieldController: _phoneController,
                            textStyle: TextStyle(
                                fontSize: 16,
                                color: Constants.PRIMARY_COLOR
                            ),
                            selectorTextStyle: TextStyle(
                                fontSize: 16,
                                color: Constants.PRIMARY_COLOR
                            ),
                            inputDecoration: InputDecoration(
                              hintText: "Phone number",
                              hintStyle: const TextStyle(
                                  color: Constants.PLACEHOLDER_COLOR),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              filled: true,
                              fillColor: Constants.WHITE,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
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
                              hintText: "Email address",
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
                            controller: _emailController,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text("Create Password",
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
                            controller: _passwordController,
                            onSubmitted: (s) {

                            },
                          ),
                        ),
                        SizedBox(height: 32,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Transform.scale(
                              scale: 1.2,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Color(0xff92a0a7),
                                ),
                                child: Checkbox(
                                    value: _terms,
                                    activeColor: Constants.PRIMARY_COLOR,
                                    onChanged: (value) {
                                      setState(() {
                                        _terms = value!;
                                      });
                                    }
                                ),
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                  text: TextSpan(
                                    //style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(text: "By registering you declare that you have read and to accept ",
                                        style: TextStyle(color: Color(0xff92a0a7), fontSize: 16, fontFamily: Constants.FONT),
                                      ),
                                      TextSpan(text: "terms and conditions.",
                                        style: TextStyle(color: Constants.PRIMARY_COLOR, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: Constants.FONT),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            String url ="https://www.therapyou.it/terms-and-contitions/";
                                            launch(url);
                                          },
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24,),
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
                              child: Text('Confirm'),
                              onPressed: () {
                                signup();
                              },
                            ),
                          ),
                        ),
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
