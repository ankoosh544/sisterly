import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sisterly/models/address.dart';
import 'package:sisterly/screens/choose_payment_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:sisterly/widgets/checkout/checkout_product_card.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _shipping = 'shipment';
  final TextEditingController _name = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _address2 = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _zip = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _country = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  bool _saveAddress = true;
  bool _insurance = true;
  bool _hasAddress = false;
  List<Address> _addresses = [];
  Address? _activeAddress;
  bool _addNewAddress = false;
  bool _editAddress = false;
  Address? _addressToEdit;

  @override
  void initState() {
    super.initState();
    getAddresses();
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
            child: SingleChildScrollView(
              child: Container(
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
                    children: [
                      CheckoutProductCard(),

                      SizedBox(height: 25),
                      profileBanner(),

                      SizedBox(height: 25),
                      Text(
                        "How do you want to receive your bag?",
                        style: TextStyle(
                            color: Constants.DARK_TEXT_COLOR,
                            fontSize: 18,
                            fontFamily: Constants.FONT,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListTile(
                              horizontalTitleGap: 0,
                              contentPadding: EdgeInsets.all(0),
                              title: Text(
                                'Shipment',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: _shipping == 'shipment' ? Constants.SECONDARY_COLOR : Constants.DARK_TEXT_COLOR),
                              ),
                              leading: Radio(
                                value: 'shipment',
                                groupValue: _shipping,
                                activeColor: Constants.SECONDARY_COLOR,
                                  fillColor: MaterialStateColor.resolveWith((states) => _shipping == 'shipment' ? Constants.SECONDARY_COLOR : Constants.DARK_TEXT_COLOR),
                                onChanged: _handleShipmentRadioChange
                              ),
                            ),
                          ),
                          Flexible(
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0),
                              horizontalTitleGap: 0,
                              title: Text(
                                'Withdraw',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: _shipping == 'withdraw' ? Constants.SECONDARY_COLOR : Constants.DARK_TEXT_COLOR),
                              ),
                              leading: Radio(
                                value: 'withdraw',
                                groupValue: _shipping,
                                fillColor: MaterialStateColor.resolveWith((states) => _shipping == 'withdraw' ? Constants.SECONDARY_COLOR : Constants.DARK_TEXT_COLOR),
                                onChanged: _handleShipmentRadioChange
                              ),
                            ),
                          ),
                        ]
                      ),

                      SizedBox(height: 15),
                      Text(
                        "Which address do you want to receive?",
                        style: TextStyle(
                            color: Constants.DARK_TEXT_COLOR,
                            fontSize: 18,
                            fontFamily: Constants.FONT,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 15),
                      if (!_hasAddress || _addNewAddress || _editAddress) Column(
                        children: [
                          inputField("Name", _name),
                          inputField("Address", _address),
                          inputField("Address 2", _address2),
                          inputField("City", _city),
                          inputField("Zip code", _zip),
                          inputField("State/Province", _state),
                          inputField("Country", _country),
                          inputField("Email", _email),
                          inputField("Phone number", _phone),
                          const SizedBox(height: 25),
                          if (!_editAddress) Row(
                              children: [
                                Text('Save for for future purchases',
                                    style: TextStyle(
                                      color: Constants.TEXT_COLOR,
                                      fontSize: 16,
                                      fontFamily: Constants.FONT,
                                    )
                                ),
                                Switch(
                                  value: _saveAddress,
                                  onChanged: (value) => setState(() { _saveAddress = value; }),
                                  activeColor: Constants.SECONDARY_COLOR,
                                )
                              ]
                          ),
                        ]
                      ),
                      if (_editAddress) ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Constants.GREEN_SAVE,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                        ),
                        child: Text('Save',
                            style: TextStyle(
                              color: Constants.TEXT_COLOR,
                              fontSize: 16,
                              fontFamily: Constants.FONT,
                            )
                        ),
                        onPressed: () {
                          _updateAddress();
                          setState(() {
                            _editAddress = false;
                            _addressToEdit = null;
                          });
                        },
                      ),
                      if (_hasAddress && !_addNewAddress && !_editAddress) Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                if (_activeAddress != null) _renderAddress(_activeAddress!),
                                for (var a in _addresses) _renderAddress(a)
                              ]
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Constants.LIGHT_GREY_COLOR2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                            ),
                            child: Text('+ Add New',
                              style: TextStyle(
                                color: Constants.TEXT_COLOR,
                                fontSize: 16,
                                fontFamily: Constants.FONT,
                              )
                            ),
                            onPressed: () {
                              setState(() {
                                _addNewAddress = true;
                              });
                            },
                          ),
                        ]
                      ),
                      SizedBox(height: 25),
                      Text(
                        "Do you want to add insurance coverage for this bag?",
                        style: TextStyle(
                            color: Constants.DARK_TEXT_COLOR,
                            fontSize: 18,
                            fontFamily: Constants.FONT,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() {
                              _insurance = true;
                            }),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: _insurance ? Constants.SECONDARY_COLOR_LIGHT : Constants.LIGHT_GREY_COLOR2
                              ),
                              child: Text('Yes (+ € 6.00)',
                                  style: TextStyle(
                                    color: _insurance ? Colors.black : Constants.TEXT_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT,
                                  )
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() {
                              _insurance = false;
                            }),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              margin: EdgeInsets.only(left: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: !_insurance ? Constants.SECONDARY_COLOR_LIGHT : Constants.LIGHT_GREY_COLOR2
                              ),
                              child: Text('No',
                                  style: TextStyle(
                                    color: !_insurance ? Colors.black : Constants.TEXT_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT,
                                  )
                              ),
                            ),
                          )
                        ]
                      ),

                      SizedBox(height: 35),
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
                          child: Text('Next'),
                          onPressed: () {
                            if (!_hasAddress || (_saveAddress && _addNewAddress && !_editAddress)) {
                              saveAddress();
                            }
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChoosePaymentScreen())).then((value) => setState(() {
                              getAddresses();
                            }));
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

  void _handleShipmentRadioChange(String? value) {
    setState(() {
      _shipping = value!;
    });
  }

  Widget profileBanner() {
    return Row(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(68.0),
            child: Image.asset("assets/images/product.png", width: 68, height: 68, fit: BoxFit.cover,)
        ),
        SizedBox(width: 12,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Beatrice Pedrali",
              style: TextStyle(
                  color: Constants.DARK_TEXT_COLOR,
                  fontSize: 20,
                  fontFamily: Constants.FONT
              ),
            ),
            SizedBox(height: 6,),
            Text(
              "Milan",
              style: TextStyle(
                  color: Constants.LIGHT_TEXT_COLOR,
                  fontSize: 15,
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
                      fontFamily: Constants.FONT
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
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

  Widget _renderAddress(Address address) {
    List<String> menu = ['Delete', 'Set active', 'Edit'];
    if (address.active) {
      menu = ['Edit'];
    }

    return Container(
      padding: EdgeInsets.all(25),
      margin: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: address.active ? Constants.SECONDARY_COLOR_LIGHT : Constants.LIGHT_GREY_COLOR2
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(address.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: Constants.FONT,
                      fontWeight: FontWeight.bold
                    )
                ),
                Text(address.address1,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Constants.FONT
                    )
                ),
                Text(address.province,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Constants.FONT
                    )
                ),
                Text(address.country,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Constants.FONT
                    )
                ),
                SizedBox(height: 10),
                if (address.email != null) Text(address.email ?? '',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Constants.FONT
                    )
                ),
                if (address.phone != null) Text(address.phone ?? '',
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
                      case 'Delete':
                        _deleteAddress(address);
                        break;
                      case 'Set active':
                        _setActiveAddress(address);
                        break;
                      case 'Edit':
                        setState(() {
                          _addressToEdit = address;
                          _editAddress = true;
                          _name.text = address.name;
                          _address.text = address.address1;
                          _address2.text = address.address2!;
                          _city.text = address.city;
                          _zip.text = address.zip;
                          _state.text = address.province;
                          _country.text = address.country;
                          // _email.text = address.email;
                          // _phone.text = address.phone;
                        });
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
                  visible: address.active,
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
  
  getAddresses() {
    ApiManager(context).makeGetRequest('/client/address', {}, (response) {
      _activeAddress = null;
      _addresses = [];
      if (response["data"] != null) {
        for (var address in response["data"]) {
          if (address["active"]) {
            _activeAddress = Address.fromJson(address);
          } else {
            _addresses.add(Address.fromJson(address));
          }
        }
        if (_addresses.isNotEmpty || _activeAddress != null) {
          setState(() {
            _hasAddress = true;
            _addNewAddress = false;
          });
        }
      }
    }, (response) {});
  }

  saveAddress() {
    if (_name.text.isNotEmpty && _address.text.isNotEmpty && _country.text.isNotEmpty && _state.text.isNotEmpty && _zip.text.isNotEmpty && _city.text.isNotEmpty) {
      ApiManager(context).makePutRequest('/client/address', {
        "name": _name.text,
        "address1": _address.text,
        "country": _country.text,
        "province": _state.text,
        "zip": _zip.text,
        "city": _city.text,
        "latitude": -5,
        "longitude": -9,
        "address2": _address2.text,
        "note": "",
        "default": false,
        "active": _activeAddress == null
      }, (res) {}, (res) {});
    }
  }

  _deleteAddress(Address address) async {
    try {
      await ApiManager(context).internalMakeDeleteRequest('/client/address/${address.id}', (res) {}, (res) {});
      _removeAddress(address);
    } catch(e) {
      //
    }
  }

  _removeAddress(Address address) {
    setState(() {
      int i = _addresses.indexWhere((a) => address.id == a.id);
      if (i >= 0) {
        _addresses.removeAt(i);
      } else {
        _activeAddress = null;
      }
    });
  }

  _setActiveAddress(Address address) async {
    try {
      address.active = true;
      await ApiManager(context).makePostRequest('/client/address/${address.id}', address, (res) {}, (res) {});

      if (_activeAddress != null) {
        _activeAddress!.active = false;
        await ApiManager(context).makePostRequest('/client/address/${_activeAddress!.id}', _activeAddress!, (res) {}, (res) {});

        _addresses.add(_activeAddress!);
      }
      _activeAddress = address;
      _removeAddress(address);
    } catch(e) {
      //
    }
  }

  _updateAddress() async {
    if (_addressToEdit != null && _name.text.isNotEmpty && _address.text.isNotEmpty && _country.text.isNotEmpty && _state.text.isNotEmpty && _zip.text.isNotEmpty && _city.text.isNotEmpty) {
      ApiManager(context).makePostRequest('/client/address/${_addressToEdit!.id}', {
        "name": _name.text,
        "address1": _address.text,
        "country": _country.text,
        "province": _state.text,
        "zip": _zip.text,
        "city": _city.text,
        "latitude": -5,
        "longitude": -5,
        "address2": _address2.text,
        "note": "",
        "default": false,
        "active": _addressToEdit!.active
      }, (res) {
        getAddresses();
      }, (res) {});
    }
  }
}