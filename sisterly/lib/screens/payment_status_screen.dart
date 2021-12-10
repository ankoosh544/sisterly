import 'package:sisterly/models/offer.dart';
import 'package:sisterly/screens/home_screen.dart';
import 'package:sisterly/screens/signup_screen.dart';
import 'package:sisterly/screens/tab_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:sisterly/utils/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/constants.dart';

class PaymentStatusScreen extends StatefulWidget {

  final Offer offer;
  final String code;

  const PaymentStatusScreen({Key? key, required this.offer, required this.code}) : super(key: key);

  @override
  PaymentStatusScreenState createState() => PaymentStatusScreenState();
}

class PaymentStatusScreenState extends State<PaymentStatusScreen> {

  String msg = "Verifica pagamento...";
  String icon = "";

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, getStatus());
  }

  getStatus() {
    ApiManager(context).makeGetRequest("/payment/result/" + widget.code, {}, (res) {
      if(res["data"] != null) {
        setState(() {
          icon = "assets/images/success.svg";
          msg = "Pagamento completato";
        });
      } else {
        setState(() {
          msg = res["errors"].toString();
        });
      }

      Future.delayed(Duration(seconds: 5), () {
        getStatus();
      });
    }, (res) {
      ApiManager.showFreeErrorMessage(context, res["errors"].toString());
      /*setState(() {
        _isLoading = false;
      });*/
    });

    //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChoosePaymentScreen(address: _activeAddress!, shipping: _shipping, insurance: _insurance, product: widget.product)));
  }

  next() async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => TabScreen()), (_) => false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.PRIMARY_COLOR,
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white,),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Expanded(
                child: SizedBox(),
              ),
              Text(
                msg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Constants.PRIMARY_COLOR,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              /*const SizedBox(height: 40),
              const Text("Se verrà accettata potrai procedere al pagamento per la conferma",
                  style: TextStyle(
                    color: Constants.TEXT_COLOR,
                    fontSize: 16,
                    fontFamily: Constants.FONT,
                  ),
                textAlign: TextAlign.center,
              ),*/
              const Expanded(
                child: SizedBox(),
              ),
              SvgPicture.asset(icon),
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
                    child: Text('Vai alla home'),
                    onPressed: () {
                      next();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
