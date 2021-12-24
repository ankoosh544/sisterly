import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sisterly/models/address.dart';
import 'package:sisterly/models/brand.dart';
import 'package:sisterly/models/delivery_mode.dart';
import 'package:sisterly/models/document.dart';
import 'package:sisterly/models/generic.dart';
import 'package:sisterly/models/material.dart';
import 'package:sisterly/models/product.dart';
import 'package:sisterly/models/product_color.dart';
import 'package:sisterly/models/var.dart';
import 'package:sisterly/screens/product_edit_success_screen.dart';
import 'package:sisterly/screens/product_success_screen.dart';
import 'package:sisterly/screens/sister_advice_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sisterly/utils/session_data.dart';
import 'package:sisterly/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sisterly/widgets/header_widget.dart';

import '../utils/constants.dart';
import 'documents_screen.dart';

class UploadScreen extends StatefulWidget {

  final Product? editProduct;

  const UploadScreen({Key? key, this.editProduct}) : super(key: key);

  @override
  UploadScreenState createState() => UploadScreenState();
}

class UploadScreenState extends State<UploadScreen>  {

  final TextEditingController _modelText = TextEditingController();
  final TextEditingController _descriptionText = TextEditingController();
  final TextEditingController _sellingPrice = TextEditingController();
  final TextEditingController _dailyPrice = TextEditingController();
  final ImagePicker picker = ImagePicker();
  List<XFile> _images = [];
  final List<Brand> _brands = [];
  final List<ProductColor> _colors = [];
  final List<MyMaterial> _materials = [];
  final List<DeliveryMode> _deliveryModes = [];
  late Brand _selectedBrand;
  late ProductColor _selectedColor;
  late MyMaterial _selectedMaterial;
  DeliveryMode? _selectedDelivery = deliveryTypes[0];
  Generic _selectedConditions = productConditions[0];
  Generic _selectedBagYears = bagYears[0];
  Generic _selectedBagSize = bagSizes[0];
  Generic _selectedLenderKit = lenderKits[0];
  List<String> _imageUrls = [];
  String? _mediaId;
  bool _isUploading = false;
  bool _usePriceAlgo = false;
  bool _useDiscount = false;
  String? _suggestedPrice;
  List<Document> _documents = [];
  bool _isLoadingDocuments = true;

  /* Address management */
  final TextEditingController _name = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _address2 = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _zip = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _country = TextEditingController(text: "IT");
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  bool _hasAddress = false;
  bool _saveAddress = true;
  List<Address> _addresses = [];
  Address? _activeAddress;
  bool _addNewAddress = false;
  bool _editAddress = false;
  Address? _addressToEdit;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      debugPrint("deliveryTypes: "+jsonEncode(deliveryTypes));

