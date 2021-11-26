import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sisterly/models/product_color.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:sisterly/utils/utils.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({Key? key}) : super(key: key);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {

  final TextEditingController _modelText = TextEditingController();
  RangeValues _maximumPriceRange = const RangeValues(0, 100);
  bool _handWithdrawals = false;
  List<int> _conditions = [];
  List<int> _colors = [];
  List<ProductColor> _colorsList = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getColors();
    });
  }

  getColors() {
    ApiManager(context).makeGetRequest('/admin/color', {}, (res) {
      _colorsList = [];

      var data = res["data"];
      if (data != null) {
        for (var prod in data) {
          _colorsList.add(ProductColor.fromJson(prod));
        }
      }

      setState(() {

      });
    }, (res) {

    });
  }

  applyFilters() {

  }

  Widget getTag(int id, String label, List<int> selected) {
    return InkWell(
      onTap: () {
        if(selected.contains(id)) {
          selected.remove(id);
        } else {
          selected.add(id);
        }

        setState(() {

        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: selected.contains(id) ? Color(0xfffedcdc) : Color(0xffeff2f5),
          borderRadius: BorderRadius.circular(60)
        ),
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
              color: selected.contains(id) ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR,
              fontSize: 16,
              height: 1.8,
              fontFamily: Constants.FONT
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget getCategoryRadio(String label, bool selected) {
    return Container(
      width: (MediaQuery.of(context).size.width - 60) / 2,
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      child: Wrap(
        children: [
          SvgPicture.asset(selected ? "assets/images/checked.svg" : "assets/images/check.svg"),
          SizedBox(width: 8,),
          Text(
            label,
            style: TextStyle(
                color: selected ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR,
                fontSize: 16,
                height: 1.8,
                fontFamily: Constants.FONT
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget getColorBullet(int id, Color color, List<int> selected) {
    return InkWell(
      onTap: () {
        if(selected.contains(id)) {
          selected.remove(id);
        } else {
          selected.add(id);
        }

        setState(() {

        });
      },
      child: Container(
        width: 24,
        height: 24,
        margin: const EdgeInsets.only(right: 12, bottom: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30)
        ),
        child: selected.contains(id) ? SizedBox() : SvgPicture.asset("assets/images/check_color.svg", width: 13, height: 10, fit: BoxFit.scaleDown)
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                hintText: "Model designer...",
                                hintStyle: const TextStyle(
                                    color: Constants.PLACEHOLDER_COLOR),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                prefixIcon: SvgPicture.asset("assets/images/search.svg", width: 13, fit: BoxFit.scaleDown,),
                                contentPadding: const EdgeInsets.all(16),
                                filled: true,
                                fillColor: Constants.WHITE,
                              ),
                              controller: _modelText,
                            ),
                          ),
                          SizedBox(height: 40,),
                          /*Text(
                            "Category",
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
                              getCategoryRadio("Shoulder Bag", false),
                              getCategoryRadio("Clutch", true),
                              getCategoryRadio("By Hand", true),
                              getCategoryRadio("Shoppers", true),
                              getCategoryRadio("Backpack", true)
                            ],
                          ),
                          SizedBox(height: 24,),*/
                          Text(
                            "Conditions",
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
                              getTag(1, "Excellent", _conditions),
                              getTag(2, "Good", _conditions),
                              getTag(3, "Scarce", _conditions)
                            ],
                          ),
                          SizedBox(height: 24,),
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
                            children: _colorsList.map((e) => getColorBullet(e.id, HexColor(e.hexadecimal), _colors)).toList(),
                          ),
                          SizedBox(height: 24,),
                          Text(
                            "Maximum Price",
                            style: TextStyle(
                                color: Constants.DARK_TEXT_COLOR,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.FONT),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8,),
                        ]
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          inactiveTrackColor: Color(0x66ffa8a8), // Custom Gray Color
                          activeTrackColor: Constants.SECONDARY_COLOR,
                          thumbColor: Constants.SECONDARY_COLOR,
                          overlayColor: Constants.LIGHT_GREY_COLOR,
                          activeTickMarkColor: Colors.white,
                          showValueIndicator: ShowValueIndicator.always,
                          valueIndicatorColor: Constants.SECONDARY_COLOR,
                          trackHeight: 3,
                            valueIndicatorTextStyle: TextStyle(
                                color: Colors.white, letterSpacing: 2.0),
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0, elevation: 0, disabledThumbRadius: 0, pressedElevation: 0)
                        ),
                        child: RangeSlider(
                          values: _maximumPriceRange,
                          min: 0,
                          max: 100,
                          labels: RangeLabels(
                            _maximumPriceRange.start.round().toString(),
                            _maximumPriceRange.end.round().toString(),
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              _maximumPriceRange = values;
                            });
                          },
                        ),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "€0",
                                style: TextStyle(
                                    color: Constants.LIGHT_GREY_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT),
                              ),
                              Text(
                                "€100",
                                style: TextStyle(
                                    color: Constants.LIGHT_GREY_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT),
                              ),
                            ],
                          ),
                          /*SizedBox(height: 32,),
                          Text(
                            "Inspirations",
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
                              getTag("Holiday", false),
                              getTag("Wedding", true),
                              getTag("Wedding", true),
                              getTag("Wedding", true),
                              getTag("Wedding", true)
                            ],
                          ),*/
                          SizedBox(height: 32,),
                          Text(
                            "Availability",
                            style: TextStyle(
                                color: Constants.DARK_TEXT_COLOR,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.FONT),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8,),
                          Text(
                            "From",
                            style: TextStyle(
                                color: Constants.TEXT_COLOR,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.FONT),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
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
                                      hintText: "dd",
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
                              ),
                              SizedBox(width: 8,),
                              Expanded(
                                child: Container(
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
                                      hintText: "mm",
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
                              ),
                              SizedBox(width: 8,),
                              Expanded(
                                child: Container(
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
                                      hintText: "yyyy",
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
                              ),
                            ],
                          ),
                          SizedBox(height: 24,),
                          Text(
                            "To",
                            style: TextStyle(
                                color: Constants.TEXT_COLOR,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.FONT),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
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
                                      hintText: "dd",
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
                              ),
                              SizedBox(width: 8,),
                              Expanded(
                                child: Container(
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
                                      hintText: "mm",
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
                              ),
                              SizedBox(width: 8,),
                              Expanded(
                                child: Container(
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
                                      hintText: "yyyy",
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
                              ),
                            ],
                          ),
                          SizedBox(height: 32,),
                          /*Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Show hand withdrawals",
                                style: TextStyle(
                                    color: Constants.DARK_TEXT_COLOR,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Constants.FONT),
                                textAlign: TextAlign.center,
                              ),
                              CupertinoSwitch(
                                value: _handWithdrawals,
                                activeColor: Constants.SECONDARY_COLOR,
                                onChanged: (bool value) { setState(() { _handWithdrawals = value; }); },
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Show shipping",
                                style: TextStyle(
                                    color: Constants.DARK_TEXT_COLOR,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Constants.FONT),
                                textAlign: TextAlign.center,
                              ),
                              CupertinoSwitch(
                                value: _handWithdrawals,
                                activeColor: Constants.SECONDARY_COLOR,
                                onChanged: (bool value) { setState(() { _handWithdrawals = value; }); },
                              ),
                            ],
                          ),
                          Divider(),*/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Only show bags in your city",
                                style: TextStyle(
                                    color: Constants.DARK_TEXT_COLOR,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Constants.FONT),
                                textAlign: TextAlign.center,
                              ),
                              CupertinoSwitch(
                                value: _handWithdrawals,
                                activeColor: Constants.SECONDARY_COLOR,
                                onChanged: (bool value) { setState(() { _handWithdrawals = value; }); },
                              ),
                            ],
                          ),
                          /*Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Show compulsory insurance",
                                style: TextStyle(
                                    color: Constants.DARK_TEXT_COLOR,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Constants.FONT),
                                textAlign: TextAlign.center,
                              ),
                              CupertinoSwitch(
                                value: _handWithdrawals,
                                activeColor: Constants.SECONDARY_COLOR,
                                onChanged: (bool value) { setState(() { _handWithdrawals = value; }); },
                              ),
                            ],
                          )*/
                        ],
                      ),
                    ),
                    SizedBox(height: 40,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Constants.SECONDARY_COLOR,
                          textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                      ),
                      child: Text('Apply'),
                      onPressed: () {
                        applyFilters();
                      },
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
