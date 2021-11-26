import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
import 'package:image_picker/image_picker.dart';

import '../utils/constants.dart';
import 'login_screen.dart';

class UploadScreen extends StatefulWidget {

  const UploadScreen({Key? key}) : super(key: key);

  @override
  UploadScreenState createState() => UploadScreenState();
}

class UploadScreenState extends State<UploadScreen>  {

  final TextEditingController _modelText = TextEditingController();
  final TextEditingController _brandText = TextEditingController();
  final TextEditingController _descriptionText = TextEditingController();
  final ImagePicker picker = ImagePicker();
  List<XFile>? _images;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getColorBullet(Color color, bool selected) {
    return Container(
        width: 24,
        height: 24,
        margin: const EdgeInsets.only(right: 12, bottom: 8),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30)
        ),
        child: selected ? SizedBox() : SvgPicture.asset("assets/images/check_color.svg", width: 13, height: 10, fit: BoxFit.scaleDown)
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
                            "Upload",
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
                      Text(
                        "Offer a New Bag",
                        style: TextStyle(
                            color: Constants.DARK_TEXT_COLOR,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: Constants.FONT
                        ),
                      ),
                      SizedBox(height: 24,),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Constants.SECONDARY_COLOR_LIGHT
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Text(
                              "Add up to 20 photos",
                              style: TextStyle(
                                  color: Constants.LIGHT_TEXT_COLOR,
                                  fontSize: 14,
                                  fontFamily: Constants.FONT
                              )
                            ),
                            SizedBox(height: 10),
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Constants.SECONDARY_COLOR),
                                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 46, vertical: 14)),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))
                              ),
                              child: Text(
                                  "Upload Photos",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: Constants.FONT
                                  )
                              ),
                              onPressed: () async {
                                _images = await picker.pickMultiImage();
                                setState(() {});
                              },
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SisterAdviceScreen()));
                              },
                              child: Text(
                                  "See photo tips",
                                  style: TextStyle(
                                    color: Constants.PRIMARY_COLOR,
                                    fontSize: 14,
                                    fontFamily: Constants.FONT,
                                    decoration: TextDecoration.underline
                                  )
                              ),
                            ),
                            SizedBox(height: 10),
                            // SizedBox(
                            //   height: 400,
                            //   width: double.infinity,
                            //   child: StaggeredGridView.count(
                            //     crossAxisCount: 2,
                            //     children: [
                            //       Container(height: 50, width: 50, color: Colors.blue),
                            //       Container(height: 50, width: 50, color: Colors.blue),
                            //       Container(height: 50, width: 50, color: Colors.blue)
                            //       // if (_images != null && _images!.isNotEmpty)
                            //       //   for (var img in _images!)
                            //       //     Image.file(File(img.path), width: 100, height: 100,)
                            //     ]
                            //   ),
                            // ),
                            SizedBox(height: 10)
                          ]
                        )
                      ),
                      SizedBox(height: 24,),
                      Text(
                        "Model Name",
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
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Constants.PRIMARY_COLOR,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Constants.FORM_TEXT,
                          ),
                          decoration: InputDecoration(
                            hintText: "Model name...",
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
                          controller: _modelText,
                        ),
                      ),
                      SizedBox(height: 32,),
                      Text(
                        "Brand Name",
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
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Constants.PRIMARY_COLOR,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Constants.FORM_TEXT,
                          ),
                          decoration: InputDecoration(
                            hintText: "Brand name...",
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
                          controller: _brandText,
                        ),
                      ),
                      SizedBox(height: 12,),
                      Text(
                        "The suggested price is calculated on the basis of the average for this stock market model. you can change it at any time.",
                        style: TextStyle(
                            color: Constants.TEXT_COLOR,
                            fontSize: 12,
                            fontFamily: Constants.FONT
                        ),
                      ),
                      SizedBox(height: 32,),
                      Text(
                        "Description",
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
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Constants.PRIMARY_COLOR,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Constants.FORM_TEXT,
                          ),
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "Description...",
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
                          controller: _descriptionText,
                        ),
                      ),
                      SizedBox(height: 32,),
                      Text(
                        "Color",
                        style: TextStyle(
                            color: Constants.DARK_TEXT_COLOR,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: Constants.FONT),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8,),
                      Wrap(
                        children: [
                          getColorBullet(Colors.redAccent, false),
                          getColorBullet(Colors.amberAccent, true),
                          getColorBullet(Colors.blueAccent, false)
                        ],
                      ),
                      SizedBox(height: 32,),
                      Text(
                        "Category",
                        style: TextStyle(
                            color: Constants.DARK_TEXT_COLOR,
                            fontSize: 16,
                            fontFamily: Constants.FONT),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8,),
                      Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x4ca3c4d4),
                              spreadRadius: 2,
                              blurRadius: 15,
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
                            hintText: "Select...",
                            hintStyle: const TextStyle(
                                color: Constants.PLACEHOLDER_COLOR),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            suffixIcon: SvgPicture.asset("assets/images/arrow_down.svg", width: 10, height: 6, fit: BoxFit.scaleDown),
                            contentPadding: const EdgeInsets.all(16),
                            filled: true,
                            fillColor: Constants.WHITE,
                          ),
                          controller: _modelText,
                        ),
                      ),
                      SizedBox(height: 200,)
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
