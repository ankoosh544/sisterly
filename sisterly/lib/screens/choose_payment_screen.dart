import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sisterly/models/address.dart';
import 'package:sisterly/models/credit_card.dart';
import 'package:sisterly/models/offer.dart';
import 'package:sisterly/screens/payment_status_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';

class ChoosePaymentScreen extends StatefulWidget {

  final Offer offer;

  ChoosePaymentScreen({Key? key, required this.offer}) : super(key: key);

  @override
  _ChoosePaymentScreenState createState() => _ChoosePaymentScreenState();
}

class _ChoosePaymentScreenState extends State<ChoosePaymentScreen> {
  String _method = 'credit';
  bool _hasCards = true;
  final TextEditingController _cardNumber = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _cvv = TextEditingController();
  bool _saveCard = true;
  List<CreditCard> _cards = [];
  CreditCard? _activeCard;
  bool _addNewCard = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getCards(null);
    });
  }

  getCards(Function? callback) {
    ApiManager(context).makeGetRequest('/client/cards', {}, (response) {
      _activeCard = null;
      _cards = [];
      if (response["data"] != null) {
        for (var card in response["data"]) {
          if (card["active"] && _activeCard == null) {
            _activeCard = CreditCard.fromJson(card);
          } else if(card["active"]) {
            _cards.add(CreditCard.fromJson(card));
          }
        }

        if (_cards.isNotEmpty || _activeCard != null) {
          setState(() {
            _hasCards = true;
            _addNewCard = false;
          });
        }

        setState(() {

        });

        if(callback != null) callback();
      }
    }, (response) {});
  }

  saveCard() {
    if (_date.text.isNotEmpty && _cardNumber.text.isNotEmpty && _cvv.text.isNotEmpty) {
      ApiManager(context).makePutRequest('/client/cards', {
        "card_number": _cardNumber.text,
        "expiration_date": _date.text,
        "cvx": _cvv.text,
      }, (res) {
        debugPrint("create card success");
        getCards(null);
      }, (res) {
        ApiManager.showFreeErrorMessage(context, "Carta non valida");
      });
    }
  }

  _setActiveCard(CreditCard card, bool active) async {
    try {
      card.active = active;
      await ApiManager(context).makePostRequest('/client/cards', card, (res) {}, (res) {});

      getCards(null);
    } catch(e) {
      //
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
            child: Container(
              padding: const EdgeInsets.only(top: 4),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25),
                      Text(
                        "Metodo di pagamento",
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
                                'Carta di credito',
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
                            /*ListTile(
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
                            ),*/
                          ]
                      ),

                      SizedBox(height: 15),
                      Text(
                        "Dettagli carta",
                        style: TextStyle(
                            color: Constants.DARK_TEXT_COLOR,
                            fontSize: 18,
                            fontFamily: Constants.FONT,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      if (!_hasCards || _addNewCard) Column(
                          children: [
                            //inputField("Nome sulla carta", _name),
                            inputField("Numero carta", _cardNumber),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width / 2.1, child: inputField("Scadenza", _date)),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 150),
                                    child: inputField("CVV", _cvv)),
                              ],
                            ),
                            /*const SizedBox(height: 25),
                            Row(
                                children: [
                                  Text('Salva per acquisti futuri',
                                      style: TextStyle(
                                        color: Constants.TEXT_COLOR,
                                        fontSize: 16,
                                        fontFamily: Constants.FONT,
                                      )
                                  ),
                                  Switch(
                                    value: _saveCard,
                                    onChanged: (value) => setState(() { _saveCard = value; }),
                                    activeColor: Constants.SECONDARY_COLOR,
                                  )
                                ]
                            ),*/
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
                                    if (_activeCard != null) _renderCard(_activeCard!),
                                    for (var a in _cards) _renderCard(a)
                                  ]
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Constants.LIGHT_GREY_COLOR2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                              ),
                              child: Text('+ Nuova',
                                  style: TextStyle(
                                    color: Constants.TEXT_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT,
                                  )
                              ),
                              onPressed: () {
                                setState(() {
                                  _addNewCard = true;
                                });
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
                          child: Text('Avanti'),
                          onPressed: () async {
                            if (!_hasCards || (_saveCard && _addNewCard)) {
                              await saveCard();
                              getCards(() {
                                next();
                              });
                            } else {
                              next();
                            }
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

  next() {
    if(_activeCard == null) return;

    var params = {
      "id": _activeCard!.id.toString(),
      "is_card": true
    };

    ApiManager(context).makePutRequest("/payment/make/" + widget.offer.id.toString(), params, (res) {
      if(res["data"] != null && res["data"]["code"] != null) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => PaymentStatusScreen(offer: widget.offer, code: res["data"]["code"])));
      } else {
        ApiManager.showFreeErrorMessage(context, "Pagamento fallito");
      }
    }, (res) {
      ApiManager.showFreeErrorMessage(context, res["errors"].toString());
      /*setState(() {
        _isLoading = false;
      });*/
    });

    //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChoosePaymentScreen(address: _activeAddress!, shipping: _shipping, insurance: _insurance, product: widget.product)));
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

  Widget _renderCard(CreditCard card) {
    List<String> menu = [];
    if (card.active) {
      menu = ['Disattiva'];
    } else {
      menu = ['Attiva'];
    }

    return Container(
      padding: EdgeInsets.all(25),
      margin: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: card.active ? Constants.SECONDARY_COLOR_LIGHT : Constants.LIGHT_GREY_COLOR2
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
                  /*Text('Nome cognome',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: Constants.FONT,
                          fontWeight: FontWeight.bold
                      )
                  ),*/
                  Text(card.alias.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: Constants.FONT
                      )
                  ),
                  SizedBox(height: 20),
                  Text('EXP ' + card.expirationDate.substring(0, 2) + "/" + card.expirationDate.substring(2, 4),
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
                    PopupMenuButton<String>(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.more_vert,
                        ),
                      ),
                      padding: EdgeInsets.all(0),
                      onSelected: (val) {
                        switch (val) {
                          case 'Attiva':
                            _setActiveCard(card, true);
                            break;
                          case 'Disattiva':
                            _setActiveCard(card, false);
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return menu.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                    Visibility(
                      visible: card.active,
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