      _getDocuments();
      _getMediaId();
      _getBrands();
      _getColors();
      _getMaterials();
      _getDeliveryModes();
      _getAddresses(() {
        populateEditProduct();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getDocuments() {
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

  populateEditProduct() {
    if(widget.editProduct != null) {
      if(_brands.isNotEmpty && _materials.isNotEmpty && _colors.isNotEmpty) {
        debugPrint("populateEditProduct edit product");
        _modelText.text = widget.editProduct!.model;
        _selectedBrand = _brands.firstWhere((element) => element.id == widget.editProduct!.brandId);
        _selectedMaterial = _materials.firstWhere((element) => element.id == widget.editProduct!.materialId);
        _descriptionText.text = widget.editProduct!.description ?? "";
        _selectedColor = _colors.firstWhere((element) => element.id == widget.editProduct!.colorId);
        if(widget.editProduct!.deliveryType != null) _selectedDelivery = deliveryTypes.firstWhere((element) => element.id == widget.editProduct!.deliveryType!.id);
        _selectedConditions = productConditions.firstWhere((element) => element.id == widget.editProduct!.conditionsId);
        _selectedBagYears = bagYears.firstWhere((element) => element.id == widget.editProduct!.yearId);
        _dailyPrice.text = widget.editProduct!.priceOffer.toString();
        _sellingPrice.text = widget.editProduct!.sellingPrice.toString();
        _usePriceAlgo = widget.editProduct!.usePriceAlgorithm;
        _useDiscount = widget.editProduct!.useDiscount;

        _imageUrls = widget.editProduct!.images;

        debugPrint("_imageUrls: "+_imageUrls.length.toString());
      }
    }

    setState(() {

    });
  }

  _getMediaId() {
    ApiManager(context).makePutRequest('/client/media', {}, (res) {
      _mediaId = res["data"]["id"];

      populateEditProduct();

      setState(() {

      });
    }, (res) {});
  }

  Widget getColorBullet(ProductColor c) {
    Color color = HexColor(c.hexadecimal);
    bool selected = c.id != _selectedColor.id;
    return InkWell(
      onTap: () => setState(() => _selectedColor = c),
      child: Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(right: 12, bottom: 8),
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(30)
          ),
          child: selected ? SizedBox() : SvgPicture.asset("assets/images/check_color.svg", width: 13, height: 10, fit: BoxFit.scaleDown)
      ),
    );
  }

  Future<bool> checkAndRequestCameraPermissions() async {
    PermissionStatus permission = await Permission.camera.status;
    if (permission != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera
      ].request();
      return statuses[Permission.camera] == PermissionStatus.granted;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.PRIMARY_COLOR,
      body: Column(
        children: [
          HeaderWidget(title: "Upload"),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 6),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      if(_documents.isEmpty) SizedBox(height: 15),
                      if(_documents.isEmpty && !_isLoadingDocuments) InkWell(
                        onTap: () async {
                          await Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) => DocumentsScreen()));

                          _getDocuments();
                        },
                        child: Card(
                          color: Color(0x88FF8A80),
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: const [
                                Text('Carica un documento d\'identità per poter procedere con il pagamento"',
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
                      AbsorbPointer(
                        absorbing: _documents.isEmpty,
                        child: Opacity(
                          opacity: _documents.isEmpty ? 0.4 : 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 8),
                              Text(
                                widget.editProduct != null ? "Modifica prodotto" : "Carica nuovo prodotto",
                                style: TextStyle(
                                    color: Constants.DARK_TEXT_COLOR,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Constants.FONT
                                ),
                              ),
                              SizedBox(height: 24,),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Constants.SECONDARY_COLOR_LIGHT
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    // Text(
                                    //   "Add up to 20 photos",
                                    //   style: TextStyle(
                                    //       color: Constants.LIGHT_TEXT_COLOR,
                                    //       fontSize: 14,
                                    //       fontFamily: Constants.FONT
                                    //   )
                                    // ),
                                    SizedBox(height: 10),
                                    TextButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Constants.SECONDARY_COLOR),
                                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 46, vertical: 14)),
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))
                                      ),
                                      child: Text(
                                        "Carica foto",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: Constants.FONT
                                        )
                                      ),
                                      onPressed: () async {
                                        ImageSource? source = await showDialog<ImageSource>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                              content: Text("Scegli immagine da"),
                                              actions: [
                                                FlatButton(
                                                  child: Text("Scatta ora"),
                                                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                                                ),
                                                FlatButton(
                                                  child: Text("Galleria"),
                                                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                                                ),
                                              ]
                                          ),
                                        );

                                        if(source == ImageSource.camera) {
                                          _images = [(await picker.pickImage(source: ImageSource.camera))!];
                                        } else {
                                          _images = (await picker.pickMultiImage())!;
                                        }

                                        _upload();
                                        setState(() {});
                                      },
                                    ),
                                    SizedBox(height: 12),
                                    if(_isUploading) CircularProgressIndicator(),
                                    SizedBox(height: 4),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SisterAdviceScreen()));
                                      },
                                      child: Text(
                                          "Vedi consigli",
                                          style: TextStyle(
                                            color: Constants.PRIMARY_COLOR,
                                            fontSize: 14,
                                            fontFamily: Constants.FONT,
                                            decoration: TextDecoration.underline
                                          )
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    if (_imageUrls.isNotEmpty) GridView.count(
                                      shrinkWrap: true,
                                      crossAxisCount: 4,
                                      mainAxisSpacing: 5.0,
                                      crossAxisSpacing: 5.0,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: [
                                          /*for (var img in _images)
                                            ClipRRect(
                                                child: Image.file(File(img.path), fit: BoxFit.cover),
                                              borderRadius: BorderRadius.circular(12),
                                            )*/

                                        for (var img in _imageUrls)
                                          ClipRRect(
                                            child: CachedNetworkImage(
                                              imageUrl: img,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) => SvgPicture.asset("assets/images/placeholder_product.svg"),
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          )
                                      ]
                                    ),
                                    SizedBox(height: 10)
                                  ]
                                )
                              ),
                              SizedBox(height: 32),
                              Text(
                                "Nome modello",
                                style: TextStyle(
                                    color: Constants.TEXT_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT
                                ),
                              ),
                              SizedBox(height: 8,),
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
                                  keyboardType: TextInputType.text,
                                  cursorColor: Constants.PRIMARY_COLOR,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Constants.FORM_TEXT,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Nome modello...",
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
                                  controller: _modelText,
                                ),
                              ),
                              SizedBox(height: 32,),
                              Text(
                                "Brand",
                                style: TextStyle(
                                    color: Constants.TEXT_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT
                                ),
                              ),
                              SizedBox(height: 8,),
                              if (_brands.isNotEmpty)  Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x4ca3c4d4),
                                      spreadRadius: 8,
                                      blurRadius: 12,
                                      offset:
                                      Offset(0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<Brand>(
                                    items: _brands.map((Brand b) => DropdownMenuItem<Brand>(
                                        child: Text(b.name, style: TextStyle(fontSize: 16)),
                                        value: b
                                      )
                                    ).toList(),
                                    onChanged: (val) => setState(() => _selectedBrand = val!),
                                    value: _selectedBrand
                                  ),
                                )
                              ),
                              SizedBox(height: 32),
                              Text(
                                "Materiale",
                                style: TextStyle(
                                    color: Constants.TEXT_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT
                                ),
                              ),
                              SizedBox(height: 8,),
                              if (_materials.isNotEmpty)  Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x4ca3c4d4),
                                      spreadRadius: 8,
                                      blurRadius: 12,
                                      offset:
                                      Offset(0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<MyMaterial>(
                                    items: _materials.map((MyMaterial m) => DropdownMenuItem<MyMaterial>(
                                        child: Text(m.material, style: TextStyle(fontSize: 16)),
                                        value: m
                                      )
                                    ).toList(),
                                    onChanged: (val) => setState(() => _selectedMaterial = val!),
                                    value: _selectedMaterial
                                  ),
                                )
                              ),
                              SizedBox(height: 32),
                              Text(
                                "Descrizione",
                                style: TextStyle(
                                    color: Constants.TEXT_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT
                                ),
                              ),
                              SizedBox(height: 8,),
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
                                  keyboardType: TextInputType.multiline,
                                  cursorColor: Constants.PRIMARY_COLOR,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Constants.FORM_TEXT,
                                  ),
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    hintText: "Esempio: descrizione delle condizioni, spiegazione di eventuali imperfezioni, a cosa stare attenti nell’utilizzo ecc",
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
                                  controller: _descriptionText,
                                ),
                              ),
                              SizedBox(height: 32,),
                              Text(
                                "Colore",
                                style: TextStyle(
                                    color: Constants.DARK_TEXT_COLOR,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Constants.FONT),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8,),
                              if (_colors.isNotEmpty) Wrap(
                                children: [
                                  for (var c in _colors)
                                    getColorBullet(c)
                                ],
                              ),
                              SizedBox(height: 32,),
                              Text(
                                "Consegna",
                                style: TextStyle(
                                    color: Constants.DARK_TEXT_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8,),
                              Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x4ca3c4d4),
                                        spreadRadius: 8,
                                        blurRadius: 12,
                                        offset:
                                        Offset(0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<DeliveryMode>(
                                        items: deliveryTypes.map((DeliveryMode val) => DropdownMenuItem<DeliveryMode>(
                                            child: Text(val.description, style: TextStyle(fontSize: 16)),
                                            value: val
                                        )
                                        ).toList(),
                                        onChanged: (val) => setState(() => _selectedDelivery = val!),
                                        value: _selectedDelivery
                                    ),
                                  )
                              ),
                              SizedBox(height: 32),
                              Text(
                                "Condizioni",
                                style: TextStyle(
                                    color: Constants.DARK_TEXT_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8,),
                              Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x4ca3c4d4),
                                        spreadRadius: 8,
                                        blurRadius: 12,
                                        offset:
                                        Offset(0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<Generic>(
                                        items: productConditions.map((Generic val) => DropdownMenuItem<Generic>(
                                            child: Text(val.name, style: TextStyle(fontSize: 16)),
                                            value: val
                                        )
                                        ).toList(),
                                        onChanged: (val) {
                                          _calculateSuggestedPrice();
                                          setState(() => _selectedConditions = val!) ;
                                        },
                                        value: _selectedConditions
                                    ),
                                  )
                              ),
                              SizedBox(height: 32),
                              Text(
                                "Anni",
                                style: TextStyle(
                                    color: Constants.DARK_TEXT_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8,),
                              Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x4ca3c4d4),
                                        spreadRadius: 8,
                                        blurRadius: 12,
                                        offset:
                                        Offset(0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<Generic>(
                                        items: bagYears.map((Generic val) => DropdownMenuItem<Generic>(
                                            child: Text(val.name, style: TextStyle(fontSize: 16)),
                                            value: val
                                        )
                                        ).toList(),
                                        onChanged: (val) {
                                          _calculateSuggestedPrice();
                                          setState(() => _selectedBagYears = val!);
                                        },
                                        value: _selectedBagYears
                                    ),
                                  )
                              ),
                              SizedBox(height: 32),
                              Text(
                                "Dimensioni",
                                style: TextStyle(
                                    color: Constants.DARK_TEXT_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8,),
                              Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x4ca3c4d4),
                                        spreadRadius: 8,
                                        blurRadius: 12,
                                        offset:
                                        Offset(0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<Generic>(
                                        items: bagSizes.map((Generic val) => DropdownMenuItem<Generic>(
                                            child: Text(val.name, style: TextStyle(fontSize: 16)),
                                            value: val
                                        )
                                        ).toList(),
                                        onChanged: (val) => setState(() => _selectedBagSize = val!),
                                        value: _selectedBagSize
                                    ),
                                  )
                              ),
                              SizedBox(height: 32),
                              Text(
                                "Prezzo di acquisto",
                                style: TextStyle(
                                    color: Constants.TEXT_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT
                                ),
                              ),
                              SizedBox(height: 8,),
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
                                  keyboardType: TextInputType.number,
                                  cursorColor: Constants.PRIMARY_COLOR,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Constants.FORM_TEXT,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Prezzo di acquisto...",
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
                                  onChanged: (str) {
                                    _calculateSuggestedPrice();
                                  },
                                  controller: _sellingPrice,
                                ),
                              ),
                              SizedBox(height: 32),
                              Text(
                                "Prezzo al giorno",
                                style: TextStyle(
                                    color: Constants.TEXT_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT
                                ),
                              ),
                              SizedBox(height: 8,),
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
                                  keyboardType: TextInputType.number,
                                  cursorColor: Constants.PRIMARY_COLOR,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Constants.FORM_TEXT,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: _suggestedPrice ?? "Prezzo al giorno...",
                                    hintStyle: const TextStyle(color: Constants.PLACEHOLDER_COLOR),
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
                                  controller: _dailyPrice,
                                ),
                              ),
                              SizedBox(height: 12,),
                              Text(
                                "The suggested price is calculated on the basis of the average for this stock market model. you can change it at any time.",
                                style: TextStyle(
                                    color: Constants.TEXT_COLOR,
                                    fontSize: 14,
                                    fontFamily: Constants.FONT
                                ),
                              ),
                              SizedBox(height: 32,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Transform.scale(
                                    scale: 1.2,
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        unselectedWidgetColor: Color(0xff92a0a7),
                                      ),
                                      child: Checkbox(
                                          value: _useDiscount,
                                          activeColor: Constants.PRIMARY_COLOR,
                                          onChanged: (value) {
                                            setState(() {
                                              _useDiscount = value!;
                                            });
                                          }
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _useDiscount = !_useDiscount;
                                        });
                                      },
                                      child: Text("Vuoi partecipare alle promozion in Sisterly?",
                                        style: TextStyle(
                                            color: Constants.TEXT_COLOR,
                                            fontSize: 16,
                                            fontFamily: Constants.FONT
                                        ),
                                      ),
                                    )
                                  ),
                                ],
                              ),
                              SizedBox(height: 32,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Transform.scale(
                                    scale: 1.2,
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        unselectedWidgetColor: Color(0xff92a0a7),
                                      ),
                                      child: Checkbox(
                                          value: _usePriceAlgo,
                                          activeColor: Constants.PRIMARY_COLOR,
                                          onChanged: (value) {
                                            setState(() {
                                              _usePriceAlgo = value!;
                                            });
                                          }
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _usePriceAlgo = !_usePriceAlgo;
                                        });
                                      },
                                      child: Text("Vuoi che Sisterly calcoli il prezzo per te per noleggi più lunghi?",
                                        style: TextStyle(
                                            color: Constants.TEXT_COLOR,
                                            fontSize: 16,
                                            fontFamily: Constants.FONT
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 32),
                              Text(
                                "A quale indirizzo dobbiamo inviare il Sisterly Kit?",
                                style: TextStyle(
                                    color: Constants.DARK_TEXT_COLOR,
                                    fontSize: 18,
                                    fontFamily: Constants.FONT,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              if (!_hasAddress || _addNewAddress || _editAddress) Column(
                                  children: [
                                    inputField("Nome", _name, false),
                                    inputField("Indirizzo", _address, false),
                                    inputField("Indirizzo 2", _address2, false),
                                    inputField("Città", _city, false),
                                    inputField("Codice postale", _zip, false),
                                    inputField("Provincia", _state, false),
                                    inputField("Nazione", _country, true),
                                    inputField("Email", _email, false),
                                    inputField("Cellulare", _phone, false),
                                    const SizedBox(height: 25),
                                  ]
                              ),
                              if (_editAddress) ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Constants.GREEN_SAVE,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                                ),
                                child: Text('Salva',
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
                                      child: Text('+ Nuovo',
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
                              SizedBox(height: 32,),
                              Text(
                                "Ci siamo quasi!\n\nOgni Lender Sister ha bisogno del suo Lender Kit che contiene un tag univoco per rendere la tua borsa insostituibile (è obbligatorio applicare l’adesivo ed è fondamentale per tutelarti) e una dust bag in cui inserire la tua borsa prima di noleggiarla.\n\nA te la scelta: ",
                                style: TextStyle(
                                    color: Constants.TEXT_COLOR,
                                    fontSize: 16,
                                    fontFamily: Constants.FONT
                                ),
                              ),
                              SizedBox(height: 8,),
                              Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x4ca3c4d4),
                                        spreadRadius: 8,
                                        blurRadius: 12,
                                        offset:
                                        Offset(0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<Generic>(
                                        items: lenderKits.map((Generic val) => DropdownMenuItem<Generic>(
                                            child: Text(val.name, style: TextStyle(fontSize: 16)),
                                            value: val
                                        )
                                        ).toList(),
                                        onChanged: (val) {
                                          setState(() => _selectedLenderKit = val!) ;
                                        },
                                        value: _selectedLenderKit
                                    ),
                                  )
                              ),
                              SizedBox(height: 32),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Constants.SECONDARY_COLOR,
                                      textStyle: const TextStyle(
                                          fontSize: 16),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 80, vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50))),
                                  child: Text('Conferma'),
                                  onPressed: () async {
                                    if (!_hasAddress || (_saveAddress && _addNewAddress && !_editAddress)) {
                                      saveAddress(() async {
                                        _getAddresses(() {
                                          _createProduct();
                                        });
                                      });
                                    } else {
                                      _createProduct();
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 60)
                            ],
                          ),
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

  _getBrands() {
    ApiManager(context).makeGetRequest('/admin/brand', {}, (res) {
      var data = res["data"];
      _brands.clear();
      if (data != null) {
        setState(() {
          for (var b in data) {
            _brands.add(Brand.fromJson(b));
          }
          _selectedBrand = _brands[0];
        });
      }

      populateEditProduct();
    }, (res) {});
  }

  _getColors() {
    ApiManager(context).makeGetRequest('/admin/color', {}, (res) {
      var data = res["data"];
      if (data != null) {
        _colors.clear();
        setState(() {
          for (var b in data) {
            _colors.add(ProductColor.fromJson(b));
          }
          debugPrint("_colors: "+_colors.length.toString());
          _selectedColor = _colors[0];
        });
      }

      populateEditProduct();
    }, (res) {});
  }

  _getMaterials() {
    ApiManager(context).makeGetRequest('/admin/material', {}, (res) {
      var data = res["data"];
      if (data != null) {
        _materials.clear();
        setState(() {
          for (var m in data) {
            _materials.add(MyMaterial.fromJson(m));
          }
          _selectedMaterial = _materials[0];
        });
      }

      populateEditProduct();
    }, (res) {});
  }

  _getDeliveryModes() {
    ApiManager(context).makeGetRequest('/product/delivery_modes', {}, (res) {
      var data = res["data"];
      if (data != null) {
        _deliveryModes.clear();
        setState(() {
          for (var m in data) {
            _deliveryModes.add(DeliveryMode.fromJson(m));
          }
          //_selectedDelivery = _deliveryModes[0];
        });
      }

      populateEditProduct();
    }, (res) {

    });
  }

  _calculateSuggestedPrice() {
    if(_sellingPrice.text.isNotEmpty) {
      var params = {
        "selling_price": _sellingPrice.text.toString(),
        "condition": _selectedConditions.id,
        "year": _selectedBagYears.id
      };
      ApiManager(context).makeGetRequest('/product/suggested_price', params, (res) {
        var data = res["data"];
        if (data != null) {
          debugPrint("setting price "+data.toString());
          setState(() {
            _suggestedPrice = data.toString();
          });
        }
      }, (res) {

      });
    }
  }

  _createProduct() {
    debugPrint("_createProduct");
    if(_modelText.text.isEmpty) {
      ApiManager.showFreeErrorToast(context, "Inserisci il modello");
      return;
    }

    if(_descriptionText.text.isEmpty) {
      ApiManager.showFreeErrorToast(context, "Inserisci la descrizione");
      return;
    }

    if(_dailyPrice.text.isEmpty) {
      ApiManager.showFreeErrorToast(context, "Inserisci il prezzo al giorno");
      return;
    }

    if(_sellingPrice.text.isEmpty) {
      ApiManager.showFreeErrorToast(context, "Inserisci il prezzo di acquisto");
      return;
    }

    if (!(_modelText.text.isEmpty || _descriptionText.text.isEmpty || _sellingPrice.text.isEmpty || _dailyPrice.text.isEmpty || _selectedDelivery == null)) {
      var params = {
        "model": _modelText.text,
        "media_pk": _mediaId,
        "brand_pk": _selectedBrand.id,
        "color_pk": _selectedColor.id,
        "material_pk": _selectedMaterial.id,
        "conditions": _selectedConditions.id,
        "year": _selectedBagYears.id,
        "size": _selectedBagSize.id,
        "price_retail": double.parse(_dailyPrice.text),
        "price_offer": double.parse(_dailyPrice.text),
        "selling_price": double.parse(_sellingPrice.text),
        "delivery_type": _selectedDelivery!.id,
        "delivery_kit_pk": _activeAddress!.id,
        "description": _descriptionText.text,
        "maximum_loan_days": -1,
        "use_discount": _useDiscount,
        "use_price_algorithm": _usePriceAlgo,
        "lender_kit_to_send": _selectedLenderKit.id
      };

      if(widget.editProduct != null) {
        ApiManager(context).makePostRequest('/product/' + widget.editProduct!.id.toString() + "/", params, (res) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => ProductEditSuccessScreen()), (_) => false);
        }, (res) {});
      } else {
        ApiManager(context).makePutRequest('/product/', params, (res) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => ProductSuccessScreen()), (_) => false);
        }, (res) {});
      }
    }
  }

  _upload() {
    if (_images.isNotEmpty) {
      setState(() {
        _isUploading = true;
      });
      debugPrint("uploading " + _images.length.toString() + " images");
        int i = 1;
        for (var photo in _images) {
          var params = {
            "order": i++
          };
          ApiManager(context).makeUploadRequest(context, "PUT", '/client/media/$_mediaId/images', photo.path, params, (res) {
            debugPrint('Photo uploaded');
            setState(() {
              _isUploading = false;
            });

            _imageUrls.add(res["data"]["image"]["image"]);
          }, (res) {
            debugPrint('Failed uploading photo');
            _images.remove(photo);
            setState(() {
              _isUploading = false;
            });
          });
        }

        setState(() {

        });
    }
  }

  Widget inputField(String label, TextEditingController controller, bool readOnly) {
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
              keyboardType: TextInputType.text,
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
              readOnly: readOnly,
            ),
          ),
        ]
    );
  }

  Widget _renderAddress(Address address) {
    List<String> menu = ['Elimina', 'Predefinito', 'Modifica'];
    if (address.active) {
      menu = ['Modifica'];
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
                    Text(address.city + " - " + address.province,
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
                          case 'Elimina':
                            _deleteAddress(address);
                            break;
                          case 'Predefinito':
                            _setActiveAddress(address);
                            break;
                          case 'Modifica':
                            setState(() {
                              _addressToEdit = address;
                              _editAddress = true;
                              _name.text = address.name;
                              _address.text = address.address1;
                              _address2.text = address.address2 ?? "";
                              _city.text = address.city;
                              _zip.text = address.zip;
                              _state.text = address.province;
                              _country.text = address.country;
                              _email.text = address.email ?? "";
                              _phone.text = address.phone ?? "";
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

  _getAddresses(Function? callback) {
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

        setState(() {

        });

        if(callback != null) callback();
      }
    }, (response) {});
  }

  saveAddress(callback) {
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
      }, (res) {
        if(callback != null) callback();
      }, (res) {
        if(callback != null) callback();
      });
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
        _getAddresses(null);
      }, (res) {});
    }
  }
}
