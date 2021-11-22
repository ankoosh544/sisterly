import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sisterly/screens/choose_payment_screen.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:sisterly/widgets/checkout/checkout_product_card.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _shipping = 'shipment';
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _zip = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  bool _saveAddress = true;
  bool _insurance = true;
  bool _hasAddress = true;

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
                      CheckoutProductCard(),

                      SizedBox(height: 25),
                      profileBanner(),

                      SizedBox(height: 25),
                      Text(
                        "How do you want to receive your bag?",
                        style: TextStyle(
                            color: Constants.DARK_TEXT_COLOR,
                            fontSize: 18,
                            fontFamily: Constants.FONT,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListTile(
                              horizontalTitleGap: 0,
                              contentPadding: EdgeInsets.all(0),
                              title: Text(
                                'Shipment',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: _shipping == 'shipment' ? Constants.SECONDARY_COLOR : Constants.DARK_TEXT_COLOR),
                              ),
                              leading: Radio(
                                value: 'shipment',
                                groupValue: _shipping,
                                activeColor: Constants.SECONDARY_COLOR,
                                  fillColor: MaterialStateColor.resolveWith((states) => _shipping == 'shipment' ? Constants.SECONDARY_COLOR : Constants.DARK_TEXT_COLOR),
                                onChanged: _handleShipmentRadioChange
                              ),
                            ),
                          ),
                          Flexible(
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0),
                              horizontalTitleGap: 0,
                              title: Text(
                                'Withdraw',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: _shipping == 'withdraw' ? Constants.SECONDARY_COLOR : Constants.DARK_TEXT_COLOR),
                              ),
                              leading: Radio(
                                value: 'withdraw',
                                groupValue: _shipping,
                                fillColor: MaterialStateColor.resolveWith((states) => _shipping == 'withdraw' ? Constants.SECONDARY_COLOR : Constants.DARK_TEXT_COLOR),
                                onChanged: _handleShipmentRadioChange
                              ),
                            ),
                          ),
                        ]
                      ),

                      SizedBox(height: 15),
                      Text(
                        "Which address do you want to receive?",
                        style: TextStyle(
                            color: Constants.DARK_TEXT_COLOR,
                            fontSize: 18,
                            fontFamily: Constants.FONT,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      if (!_hasAddress) Column(
                        children: [
                          inputField("First name", _firstName),
                          inputField("Last name", _lastName),
                          inputField("Address", _address),
                          inputField("City", _city),
                          inputField("Zip code", _zip),
                          inputField("State", _state),
                          inputField("Email", _email),
                          inputField("Phone number", _phone),
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
                      if (_hasAddress) Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _renderAddress(true),
                                _renderAddress(false)
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

                      SizedBox(height: 25),
                      Text(
                        "Do you want to add insurance coverage for this bag?",
                        style: TextStyle(
                            color: Constants.DARK_TEXT_COLOR,
                            fontSize: 18,
                            fontFamily: Constants.FONT,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() {
                              _insurance = true;
                            }),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: _insurance ? Constants.SECONDARY_COLOR_LIGHT : Constants.LIGHT_GREY_COLOR2
                              ),
                              child: Text('Yes (+ € 6.00)',
                                  style: TextStyle(
                                    color: _insurance ? Colors.black : Constants.TEXT_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT,
                                  )
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() {
                              _insurance = false;
                            }),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              margin: EdgeInsets.only(left: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: !_insurance ? Constants.SECONDARY_COLOR_LIGHT : Constants.LIGHT_GREY_COLOR2
                              ),
                              child: Text('No',
                                  style: TextStyle(
                                    color: !_insurance ? Colors.black : Constants.TEXT_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT,
                                  )
                              ),
                            ),
                          )
                        ]
                      ),

                      SizedBox(height: 35),
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
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChoosePaymentScreen()));
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

  void _handleShipmentRadioChange(String? value) {
    setState(() {
      _shipping = value!;
    });
  }

  Widget profileBanner() {
    return Row(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(68.0),
            child: Image.asset("assets/images/product.png", width: 68, height: 68, fit: BoxFit.cover,)
        ),
        SizedBox(width: 12,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Beatrice Pedrali",
              style: TextStyle(
                  color: Constants.DARK_TEXT_COLOR,
                  fontSize: 20,
                  fontFamily: Constants.FONT
              ),
            ),
            SizedBox(height: 6,),
            Text(
              "Milan",
              style: TextStyle(
                  color: Constants.LIGHT_TEXT_COLOR,
                  fontSize: 15,
                  fontFamily: Constants.FONT
              ),
            ),
            SizedBox(height: 6,),
            Wrap(
              spacing: 3,
              children: [
                SvgPicture.asset("assets/images/star.svg", width: 11, height: 11,),
                SvgPicture.asset("assets/images/star.svg", width: 11, height: 11,),
                SvgPicture.asset("assets/images/star.svg", width: 11, height: 11,),
                SvgPicture.asset("assets/images/star.svg", width: 11, height: 11,),
                SvgPicture.asset("assets/images/star.svg", width: 11, height: 11,),
                Text(
                  "5.0",
                  style: TextStyle(
                      color: Constants.DARK_TEXT_COLOR,
                      fontSize: 14,
                      fontFamily: Constants.FONT
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
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

  Widget _renderAddress(bool active) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Nome cognome',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: Constants.FONT,
                      fontWeight: FontWeight.bold
                    )
                ),
                Text('31110 Via Cxdqwdqw',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Constants.FONT
                    )
                ),
                Text('Treviso, TV',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Constants.FONT
                    )
                ),
                Text('Veneto, Italia',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Constants.FONT
                    )
                ),
                SizedBox(height: 10),
                Text('email@email.email',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Constants.FONT
                    )
                ),
                Text('+39 3023920192',
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