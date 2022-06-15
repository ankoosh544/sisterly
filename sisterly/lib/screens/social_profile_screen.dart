import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sisterly/models/account.dart';
import 'package:sisterly/models/product.dart';
import 'package:sisterly/screens/product_screen.dart';
import 'package:sisterly/screens/reset_screen.dart';
import 'package:sisterly/screens/signup_screen.dart';
import 'package:sisterly/screens/signup_success_screen.dart';
import 'package:sisterly/screens/tab_screen.dart';
import 'package:sisterly/screens/verify_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:sisterly/utils/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sisterly/utils/session_data.dart';
import 'package:sisterly/widgets/header_widget.dart';
import 'package:sisterly/widgets/stars_widget.dart';

import '../utils/constants.dart';
import 'filters_screen.dart';
import "package:sisterly/utils/utils.dart";

class SocialProfileScreen extends StatefulWidget {

  const SocialProfileScreen({Key? key}) : super(key: key);

  @override
  SocialProfileScreenState createState() => SocialProfileScreenState();
}

class SocialProfileScreenState extends State<SocialProfileScreen>  {

  final TextEditingController _usernameText = TextEditingController();
  final TextEditingController _firstNameText = TextEditingController();
  final TextEditingController _lastNameText = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'IT');

  bool _isLoading = false;
  bool _isLoadingProfile = false;
  Account? _profile;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getUser();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getUser() {
    setState(() {
      _isLoadingProfile = true;
    });
    ApiManager(context).makeGetRequest('/client/properties', {}, (res) {
      // print(res);
      setState(() {
        _isLoadingProfile = false;
        _profile = Account.fromJson(res["data"]);

        _usernameText.text = _profile!.username.toString();
        _firstNameText.text = _profile!.firstName.toString();
        _lastNameText.text = _profile!.lastName.toString();
      });
    }, (res) {
      setState(() {
        _isLoadingProfile = false;
      });
    });
  }

  save() async {
    if (ApiManager.isEmpty(_usernameText.text.trim())) {
      ApiManager.showErrorToast(context, "signup_username_mandatory");
      return;
    }

    if (ApiManager.isEmpty(_firstNameText.text.trim())) {
      ApiManager.showErrorToast(context, "signup_first_name_mandatory");
      return;
    }

    if (ApiManager.isEmpty(_lastNameText.text.trim())) {
      ApiManager.showErrorToast(context, "signup_last_name_mandatory");
      return;
    }

    if (ApiManager.isEmpty(_phoneController.text.trim())) {
      ApiManager.showErrorToast(context, "signup_phome_mandatory");
      return;
    }

    setState(() {
      _isLoading = true;
    });
    var params = {
      "username": _usernameText.text,
      "first_name": _firstNameText.text,
      "last_name": _lastNameText.text,
      "phone": _phoneController.text
    };

    ApiManager(context).makePostRequest('/client/update', params, (res) {
      // print(res);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => TabScreen()), (_) => false);

      setState(() {
        _isLoading = false;
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

  String getFirstName() {
    if(_profile == null) return "";
    return _profile!.firstName!.capitalize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.PRIMARY_COLOR,
      body: Column(
        children: [
          HeaderWidget(title: "Completa Profilo"),
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
                        SizedBox(height: 32),
                        Text(
                          "Username",
                          style: TextStyle(
                              color: Constants.TEXT_COLOR,
                              fontSize: 16,
                              fontFamily: Constants.FONT
                          ),
                        ),
                        SizedBox(height: 8,),
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
                            keyboardType: TextInputType.text,
                            cursorColor: Constants.PRIMARY_COLOR,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Constants.FORM_TEXT,
                            ),
                            decoration: InputDecoration(
                              hintText: "Username..",
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
                            controller: _usernameText,
                          ),
                        ),
                        SizedBox(height: 32),
                        Text(
                          "Nome",
                          style: TextStyle(
                              color: Constants.TEXT_COLOR,
                              fontSize: 16,
                              fontFamily: Constants.FONT
                          ),
                        ),
                        SizedBox(height: 8,),
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
                            keyboardType: TextInputType.text,
                            cursorColor: Constants.PRIMARY_COLOR,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Constants.FORM_TEXT,
                            ),
                            decoration: InputDecoration(
                              hintText: "Nome...",
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
                            controller: _firstNameText,
                          ),
                        ),
                        SizedBox(height: 32),
                        Text(
                          "Cognome",
                          style: TextStyle(
                              color: Constants.TEXT_COLOR,
                              fontSize: 16,
                              fontFamily: Constants.FONT
                          ),
                        ),
                        SizedBox(height: 8,),
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
                            keyboardType: TextInputType.text,
                            cursorColor: Constants.PRIMARY_COLOR,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Constants.FORM_TEXT,
                            ),
                            decoration: InputDecoration(
                              hintText: "Cognome...",
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
                            controller: _lastNameText,
                          ),
                        ),
                        SizedBox(height: 32),
                        const Text("Cellulare",
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
                              hintText: "Cellulare",
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
                        SafeArea(
                          child: Center(
                            child: _isLoading ? CircularProgressIndicator() : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Constants.SECONDARY_COLOR,
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 80, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              child: Text('Continua'),
                              onPressed: () {
                                save();
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
