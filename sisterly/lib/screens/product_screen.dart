import 'package:cached_network_image/cached_network_image.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sisterly/models/product.dart';
import 'package:sisterly/screens/checkout_screen.dart';
import 'package:sisterly/screens/profile_screen.dart';
import 'package:sisterly/screens/reset_screen.dart';
import 'package:sisterly/screens/signup_screen.dart';
import 'package:sisterly/screens/signup_success_screen.dart';
import 'package:sisterly/screens/verify_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:sisterly/utils/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sisterly/utils/session_data.dart';
import 'package:sisterly/widgets/custom_app_bar.dart';

import '../utils/constants.dart';
import 'login_screen.dart';

class ProductScreen extends StatefulWidget {
  final Product product;

  const ProductScreen(this.product, {Key? key}) : super(key: key);

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen>  {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label + "  :",
          style: TextStyle(
              color: Constants.TEXT_COLOR,
              fontSize: 16,
              fontFamily: Constants.FONT
          ),
        ),
        Text(
          value,
          style: TextStyle(
              color: Constants.DARK_TEXT_COLOR,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: Constants.FONT
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CachedNetworkImage(
                          height: 180, fit: BoxFit.fitHeight,
                          imageUrl: SessionData().serverUrl + widget.product.images[0],
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 24,
                      top: 16,
                      child: InkWell(
                        child: SvgPicture.asset("assets/images/back_black.svg"),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
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
                      SizedBox(height: 16,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.brandName,
                                style: TextStyle(
                                    color: Constants.DARK_TEXT_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                widget.product.model,
                                style: TextStyle(
                                    color: Constants.DARK_TEXT_COLOR,
                                    fontSize: 20,
                                    fontFamily: Constants.FONT,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "${SessionData().currencyFormat.format(widget.product.sellingPrice)} al giorno",
                            style: TextStyle(
                                color: Constants.PRIMARY_COLOR,
                                fontSize: 25,
                                fontFamily: Constants.FONT,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      /*Text(
                        "Mandatory Insurance",
                        style: TextStyle(
                            color: Constants.TEXT_COLOR,
                            fontSize: 16,
                            fontFamily: Constants.FONT
                        ),
                      ),
                      SizedBox(height: 12),*/
                      InkWell(
                        onTap: () {
                          //TODO set user id
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) => ProfileScreen(id: 1,)));
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60.0),
                                child: Image.asset("assets/images/product.png", width: 60, height: 60, fit: BoxFit.cover,)
                            ),
                            SizedBox(width: 12,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Offered by Beatrice P.",
                                  style: TextStyle(
                                      color: Constants.DARK_TEXT_COLOR,
                                      fontSize: 16,
                                      fontFamily: Constants.FONT
                                  ),
                                ),
                                SizedBox(height: 4,),
                                Text(
                                  "Milan",
                                  style: TextStyle(
                                      color: Constants.LIGHT_TEXT_COLOR,
                                      fontSize: 14,
                                      fontFamily: Constants.FONT
                                  ),
                                ),
                                SizedBox(height: 4,),
                                Wrap(
                                  spacing: 3,
                                  children: [
                                    SvgPicture.asset("assets/images/star.svg", width: 10, height: 10,),
                                    SvgPicture.asset("assets/images/star.svg", width: 10, height: 10,),
                                    SvgPicture.asset("assets/images/star.svg", width: 10, height: 10,),
                                    SvgPicture.asset("assets/images/star.svg", width: 10, height: 10,),
                                    SvgPicture.asset("assets/images/star.svg", width: 10, height: 10,),
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
                        ),
                      ),
                      SizedBox(height: 8,),
                      Divider(height: 30,),
                      SizedBox(height: 8,),
                      getInfoRow("Condizioni", widget.product.conditions.toString()),
                      SizedBox(height: 8,),
                      getInfoRow("Year", widget.product.year.toString()),
                      SizedBox(height: 8,),
                      getInfoRow("Taglia", widget.product.size.toString()),
                      SizedBox(height: 8,),
                      Divider(height: 30,),
                      SizedBox(height: 8,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "• Cross body bag in leather with woven pattern",
                            style: TextStyle(
                                color: Constants.TEXT_COLOR,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.FONT
                            ),
                          ),
                          SizedBox(height: 12,),
                          Text(
                            "• Single inside pocket with zip",
                            style: TextStyle(
                                color: Constants.TEXT_COLOR,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.FONT
                            ),
                          ),
                          SizedBox(height: 12,),
                          Text(
                            "• Metal closure",
                            style: TextStyle(
                                color: Constants.TEXT_COLOR,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.FONT
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8,),
                      Divider(height: 30,),
                      SizedBox(height: 8,),
                      getInfoRow("Material", widget.product.materialName),
                      SizedBox(height: 8,),
                      getInfoRow("Color", widget.product.colorName),
                      /*SizedBox(height: 8,),
                      getInfoRow("Metal Accessories", "Gold Finish"),
                      SizedBox(height: 8,),
                      getInfoRow("Height", "18cm"),
                      SizedBox(height: 8,),
                      getInfoRow("Width", "26cm"),*/
                      SizedBox(height: 24,),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  primary: Constants.PRIMARY_COLOR,
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                  side: const BorderSide(color: Constants.PRIMARY_COLOR, width: 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  )
                              ),
                              child: Text('Book'),
                              onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (BuildContext context) => CheckoutScreen()));
                              },
                            ),
                          ),
                          SizedBox(width: 12,),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Constants.SECONDARY_COLOR,
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                              ),
                              child: Text('Wishlist'),
                              onPressed: () {

                              },
                            ),
                          ),
                        ],
                      )
                    ],
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
