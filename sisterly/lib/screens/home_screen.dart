import 'package:cached_network_image/cached_network_image.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sisterly/models/product.dart';
import 'package:sisterly/screens/nfc_screen.dart';
import 'package:sisterly/screens/product_screen.dart';
import 'package:sisterly/screens/wishlist_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sisterly/utils/session_data.dart';
import 'package:sisterly/utils/utils.dart';
import 'package:sisterly/widgets/header_widget.dart';

import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>  {

  List<Product> _products = [];
  List<Product> _productsFavorite = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      initPush();
      getProducts();
      getProductsFavorite();
    });
  }

  initPush() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId("525f16c7-1961-47ca-841d-bf2f96c2b002");

    OneSignal.shared.setExternalUserId(SessionData().userId.toString());

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });

    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;

    debugPrint("onesignal id "+osUserID.toString());

    var params = {
      "player_id": osUserID.toString()
    };
    ApiManager(context).makePostRequest('/client/player_id', params, (res) {

    }, (res) {

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget productCell(Product product) {
    return Column(
      children: [
        SizedBox(height: 20),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => ProductScreen(product)));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    // child: Image.asset("assets/images/product.png", height: 169,),
                    child: CachedNetworkImage(
                      height: 169,
                      imageUrl: (product.images.isNotEmpty ? product.images.first.image : ""),
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => SvgPicture.asset("assets/images/placeholder_product.svg"),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                      child: isFavorite(product) ? InkWell(
                        child: SizedBox(width: 18, height: 18, child: SvgPicture.asset("assets/images/saved.svg")),
                        onTap: () {
                          setProductFavorite(product, false);
                        },
                      ) : InkWell(
                        child: SizedBox(width: 18, height: 18, child: SvgPicture.asset("assets/images/save.svg")),
                        onTap: () {
                          setProductFavorite(product, true);
                        },
                      )
                  )
                ],
              ),
              SizedBox(height: 16,),
              Text(
                product.model.toString() + " - " + product.brandName.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Constants.TEXT_COLOR,
                  fontFamily: Constants.FONT,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  SizedBox(width: 8,),
                  Text(
                    "${Utils.formatCurrency(product.sellingPrice)}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Constants.PRIMARY_COLOR,
                      fontSize: 18,
                      fontFamily: Constants.FONT,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  getProducts() {
    setState(() {
      _isLoading = true;
    });
    ApiManager(context).makeGetRequest('/product/', {}, (res) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.PRIMARY_COLOR,
      body: Column(
        children: [
          HeaderWidget(
              title: "Home",
            leftWidget: InkWell(
              child: Container(
                  width: 42,
                  height: 42,
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      color: Color(0xff337a9d),
                      borderRadius: BorderRadius.circular(42)
                  ),
                  child: SizedBox(width: 70, height: 40, child: SvgPicture.asset("assets/images/saved_white.svg", width: 19, height: 19, fit: BoxFit.scaleDown))
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => WishlistScreen()));
              },
            ),
            rightWidget: InkWell(
              child: Container(
                  width: 42,
                  height: 42,
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      color: Color(0xff337a9d),
                      borderRadius: BorderRadius.circular(42)
                  ),
                  child: SizedBox(width: 17, height: 19, child: SvgPicture.asset("assets/images/nfc.svg", width: 17, height: 19, fit: BoxFit.scaleDown,))
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => NfcScreen()));
              },
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _isLoading ? Center(child: CircularProgressIndicator()) : RefreshIndicator(
                  onRefresh: () async {
                    getProducts();
                    getProductsFavorite();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: _products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return productCell(_products[index]);
                    }
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
