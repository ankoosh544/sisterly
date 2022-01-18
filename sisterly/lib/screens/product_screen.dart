import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:sisterly/models/product.dart';
import 'package:sisterly/screens/checkout_screen.dart';
import 'package:sisterly/screens/fullscreen_gallery_screen.dart';
import 'package:sisterly/screens/profile_screen.dart';
import 'package:sisterly/screens/upload_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sisterly/utils/session_data.dart';
import "package:sisterly/utils/utils.dart";
import 'package:sisterly/widgets/stars_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/constants.dart';
import 'chat_screen.dart';

class ProductScreen extends StatefulWidget {
  final Product product;

  const ProductScreen(this.product, {Key? key}) : super(key: key);

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen>  {

  late final PageController _calendarController;
  List<Product> _productsFavorite = [];
  DateTime _focusedDay = DateTime.now().add(Duration(days: 1));

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getProductsFavorite();
    });
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

  contact() {
    var params = {
      "email_user_to": widget.product.owner.email
    };

    ApiManager(context).makePutRequest('/chat/', params, (res) {
      if (res["errors"] != null) {
        ApiManager.showFreeErrorMessage(context, res["errors"].toString());
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChatScreen(code: res["data"]["code"])));
      }
    }, (res) {
      if (res["errors"] != null) {
        ApiManager.showFreeErrorMessage(context, res["errors"].toString());
      }
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
      backgroundColor: Color(0xfff5f5f5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            barrierColor: Colors.black12.withOpacity(0.6), // Background color
                            barrierDismissible: true,
                            builder: (_) => Dialog(
                              backgroundColor: Colors.transparent,
                                insetPadding: EdgeInsets.zero,
                              child: FullscreenGalleryScreen(images: widget.product.images,)
                            ));
                        /*Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => FullscreenGalleryScreen(images: widget.product.images,),
                              fullscreenDialog: true
                            )
                        );*/
                      },
                      child: SizedBox(
                        height: 180,
                        child: PageView(
                          children: [
                            for (var img in widget.product.images)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: CachedNetworkImage(
                                    height: 180, fit: BoxFit.fitHeight,
                                    imageUrl: (img.isNotEmpty ? img : ""),
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => SvgPicture.asset("assets/images/placeholder_product.svg"),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: 16,
                        right: 12,
                        child: isFavorite(widget.product) ? InkWell(
                          child: SizedBox(width: 24, height: 24, child: SvgPicture.asset("assets/images/saved.svg")),
                          onTap: () {
                            setProductFavorite(widget.product, false);
                          },
                        ) : InkWell(
                          child: SizedBox(width: 24, height: 24, child: SvgPicture.asset("assets/images/save.svg")),
                          onTap: () {
                            setProductFavorite(widget.product, true);
                          },
                        )
                    ),
                    Positioned(
                      left: 16,
                      top: 8,
                      child: InkWell(
                        child: Container(padding: const EdgeInsets.all(12), child: SvgPicture.asset("assets/images/back_black.svg")),
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
                          Expanded(
                            child: Column(
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
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                "${Utils.formatCurrency(widget.product.priceOffer)}",
                                style: TextStyle(
                                    color: Constants.PRIMARY_COLOR,
                                    fontSize: 25,
                                    fontFamily: Constants.FONT,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(width: 8,),
                              Text(
                                "${Utils.formatCurrency(widget.product.sellingPrice)}",
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
                          )
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
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) => ProfileScreen(id: widget.product.owner.id)));
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(68.0),
                              child: CachedNetworkImage(
                                width: 68, height: 68, fit: BoxFit.cover,
                                imageUrl: (widget.product.owner.image ?? ""),
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => SvgPicture.asset("assets/images/placeholder.svg"),
                              ),
                            ),
                            SizedBox(width: 12,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pubblicata da " + widget.product.owner.username!.capitalize(),
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
                                    StarsWidget(stars: widget.product.owner.reviewsMedia!.toInt()),
                                    Text(
                                      widget.product.owner.reviewsMedia.toString(),
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
                      getInfoRow("Anni", widget.product.year.toString()),
                      SizedBox(height: 8,),
                      getInfoRow("Misura", widget.product.size.toString()),
                      SizedBox(height: 8,),
                      Divider(height: 30,),
                      SizedBox(height: 8,),
                      Text(
                        "Descrizione",
                        style: TextStyle(
                            color: Constants.TEXT_COLOR,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: Constants.FONT
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        widget.product.description.toString(),
                        style: TextStyle(
                            color: Constants.TEXT_COLOR,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: Constants.FONT
                        ),
                      ),
                      SizedBox(height: 8,),
                      Divider(height: 30,),
                      SizedBox(height: 8,),
                      /*Column(
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
                      SizedBox(height: 8,),*/
                      //Divider(height: 30,),
                      //SizedBox(height: 8,),
                      getInfoRow("Materiale", widget.product.materialName),
                      SizedBox(height: 8,),
                      getInfoRow("Colore", widget.product.colorName.capitalize()),
                      /*SizedBox(height: 8,),
                      getInfoRow("Metal Accessories", "Gold Finish"),
                      SizedBox(height: 8,),
                      getInfoRow("Height", "18cm"),
                      SizedBox(height: 8,),
                      getInfoRow("Width", "26cm"),*/
                      SizedBox(height: 40,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('MMMM yyyy', 'it_IT').format(_focusedDay).capitalize(),
                            style: TextStyle(
                                color: Constants.PRIMARY_COLOR,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.FONT
                            ),
                          ),
                          Wrap(
                            children: [
                              InkWell(
                                onTap: () {
                                  _calendarController.previousPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );
                                },
                                child: RotatedBox(
                                  quarterTurns: 2,
                                    child: SvgPicture.asset("assets/images/arrow_right.svg", width: 10,)
                                ),
                              ),
                              SizedBox(width: 20,),
                              InkWell(
                                onTap: () {
                                  _calendarController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );
                                },
                                child: SvgPicture.asset("assets/images/arrow_right.svg", width: 10,),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 12,),
                      TableCalendar(
                        firstDay: DateTime.now().add(Duration(days: 1)),
                        lastDay: DateTime.utc(2040, 3, 14),
                        focusedDay: _focusedDay,
                        rowHeight: 28,
                        onCalendarCreated: (controller) => _calendarController = controller,
                        onPageChanged: (focusedDay) {
                          debugPrint("focusedDay "+focusedDay.toString());
                          setState(() {
                            _focusedDay = focusedDay;
                          });
                        },
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        daysOfWeekStyle: DaysOfWeekStyle(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black12)),
                          ),
                        ),
                        daysOfWeekHeight: 40,
                        calendarBuilders: CalendarBuilders(
                          dowBuilder: (context, day) {
                            final text = DateFormat.E("it_IT").format(day).capitalize();

                            return Center(
                              child: Text(
                                text,
                                style: TextStyle(color: Color(0xff333333)),
                              ),
                            );
                          },
                          defaultBuilder: (context, day, focusedDay) {
                            debugPrint("defaultBuilder");
                            return Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0x40ffa8a8)
                              ),
                              child: FittedBox(
                                  child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(day.day.toString(), style: TextStyle(color: Colors.black, fontSize: 12),)
                                  )
                              ),
                            );
                          },
                          disabledBuilder: (context, day, focusedDay) {
                            debugPrint("defaultBuilder");
                            return Container(
                              alignment: Alignment.center,
                              child: FittedBox(
                                  child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(day.day.toString(), style: TextStyle(color: Color(0xffcccccc), fontSize: 12),)
                                  )
                              ),
                            );
                          },
                        ),

                        headerVisible: false,
                        locale: "it_IT",
                      ),
                      SizedBox(height: 40,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if(widget.product.owner.id != SessionData().userId) Expanded(
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
                              child: Text("Contatta", textAlign: TextAlign.center,),
                              onPressed: () {
                                contact();
                              },
                            )
                          ),
                          if(widget.product.owner.id != SessionData().userId) SizedBox(width: 12,),
                          if(widget.product.owner.id != SessionData().userId) Expanded(
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
                              child: Text('Prenota'),
                              onPressed: () {
                                if(widget.product.owner.holidayMode!) {
                                  ApiManager.showFreeErrorMessage(context, "L'utente in questione ha attivato la modalità vacanza, non sarà possibile prenotare la borsa fino al suo rientro. Riprova tra qualche giorno");
                                  return;
                                }

                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (BuildContext context) => CheckoutScreen(product: widget.product,)));
                              },
                            ),
                          ),
                          if(widget.product.owner.id == SessionData().userId) Expanded(
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
                              child: Text('Modifica'),
                              onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (BuildContext context) => UploadScreen(editProduct: widget.product,)));
                              },
                            ),
                          ),
                        ],
                      ),
                      if(widget.product.owner.id == SessionData().userId) SizedBox(height: 190,)
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
