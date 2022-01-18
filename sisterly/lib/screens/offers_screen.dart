import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:sisterly/models/account.dart';
import 'package:sisterly/models/offer.dart';
import 'package:sisterly/models/product.dart';
import 'package:sisterly/screens/choose_payment_screen.dart';
import 'package:sisterly/screens/profile_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sisterly/utils/session_data.dart';
import 'package:sisterly/widgets/header_widget.dart';
import 'package:sisterly/widgets/stars_widget.dart';
import '../utils/constants.dart';
import "package:sisterly/utils/utils.dart";

enum OffersScreenMode {
  received, sent
}

class OffersScreen extends StatefulWidget {

  const OffersScreen({Key? key}) : super(key: key);

  @override
  OffersScreenState createState() => OffersScreenState();
}

class OffersScreenState extends State<OffersScreen>  {

  bool _isLoading = false;
  List<Offer> _offers = [];
  OffersScreenMode _mode = OffersScreenMode.sent;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getOffers();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getOffers() {
    setState(() {
      _isLoading = true;
    });

    ApiManager(context).makeGetRequest(_mode == OffersScreenMode.received ? "/product/offers" : "/product/cart", {}, (res) {
      // print(res);
      setState(() {
        _isLoading = false;
      });

      _offers = [];

      var data = res["data"];
      if (data != null) {
        for (var prod in data) {
          var offer = Offer.fromJson(prod);
          if(isOffer(offer)) {
            _offers.add(offer);
          }
        }
      }
    }, (res) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget offerCell(Offer offer) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "Offerta #" + offer.id.toString(),
                    style: TextStyle(
                      color: Constants.PRIMARY_COLOR,
                      fontSize: 18,
                      fontFamily: Constants.FONT,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                if(isDeleteable(offer)) InkWell(
                  onTap: () {
                    delete(offer);
                  },
                    child: SvgPicture.asset("assets/images/cancel.svg", width: 40, height: 40,)
                )
              ],
            ),
            SizedBox(height: 4,),
            Text(
              "dal " + DateFormat("dd MMM yyyy").format(offer.dateStart) + " al " + DateFormat("dd MMM yyyy").format(offer.dateEnd),
              style: TextStyle(
                  color: Constants.LIGHT_GREY_COLOR,
                  fontSize: 14,
                  fontFamily: Constants.FONT
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => ProfileScreen(id: offer.user.id)));
              },
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(68.0),
                    child: CachedNetworkImage(
                      width: 48, height: 48, fit: BoxFit.cover,
                      imageUrl: (offer.user.image ?? ""),
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => SvgPicture.asset("assets/images/placeholder.svg"),
                    ),
                  ),
                  SizedBox(width: 12,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Creata da " + offer.user.firstName!.capitalize() + " " + offer.user.lastName!.substring(0, 1).toUpperCase() + ".",
                        style: TextStyle(
                            color: Constants.DARK_TEXT_COLOR,
                            fontSize: 16,
                            fontFamily: Constants.FONT
                        ),
                      ),
                      SizedBox(height: 4,),
                      /*Text(
                                    "Milano",
                                    style: TextStyle(
                                        color: Constants.LIGHT_TEXT_COLOR,
                                        fontSize: 14,
                                        fontFamily: Constants.FONT
                                    ),
                                  ),*/
                      SizedBox(height: 4,),
                      Wrap(
                        spacing: 3,
                        children: [
                          StarsWidget(stars: offer.user.reviewsMedia!.toInt()),
                          Text(
                            offer.product.owner.reviewsMedia.toString(),
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
            Divider(),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    width: 127,
                    height: 96,
                    fit: BoxFit.contain,
                    imageUrl: offer.product.images.first,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => SvgPicture.asset("assets/images/placeholder_product.svg",),
                  ),
                ),
                SizedBox(width: 8,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.product.model,
                      style: TextStyle(
                          color: Constants.TEXT_COLOR,
                          fontSize: 16,
                          fontFamily: Constants.FONT
                      ),
                    ),
                    SizedBox(height: 4,),
                    Text(
                      offer.product.brandName,
                      style: TextStyle(
                          color: Constants.TEXT_COLOR,
                          fontSize: 16,
                          fontFamily: Constants.FONT
                      ),
                    ),
                    SizedBox(height: 12,),
                    Text(
                      "${Utils.formatCurrency(offer.product.priceOffer)} al giorno",
                      style: TextStyle(
                          color: Constants.PRIMARY_COLOR,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: Constants.FONT
                      ),
                    ),
                  ],
                )
              ],
            ),
            if(_mode == OffersScreenMode.received && canProcess(offer)) Divider(),
            if(_mode == OffersScreenMode.received && canProcess(offer)) Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
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
                    child: Text('Rifiuta'),
                    onPressed: () {
                      reject(offer);
                    },
                  ),
                ),
                SizedBox(width: 16,),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Constants.SECONDARY_COLOR,
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: Text('Accetta'),
                    onPressed: () {
                      accept(offer);
                    },
                  ),
                ),
              ],
            ),
            if(_mode == OffersScreenMode.received && canProcess(offer)) Divider(),
            if(_mode == OffersScreenMode.sent && canPay(offer)) Divider(),
            if(_mode == OffersScreenMode.sent && canPay(offer)) Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Constants.SECONDARY_COLOR,
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: Text('Paga ora'),
                    onPressed: () {
                      payNow(offer);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                getOfferStatusName(offer),
                style: TextStyle(
                    color: Constants.TEXT_COLOR,
                    fontSize: 16,
                    fontFamily: Constants.FONT,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getOfferStatusName(Offer offer) {
    switch(offer.state.id) {
      case 1: return "In attesa di accettazione";
      case 2: return "In attesa di pagamento";
      case 3: return "Pagamento in corso";
      case 4: return "Pagato";
      case 5: return "Preso in prestito";
      case 6: return "Chiuso";
      case 7: return "Rifiutato";
      default: return "";
    }
  }

  isDeleteable(Offer offer) {
    if(_mode != OffersScreenMode.sent) return false;
    switch(offer.state.id) {
      case 1: return true;
      default: return false;
    }
  }

  canProcess(Offer offer) {
    switch(offer.state.id) {
      case 1: return true;
      default: return false;
    }
  }

  canPay(Offer offer) {
    switch(offer.state.id) {
      case 2: return true;
      default: return false;
    }
  }

  isOffer(Offer offer) {
    switch(offer.state.id) {
      case 1: return true;
      case 2: return true;
      case 3: return true;
      case 7: return true;
      default: return false;
    }
  }

  delete(Offer offer) {
    setState(() {
      _isLoading = true;
    });

    ApiManager(context).makeDeleteRequest("/product/order/" + offer.id.toString(), (res) {
      // print(res);
      setState(() {
        _isLoading = false;
      });

      ApiManager.showFreeSuccessMessage(context, "Offerta eliminata!");

      getOffers();
    }, (res) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  reject(Offer offer) {
    setState(() {
      _isLoading = true;
    });

    var params = {
      "order_id": offer.id,
      "result": false
    };

    ApiManager(context).makePostRequest("/product/" + offer.product.id.toString() + "/offer/", params, (res) {
      // print(res);
      setState(() {
        _isLoading = false;
      });

      ApiManager.showFreeSuccessMessage(context, "Offerta rifiutata!");

      getOffers();
    }, (res) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  accept(Offer offer) {
    setState(() {
      _isLoading = true;
    });

    var params = {
      "order_id": offer.id,
      "result": true
    };

    ApiManager(context).makePostRequest("/product/" + offer.product.id.toString() + "/offer/", params, (res) {
      // print(res);
      setState(() {
        _isLoading = false;
      });

      ApiManager.showFreeSuccessMessage(context, "Offerta accettata!\nAttendi che la borrower sister effettui il pagamento");

      getOffers();
    }, (res) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  payNow(Offer offer) {
    setState(() {
      _isLoading = true;
    });

    var params = {
      "insurance": false
    };

    ApiManager(context).makePostRequest("/product/order/" + offer.id.toString() + "/checkout", params, (res) {
      // print(res);
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChoosePaymentScreen(offer: offer)));
    }, (res) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.PRIMARY_COLOR,
      body: Column(
        children: [
          HeaderWidget(title: "Offerte"),
          SizedBox(height: 16,),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 10,
                              blurRadius: 30,
                              offset: Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  primary: _mode == OffersScreenMode.sent ? Constants.PRIMARY_COLOR : Colors.white,
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                              ),
                              child: Text('Inviate', style: TextStyle(color: _mode == OffersScreenMode.sent ? Colors.white : Constants.TEXT_COLOR),),
                              onPressed: () {
                                setState(() {
                                  _mode = OffersScreenMode.sent;

                                  getOffers();
                                });
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: _mode == OffersScreenMode.received ? Constants.PRIMARY_COLOR : Colors.white,
                                  elevation: 0,
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                              ),
                              child: Text('Ricevute', style: TextStyle(color: _mode == OffersScreenMode.received ? Colors.white : Constants.TEXT_COLOR),),
                              onPressed: () {
                                setState(() {
                                  _mode = OffersScreenMode.received;

                                  getOffers();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          child: _isLoading ? Center(child: CircularProgressIndicator()) : _offers.isNotEmpty ? MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _offers.length,
                              itemBuilder: (BuildContext context, int index) {
                                return offerCell(_offers[index]);
                              }
                            ),
                          ) : Center(child: Text("Non ci sono offerte qui")),
                        ),
                      ),
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
