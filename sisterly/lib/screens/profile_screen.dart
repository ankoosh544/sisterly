import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sisterly/models/account.dart';
import 'package:sisterly/models/product.dart';
import 'package:sisterly/screens/product_screen.dart';
import 'package:sisterly/screens/reset_screen.dart';
import 'package:sisterly/screens/signup_screen.dart';
import 'package:sisterly/screens/signup_success_screen.dart';
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

class ProfileScreen extends StatefulWidget {

  final int? id;

  const ProfileScreen({Key? key, this.id}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>  {

  bool _isLoading = false;
  List<Product> _products = [];
  List<Product> _productsFavorite = [];
  Account? _profile;
  bool _viewAll = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getUser();
      getProducts();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getUser() {
    setState(() {
      _isLoading = true;
    });
    ApiManager(context).makeGetRequest(widget.id != null ? '/client/' + widget.id.toString() : '/client/properties', {}, (res) {
      // print(res);
      setState(() {
        _isLoading = false;
        _profile = Account.fromJson(res["data"]);
      });
    }, (res) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  getProducts() {
    setState(() {
      _isLoading = true;
    });

    ApiManager(context).makeGetRequest(widget.id != null ? '/product/byUser/' + widget.id.toString() + '/' : '/product/my/', {}, (res) {
      // print(res);
      setState(() {
        _isLoading = false;
      });

      _products = [];

      var data = res["data"];
      if (data != null) {
        for (var prod in data) {
          _products.add(Product.fromJson(prod));
        }
      }
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

  isFavorite(product) {
    return _productsFavorite.where((element) => element.id == product.id).isNotEmpty;
  }

  getProductsFavorite() {
    ApiManager(context).makeGetRequest('/product/favorite/', {}, (res) {
      _productsFavorite = [];

      var data = res["data"];
      if (data != null) {
        for (var prod in data) {
          _productsFavorite.add(Product.fromJson(prod));
        }
      }

      setState(() {

      });
    }, (res) {

    });
  }

  setProductFavorite(product, add) {
    var params = {
      "product_id": product.id,
      "remove": !add
    };
    ApiManager(context).makePostRequest('/product/favorite/change/', params, (res) {
      getProductsFavorite();
    }, (res) {

    });
  }

  Widget productCell(Product product) {
    return InkWell(
      onTap: () {
         Navigator.of(context).push(
             MaterialPageRoute(builder: (BuildContext context) => ProductScreen(product)));
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 6,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xfff5f5f5),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: CachedNetworkImage(
                    height: 76,
                    imageUrl: (product.images.isNotEmpty ? product.images.first : ""),
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => SvgPicture.asset("assets/images/placeholder_product.svg"),
                  )
                ),
                Positioned(
                  top: 16,
                  right: 16,
                    child: isFavorite(product) ? InkWell(
                      child: SizedBox(width: 16, height: 16, child: SvgPicture.asset("assets/images/saved.svg")),
                      onTap: () {
                        setProductFavorite(product, false);
                      },
                    ) : InkWell(
                      child: SizedBox(width: 16, height: 16, child: SvgPicture.asset("assets/images/save.svg")),
                      onTap: () {
                        setProductFavorite(product, true);
                      },
                    )
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.model,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Constants.TEXT_COLOR,
                      fontFamily: Constants.FONT,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "${Utils.formatCurrency(product.priceOffer)} al giorno",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Constants.PRIMARY_COLOR,
                        fontSize: 18,
                        fontFamily: Constants.FONT,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.PRIMARY_COLOR,
      body: Column(
        children: [
          HeaderWidget(title: "Dettagli Profilo"),
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
                        SizedBox(height: 8),
                        _isLoading ? CircularProgressIndicator() : Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(68.0),
                              child: CachedNetworkImage(
                                width: 68, height: 68, fit: BoxFit.cover,
                                imageUrl: (_profile!.image ?? ""),
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => SvgPicture.asset("assets/images/placeholder.svg"),
                              ),
                            ),
                            SizedBox(width: 12,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getFullName(),
                                  style: TextStyle(
                                      color: Constants.DARK_TEXT_COLOR,
                                      fontSize: 20,
                                      fontFamily: Constants.FONT
                                  ),
                                ),
                                /*SizedBox(height: 6,),
                                Text(
                                  "Milano",
                                  style: TextStyle(
                                      color: Constants.LIGHT_TEXT_COLOR,
                                      fontSize: 15,
                                      fontFamily: Constants.FONT
                                  ),
                                ),*/
                                SizedBox(height: 6,),
                                Wrap(
                                  spacing: 3,
                                  children: [
                                    if(_profile != null) StarsWidget(stars: _profile!.reviewsMedia!.toInt()),
                                    Text(
                                      _profile!.reviewsMedia!.toString(),
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
                        SizedBox(height: 24,),
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/images/italy.svg", width: 22, height: 22,),
                                SizedBox(width: 8,),
                                Text(
                                  "Italiano dal 1996",
                                  style: TextStyle(
                                      color: Constants.LIGHT_TEXT_COLOR,
                                      fontSize: 14,
                                      fontFamily: Constants.FONT
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/images/italy.svg", width: 22, height: 22,),
                                SizedBox(width: 8,),
                                Text(
                                  "Italiano dal 1996",
                                  style: TextStyle(
                                      color: Constants.LIGHT_TEXT_COLOR,
                                      fontSize: 14,
                                      fontFamily: Constants.FONT
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 12,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/images/italy.svg", width: 22, height: 22,),
                                SizedBox(width: 8,),
                                Text(
                                  "SDA Bocconi School of Management",
                                  style: TextStyle(
                                      color: Constants.LIGHT_TEXT_COLOR,
                                      fontSize: 14,
                                      fontFamily: Constants.FONT
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),*/
                        //SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pubblicati da " + getFirstName(),
                              style: TextStyle(
                                  color: Constants.DARK_TEXT_COLOR,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Constants.FONT
                              ),
                            ),
                            if(_products.isNotEmpty) InkWell(
                              child: Text(
                                _viewAll ? "Vedi meno" : "Vedi tutti",
                                style: TextStyle(
                                    color: Constants.SECONDARY_COLOR,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Constants.FONT,
                                  decoration: TextDecoration.underline
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _viewAll = !_viewAll;
                                });
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: _isLoading ? Center(child: CircularProgressIndicator()) : _products.isNotEmpty ? MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.8 / 1,
                                crossAxisCount: 2,
                              ),
                              itemCount: _viewAll ? _products.length : (_products.length > 4 ? 4 : _products.length),
                              itemBuilder: (BuildContext context, int index) {
                                return productCell(_products[index]);
                              }
                            ),
                          ) : Text("Non ci sono prodotti pubblicati da questo utente"),
                        )
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
