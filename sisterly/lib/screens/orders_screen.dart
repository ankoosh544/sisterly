import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:sisterly/models/account.dart';
import 'package:sisterly/models/offer.dart';
import 'package:sisterly/models/product.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sisterly/utils/session_data.dart';
import 'package:sisterly/widgets/stars_widget.dart';
import '../utils/constants.dart';
import "package:sisterly/utils/utils.dart";

enum OrdersScreenMode {
  received, sent
}

class OrdersScreen extends StatefulWidget {

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  OrdersScreenState createState() => OrdersScreenState();
}

class OrdersScreenState extends State<OrdersScreen>  {

  bool _isLoading = false;
  List<Offer> _orders = [];
  OrdersScreenMode _mode = OrdersScreenMode.received;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getOrders();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getOrders() {
    setState(() {
      _isLoading = true;
    });

    ApiManager(context).makeGetRequest(_mode == OrdersScreenMode.received ? "/product/offers" : "/product/cart", {}, (res) {
      // print(res);
      setState(() {
        _isLoading = false;
      });

      _orders = [];

      var data = res["data"];
      if (data != null) {
        for (var prod in data) {
          _orders.add(Offer.fromJson(prod));
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
            Text(
              "Ordine #" + offer.id.toString(),
              style: TextStyle(
                color: Constants.PRIMARY_COLOR,
                fontSize: 18,
                fontFamily: Constants.FONT,
                fontWeight: FontWeight.bold
              ),
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
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: CachedNetworkImage(
                    width: 127,
                    height: 96,
                    fit: BoxFit.contain,
                    imageUrl: SessionData().serverUrl + offer.product.images.first,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
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
                      "${SessionData().currencyFormat.format(offer.product.sellingPrice)} al giorno",
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
            if(_mode == OrdersScreenMode.sent && canPay(offer)) Divider(),
            if(_mode == OrdersScreenMode.sent && canPay(offer)) Row(
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

                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  canPay(Offer offer) {
    switch(offer.state.id) {
      case 2: return true;
      default: return false;
    }
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if(Navigator.of(context).canPop()) InkWell(
                        child: SvgPicture.asset("assets/images/back.svg"),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ) else const SizedBox(
                        width: 24,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Text(
                          "Ordini",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: Constants.FONT),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 20,)
                      /*InkWell(
                        child: SizedBox(width: 17, height: 19, child: SvgPicture.asset("assets/images/menu.svg", width: 17, height: 19, fit: BoxFit.scaleDown,)),
                        onTap: () {

                        },
                      ),*/
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                                  primary: _mode == OrdersScreenMode.sent ? Constants.PRIMARY_COLOR : Colors.white,
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                              ),
                              child: Text('Inviati', style: TextStyle(color: _mode == OrdersScreenMode.sent ? Colors.white : Constants.TEXT_COLOR),),
                              onPressed: () {
                                setState(() {
                                  _mode = OrdersScreenMode.sent;

                                  getOrders();
                                });
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: _mode == OrdersScreenMode.received ? Constants.PRIMARY_COLOR : Colors.white,
                                  elevation: 0,
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                              ),
                              child: Text('Ricevuti', style: TextStyle(color: _mode == OrdersScreenMode.received ? Colors.white : Constants.TEXT_COLOR),),
                              onPressed: () {
                                setState(() {
                                  _mode = OrdersScreenMode.received;

                                  getOrders();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      _isLoading ? Center(child: CircularProgressIndicator()) : _orders.isNotEmpty ? MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _orders.length,
                          itemBuilder: (BuildContext context, int index) {
                            return offerCell(_orders[index]);
                          }
                        ),
                      ) : Center(child: Text("Non ci sono ordini qui")),
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
