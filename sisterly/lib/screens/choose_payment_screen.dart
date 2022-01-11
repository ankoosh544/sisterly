import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sisterly/models/address.dart';
import 'package:sisterly/models/credit_card.dart';
import 'package:sisterly/models/document.dart';
import 'package:sisterly/models/offer.dart';
import 'package:sisterly/screens/payment_status_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';

import 'documents_screen.dart';

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
  List<Document> _documents = [];
  bool _isLoadingDocuments = true;

  @override
  void initState() {
    super.initState();

    _cardNumber.addListener(() {
      debugPrint("cardnumber change "+_cardNumber.text.toString());
      //_cardNumber.text = _cardNumber.text.toString().replaceAll(" ", "");
    });

    Future.delayed(Duration.zero, () {
      getDocuments();
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
    }, (response) {
      ApiManager.showFreeErrorMessage(context, "Errore durante il recupero delle carte di credito, riprova più tardi e se il problema persiste contatta l'assistenza");
    });
  }

  saveCard(callback) {
    if (_date.text.isNotEmpty && _cardNumber.text.isNotEmpty && _cvv.text.isNotEmpty) {
      ApiManager(context).makePutRequest('/client/cards', {
        "card_number": _cardNumber.text,
        "expiration_date": _date.text.replaceAll("/", ""),
        "cvx": _cvv.text,
      }, (res) {
        debugPrint("create card success");
        getCards(null);
        if(callback != null) callback();
      }, (res) {
        ApiManager.showFreeErrorMessage(context, "Carta non valida");
        if(callback != null) callback();
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

  getDocuments() {
    setState(() {
      _isLoadingDocuments = true;
    });
    ApiManager(context).makeGetRequest('/payment/kyc', {}, (res) {
      _documents = [];

      var data = res["data"];
      if (data != null) {
        for (var doc in data) {
          _documents.add(Document.fromJson(doc));
        }
      }

      setState(() {
        _isLoadingDocuments = false;
      });
    }, (res) {
      setState(() {
        _isLoadingDocuments = false;
      });
    });
  }

  onExpireChanged(value) {
    setState(() {
      value = value.replaceAll(RegExp(r"\D"), "");
      switch (value.length) {
        case 0:
          _date.text = "MM/AA";
          _date.selection = TextSelection.collapsed(offset: 0);
          break;
        case 1:
          _date.text = "${value}M/AA";
          _date.selection = TextSelection.collapsed(offset: 1);
          break;
        case 2:
          _date.text = "$value/AA";
          _date.selection = TextSelection.collapsed(offset: 2);
          break;
        case 3:
          _date.text =
          "${value.substring(0, 2)}/${value.substring(2)}Y";
          _date.selection = TextSelection.collapsed(offset: 4);
          break;
        case 4:
          _date.text =
          "${value.substring(0, 2)}/${value.substring(2, 4)}";
          _date.selection = TextSelection.collapsed(offset: 5);
          break;
      }
      if (value.length > 4) {
        _date.text =
        "${value.substring(0, 2)}/${value.substring(2, 4)}";
        _date.selection = TextSelection.collapsed(offset: 5);
      }
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
                            inputField("Numero carta", _cardNumber, TextInputType.number, 16, (value) { }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width / 2.1, child: inputField("Scadenza", _date, TextInputType.number, 4, onExpireChanged)),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 150),
                                    child: inputField("CVV", _cvv, TextInputType.number, 3, (value) { })),
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
                      if(_documents.isEmpty) SizedBox(height: 15),
                      if(_documents.isEmpty && !_isLoadingDocuments) InkWell(
                        onTap: () async {
                          await Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) => DocumentsScreen()));

                          getDocuments();
                        },
                        child: Card(
                          color: Color(0x88FF8A80),
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: const [
                                Text('Carica un documento d\'identità per poter procedere con il pagamento',
                                    style: TextStyle(
                                      color: Constants.TEXT_COLOR,
                                      fontSize: 16,
                                      fontFamily: Constants.FONT,
                                    )
                                ),
                                SizedBox(height: 8),
                                Text('Clicca qui',
                                    style: TextStyle(
                                      color: Constants.TEXT_COLOR,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: Constants.FONT,
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Center(
                        child: Opacity(
                          opacity: _documents.isEmpty ? 0.3 : 1,
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
                              if(_documents.isEmpty) {
                                return;
                              }

                              if(!_hasCards && !_addNewCard) {
                                return;
                              }

                              if (!_hasCards || (_saveCard && _addNewCard)) {
                                debugPrint("save card");
                                saveCard(() {
                                  getCards(() {
                                    next();
                                  });
                                });
                              } else {
                                debugPrint("next");
                                next();
                              }
                            },
                          ),
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
      "is_card": true,
      "JavaEnabled": false,
      "Language": "it",
      "ColorDepth": 1,
      "JavascriptEnabled": true,
      "ScreenHeight": MediaQuery.of(context).size.height,
      "ScreenWidth": MediaQuery.of(context).size.width,
      "TimeZoneOffset": "UTC+2",
      "UserAgent": "Mobile",
      "ip_address": "192.168.1.1"
    };

    ApiManager(context).makePutRequest("/payment/make/" + widget.offer.id.toString(), params, (res) {
      if(res["data"] != null && res["data"]["result"] != null) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => PaymentStatusScreen(offer: widget.offer, code: "")));
      } else {
        ApiManager.showFreeErrorMessage(context, "Pagamento fallito");
      }
    }, (res) {
      if(res != null && res["errors"] != null) {
        ApiManager.showFreeErrorMessage(context, res["errors"].toString());
      } else {
        ApiManager.showFreeErrorMessage(context, "Errore durante il pagamento, riprova più tardi e se il problema persiste contatta l'assistenza");
      }
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


  Widget inputField(String label, TextEditingController controller, TextInputType keyboardType, int maxLength, Function onChanged) {
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
              onChanged: (value) {
                onChanged(value);
              },
              keyboardType: keyboardType,
              cursorColor: Constants.PRIMARY_COLOR,
              style: const TextStyle(
                fontSize: 16,
                color: Constants.FORM_TEXT,
              ),
              decoration: InputDecoration(
                counterText: "",
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
              maxLength: maxLength,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
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