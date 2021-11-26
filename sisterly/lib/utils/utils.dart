import 'dart:io';

import 'package:sisterly/widgets/empty_layout.dart';
import 'package:sisterly/widgets/error_layout.dart';
import 'package:sisterly/widgets/progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {

  Utils();

  static capitalize(String s) {
    return s[0].toUpperCase() + s.substring(1);
  }

  static getImagePlaceholder() {
    return const Image(
      fit: BoxFit.cover,
      image: AssetImage("assets/images/placeholder.jpg")
    );
  }

  static getSizedImagePlaceholder(double width, double height) {
    return Image(
      fit: BoxFit.cover,
      image: const AssetImage("assets/images/placeholder.jpg"),
      width: width,
      height: height,
    );
  }

  static generateFutureBuilder(response, { emptyPlaceholderColor, emptyImageName, emptyText: "", bottomEmptyWidget }) {
      debugPrint("Items connection: " + response.connectionState.toString());
      if (response.connectionState == ConnectionState.waiting) {
        debugPrint("Items waiting");
        return CustomProgressIndicator();
      }

      if (response.connectionState == ConnectionState.done && !response.hasData) {
        debugPrint("Items error "+response.toString());
        return ErrorLayout(text: "Si è verificato un errore");
      }

      if (response.connectionState == ConnectionState.done && response.hasData && response.data.length == 0) {
        debugPrint("Items length 0");
        return Center(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: <Widget>[
              EmptyLayout(
                text: emptyText,
                color: emptyPlaceholderColor,
                imageName: emptyImageName,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: bottomEmptyWidget != null ? bottomEmptyWidget : SizedBox(),
              )
            ],
          ),
        );
      }

      debugPrint("Items render");

      return null;
  }

  static bool isValidEmail(String email) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(email);
  }

  static bool isValidName(String value) {
    String pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';

    RegExp regExp = new RegExp(pattern);

    return regExp.hasMatch(value);
  }

  static bool isValidFiscalCode(String fiscalCode) {
    String p = r'^([A-Z]{6}[0-9LMNPQRSTUV]{2}[ABCDEHLMPRST]{1}[0-9LMNPQRSTUV]{2}[A-Z]{1}[0-9LMNPQRSTUV]{3}[A-Z]{1})$|([0-9]{11})$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(fiscalCode);
  }

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static launchBrowserURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  static String prepareTextForCopy(String htmlText) {
    htmlText = htmlText.replaceAll("<br />", "\n");
    htmlText = htmlText.replaceAll("<br>", "\n");
    htmlText = htmlText.replaceAll("<br >", "\n");
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );

    return htmlText.replaceAll(exp, '');
  }

  static bool isIOS() {
    return !kIsWeb && Platform.isIOS;
  }

  static bool isAndroid() {
    return !kIsWeb && Platform.isAndroid;
  }

  static bool isWeb() {
    return kIsWeb;
  }

}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}