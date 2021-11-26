import 'package:cached_network_image/cached_network_image.dart';
import 'package:sisterly/models/product.dart';
import 'package:sisterly/screens/nfc_screen.dart';
import 'package:sisterly/screens/product_screen.dart';
import 'package:sisterly/screens/wishlist_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sisterly/utils/session_data.dart';

import '../utils/constants.dart';
import 'filters_screen.dart';

class SearchScreen extends StatefulWidget {

  const SearchScreen({Key? key}) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen>  {

  List<Product> _products = [];
  List<Product> _productsFavorite = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getProducts();
      getProductsFavorite();

      showFilters();
    });
  }

  showFilters() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => FractionallySizedBox(
            heightFactor: 0.85,
            child: FiltersScreen()
        )
    );
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
                    decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    // child: Image.asset("assets/images/product.png", height: 169,),
                    child: CachedNetworkImage(
                      height: 169,
                      imageUrl: SessionData().serverUrl + product.images[0],
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
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
              SizedBox(height: 16,),
              Text(
                product.model,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Constants.TEXT_COLOR,
                  fontFamily: Constants.FONT,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8,),
              Text(
                "${SessionData().currencyFormat.format(product.sellingPrice)} al giorno",
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
        ),
      ],
    );
  }

  isFavorite(product) {
    return _productsFavorite.where((element) => element.id == product.id).isNotEmpty;
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

  getProductsFavorite() {
    ApiManager(context).makeGetRequest('/product/favorite/', {}, (res) {
      _productsFavorite = [];

      var data = res["data"];
      if (data != null) {
        for (var prod in data) {
          _productsFavorite.add(Product.fromJson(prod));
        }
      }
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
                      InkWell(
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
                      const Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Text(
                          "Prodotti",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: Constants.FONT),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      InkWell(
                        child: Container(
                            width: 42,
                            height: 42,
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                                color: Color(0xff337a9d),
                                borderRadius: BorderRadius.circular(42)
                            ),
                            child: SizedBox(width: 17, height: 19, child: SvgPicture.asset("assets/images/search_white.svg", width: 17, height: 19, fit: BoxFit.scaleDown,))
                        ),
                        onTap: () {
                          showFilters();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16,),
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
                child: _isLoading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      for (var prod in _products) productCell(prod)
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
