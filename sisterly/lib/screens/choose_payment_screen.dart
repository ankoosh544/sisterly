import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sisterly/screens/checkout_confirm_screen.dart';
import 'package:sisterly/utils/constants.dart';

class ChoosePaymentScreen extends StatefulWidget {
  ChoosePaymentScreen({Key? key}) : super(key: key);

  @override
  _ChoosePaymentScreenState createState() => _ChoosePaymentScreenState();
}

class _ChoosePaymentScreenState extends State<ChoosePaymentScreen> {
  String _method = 'credit';
  bool _hasCards = true;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _cardNumber = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _cvv = TextEditingController();
  bool _saveAddress = true;

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                          child: InkWell(
                              child: SizedBox(child: SvgPicture.asset("assets/images/back.svg")),
                              onTap: () {
                                Navigator.of(context).pop();
                              }
                          )
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Text(
                          "Checkout",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: Constants.FONT),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 17)
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
                    children: [
                      SizedBox(height: 25),
                      Text(
                        "Payment method",
                        style: TextStyle(
                            color: Constants.DARK_TEXT_COLOR,
                            fontSize: 18,
                            fontFamily: Constants.FONT,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              horizontalTitleGap: 0,
                              contentPadding: EdgeInsets.all(0),
                              dense: true,
                              title: Text(
                                'Credit card',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: _method == 'credit' ? Constants.SECONDARY_COLOR : Constants.DARK_TEXT_COLOR),
                              ),
                              leading: Radio(
                                  value: 'credit',
                                  groupValue: _method,
                                  activeColor: Constants.SECONDARY_COLOR,
                                  fillColor: MaterialStateColor.resolveWith((states) => _method == 'credit' ? Constants.SECONDARY_COLOR : Constants.DARK_TEXT_COLOR),
                                  onChanged: _handlePaymentMethodSelection
                              ),
                            ),
                            ListTile(
                              horizontalTitleGap: 0,
                              contentPadding: EdgeInsets.all(0),
                              dense: true,
                              title: Text(
                                'PayPal',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: _method == 'paypal' ? Constants.SECONDARY_COLOR : Constants.DARK_TEXT_COLOR),
                              ),
                              leading: Radio(
                                  value: 'paypal',
                                  groupValue: _method,
                                  fillColor: MaterialStateColor.resolveWith((states) => _method == 'paypal' ? Constants.SECONDARY_COLOR : Constants.DARK_TEXT_COLOR),
                                  onChanged: _handlePaymentMethodSelection
                              ),
                            ),
                            ListTile(
                              horizontalTitleGap: 0,
                              contentPadding: EdgeInsets.all(0),
                              dense: true,
                              title: Text(
                                'Apple Pay',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: _method == 'applepay' ? Constants.SECONDARY_COLOR : Constants.DARK_TEXT_COLOR),
                              ),
                              leading: Radio(
                                  value: 'applepay',
                                  groupValue: _method,
                                  fillColor: MaterialStateColor.resolveWith((states) => _method == 'applepay' ? Constants.SECONDARY_COLOR : Constants.DARK_TEXT_COLOR),
                                  onChanged: _handlePaymentMethodSelection
                              ),
                            ),
                          ]
                      ),

                      SizedBox(height: 15),
                      Text(
                        "Card details",
                        style: TextStyle(
                            color: Constants.DARK_TEXT_COLOR,
                            fontSize: 18,
                            fontFamily: Constants.FONT,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      if (!_hasCards) Column(
                          children: [
                            inputField("Name on card", _name),
                            inputField("Card number", _cardNumber),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 200, child: inputField("Expiry date", _date)),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 150),
                                    child: inputField("CVV", _cvv)),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Row(
                                children: [
                                  Text('Save for for future purchases',
                                      style: TextStyle(
                                        color: Constants.TEXT_COLOR,
                                        fontSize: 16,
                                        fontFamily: Constants.FONT,
                                      )
                                  ),
                                  Switch(
                                    value: _saveAddress,
                                    onChanged: (value) => setState(() { _saveAddress = value; }),
                                    activeColor: Constants.SECONDARY_COLOR,
                                  )
                                ]
                            ),
                          ]
                      ),
                      SizedBox(height: 15),
                      if (_hasCards) Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: [
                                    _renderCard(true),
                                    _renderCard(false)
                                  ]
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Constants.LIGHT_GREY_COLOR2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                              ),
                              child: Text('+ Add New',
                                  style: TextStyle(
                                    color: Constants.TEXT_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT,
                                  )
                              ),
                              onPressed: () {

                              },
                            ),
                          ]
                      ),

                      SizedBox(height: 15),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Constants.SECONDARY_COLOR,
                              textStyle: const TextStyle(
                                  fontSize: 16
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                          ),
                          child: Text('Next'),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CheckoutConfirmScreen()));
                          },
                        ),
                      ),
                      SizedBox(height: 35)
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
  
  _handlePaymentMethodSelection(String? method) {
    setState(() {
      _method = method!;
    });
  }


  Widget inputField(String label, TextEditingController controller) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          Text(label,
              style: TextStyle(
                color: Constants.TEXT_COLOR,
                fontSize: 16,
                fontFamily: Constants.FONT,
              )
          ),
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
                hintText: label,
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
              controller: controller,
            ),
          ),
        ]
    );
  }

  Widget _renderCard(bool active) {
    return Container(
      padding: EdgeInsets.all(25),
      margin: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: active ? Constants.SECONDARY_COLOR_LIGHT : Constants.LIGHT_GREY_COLOR2
      ),
      child: IntrinsicHeight(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset("assets/images/visa.svg", width: 40),
                  SizedBox(height: 20),
                  Text('Nome cognome',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: Constants.FONT,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  Text('**** **** **** 1234',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: Constants.FONT
                      )
                  ),
                  SizedBox(height: 20),
                  Text('EXP 04/36',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: Constants.FONT
                      )
                  ),
                ]
              ),
              SizedBox(width: 25),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: SizedBox(width: 17, height: 19, child: SvgPicture.asset("assets/images/menu.svg", width: 17, height: 19, fit: BoxFit.scaleDown, color: Colors.black)),
                      onTap: () {
                      },
                    ),
                    Visibility(
                      visible: active,
                      child: InkWell(
                        child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Constants.PRIMARY_COLOR
                            ),
                            child: SvgPicture.asset("assets/images/check_color.svg", width: 17, height: 19, fit: BoxFit.scaleDown)
                        ),
                      ),
                    )
                  ]
              )
            ]
        ),
      ),
    );
  }
}