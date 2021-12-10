import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sisterly/utils/constants.dart';

class HeaderWidget extends StatelessWidget {

  final String title;
  final Widget? leftWidget;
  final Widget? rightWidget;

  const HeaderWidget({
    Key? key,
    required this.title,
    this.leftWidget,
    this.rightWidget}
    ) : super(key: key);

  getLeftWidget(BuildContext context) {
    if(leftWidget == null) {
      if(Navigator.of(context).canPop()) {
        return InkWell(
          child: Container(padding: const EdgeInsets.all(12), child: SvgPicture.asset("assets/images/back.svg")),
          onTap: () {
            Navigator.of(context).pop();
          },
        );
      } else {
        return SizedBox();
      }
    }

    return leftWidget;
  }

  getRightWidget(BuildContext context) {
    if(rightWidget != null) {
      return rightWidget;
    }

    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          Align(
            child: SvgPicture.asset("assets/images/wave_blue.svg"),
            alignment: Alignment.topRight,
          ),
          Align(
            alignment: Alignment.center,
            child: SafeArea(
              bottom: false,
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: Constants.FONT),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getLeftWidget(context),
                  getRightWidget(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
