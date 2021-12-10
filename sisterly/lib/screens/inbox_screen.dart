import 'package:cached_network_image/cached_network_image.dart';
import 'package:sisterly/models/account.dart';
import 'package:sisterly/models/product.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sisterly/widgets/header_widget.dart';

import '../utils/constants.dart';
import "package:sisterly/utils/utils.dart";

enum InboxScreenMode {
  messages, notifications
}

class InboxScreen extends StatefulWidget {

  const InboxScreen({Key? key}) : super(key: key);

  @override
  InboxScreenState createState() => InboxScreenState();
}

class InboxScreenState extends State<InboxScreen>  {

  bool _isLoading = false;
  List<Product> _conversations = [];
  InboxScreenMode _mode = InboxScreenMode.messages;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getConversations();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getConversations() {
    setState(() {
      _isLoading = true;
    });

    ApiManager(context).makeGetRequest('/chat/', {}, (res) {
      // print(res);
      setState(() {
        _isLoading = false;
      });

      _conversations = [];

      var data = res["data"];
      if (data != null) {
        for (var prod in data) {
          _conversations.add(Product.fromJson(prod));
        }
      }
    }, (res) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget conversationCell(review) {
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
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.asset("assets/images/product.png", width: 50, height: 50, fit: BoxFit.cover,)
                ),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Beatrice Pedrali",
                        style: TextStyle(
                            color: Constants.DARK_TEXT_COLOR,
                            fontSize: 16,
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
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.FONT
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(width: 12,),
                Text(
                  "1 day ago",
                  style: TextStyle(
                      color: Constants.LIGHT_GREY_COLOR,
                      fontSize: 14,
                      fontFamily: Constants.FONT
                  ),
                ),
              ],
            ),
            SizedBox(height: 12,),
            Text(
              "There is now an abundance of readable dummy texts. These are usually used when a text is required purely to fill a space.",
              style: TextStyle(
                  color: Constants.TEXT_COLOR,
                  fontSize: 14,
                  fontFamily: Constants.FONT
              ),
            ),
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
          HeaderWidget(title: "Sisterly Talks"),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)
                  )
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 8),
                      /*Container(
                        padding: const EdgeInsets.*all(4),
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
                                  primary: _mode == InboxScreenMode.messages ? Constants.PRIMARY_COLOR : Colors.white,
                                  textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                              ),
                              child: Text('Messaggi', style: TextStyle(color: _mode == InboxScreenMode.messages ? Colors.white : Constants.TEXT_COLOR),),
                              onPressed: () {
                                setState(() {
                                  _mode = InboxScreenMode.messages;
                                });
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: _mode == InboxScreenMode.notifications ? Constants.PRIMARY_COLOR : Colors.white,
                                  elevation: 0,
                                  textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                              ),
                              child: Text('Notifiche', style: TextStyle(color: _mode == InboxScreenMode.notifications ? Colors.white : Constants.TEXT_COLOR),),
                              onPressed: () {
                                setState(() {
                                  _mode = InboxScreenMode.notifications;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16,),*/
                      Expanded(
                        child: _isLoading ? Center(child: CircularProgressIndicator()) : _conversations.isNotEmpty ? MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            itemCount: _conversations.length,
                            itemBuilder: (BuildContext context, int index) {
                              return conversationCell(_conversations[index]);
                            }
                          ),
                        ) : Text("Non ci sono chat al momento"),
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
