import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sisterly/models/brand.dart';
import 'package:sisterly/models/color.dart';
import 'package:sisterly/models/delivery_mode.dart';
import 'package:sisterly/models/generic.dart';
import 'package:sisterly/models/material.dart';
import 'package:sisterly/models/var.dart';
import 'package:sisterly/screens/sister_advice_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sisterly/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/constants.dart';

class UploadScreen extends StatefulWidget {

  const UploadScreen({Key? key}) : super(key: key);

  @override
  UploadScreenState createState() => UploadScreenState();
}

class UploadScreenState extends State<UploadScreen>  {

  final TextEditingController _modelText = TextEditingController();
  final TextEditingController _descriptionText = TextEditingController();
  final TextEditingController _retail = TextEditingController();
  final TextEditingController _selling = TextEditingController();
  final TextEditingController _offer = TextEditingController();
  final ImagePicker picker = ImagePicker();
  List<XFile> _images = [];
  final List<Brand> _brands = [];
  final List<MyColor> _colors = [];
  final List<MyMaterial> _materials = [];
  late Brand _selectedBrand;
  late MyColor _selectedColor;
  late MyMaterial _selectedMaterial;
  DeliveryMode _selectedDelivery = deliveryTypes[0];
  Generic _selectedConditions = productConditions[0];
  Generic _selectedBagYears = bagYears[0];
  Generic _selectedBagSize = bagSizes[0];
  final List<String> _uploads = [];

  @override
  void initState() {
    super.initState();
    _getBrands();
    _getColors();
    _getMaterials();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getColorBullet(MyColor c) {
    Color color = HexColor(c.hex);
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
                    children: const [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: Text(
                            "Upload",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: Constants.FONT),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
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
                    children: <Widget>[
                      SizedBox(height: 8),
                      Text(
                        "Offer a New Bag",
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
                                  "Upload photos",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: Constants.FONT
                                  )
                              ),
                              onPressed: () async {
                                _images = (await picker.pickMultiImage())!;
                                _upload();
                                setState(() {});
                              },
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SisterAdviceScreen()));
                              },
                              child: Text(
                                  "See photo tips",
                                  style: TextStyle(
                                    color: Constants.PRIMARY_COLOR,
                                    fontSize: 14,
                                    fontFamily: Constants.FONT,
                                    decoration: TextDecoration.underline
                                  )
                              ),
                            ),
                            SizedBox(height: 10),
                            if (_images.isNotEmpty) GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              mainAxisSpacing: 5.0,
                              crossAxisSpacing: 5.0,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                  for (var img in _images)
                                    Image.file(File(img.path), fit: BoxFit.cover)
                              ]
                            ),
                            SizedBox(height: 10)
                          ]
                        )
                      ),
                      SizedBox(height: 32),
                      Text(
                        "Model Name",
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
                            hintText: "Model name...",
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
                        "Material",
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
                        "Description",
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
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "Description...",
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
                        "Color",
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
                        "Delivery",
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
                        "Conditions",
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
                                onChanged: (val) => setState(() => _selectedConditions = val!),
                                value: _selectedConditions
                            ),
                          )
                      ),
                      SizedBox(height: 32),
                      Text(
                        "Bag years",
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
                                onChanged: (val) => setState(() => _selectedBagYears = val!),
                                value: _selectedBagYears
                            ),
                          )
                      ),
                      SizedBox(height: 32),
                      Text(
                        "Bag size",
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
                        "Retail price",
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
                            hintText: "Retail price...",
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
                          controller: _retail,
                        ),
                      ),
                      SizedBox(height: 32),
                      Text(
                        "Selling price",
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
                            hintText: "Selling price...",
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
                          controller: _selling,
                        ),
                      ),
                      SizedBox(height: 32),
                      Text(
                        "Offer price",
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
                            hintText: "Offer price...",
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
                          controller: _offer,
                        ),
                      ),
                      SizedBox(height: 32),
                      TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Constants.PRIMARY_COLOR),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 46, vertical: 14)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))
                        ),
                        child: Text(
                            "Create product",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: Constants.FONT
                            )
                        ),
                        onPressed: () {
                          _createProduct();
                        },
                      ),
                      SizedBox(height: 60)
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
      if (data != null) {
        setState(() {
          for (var b in data) {
            _brands.add(Brand.fromJson(b));
          }
          _selectedBrand = _brands[0];
        });
      }
    }, (res) {});
  }

  _getColors() {
    ApiManager(context).makeGetRequest('/admin/color', {}, (res) {
      var data = res["data"];
      if (data != null) {
        setState(() {
          for (var b in data) {
            _colors.add(MyColor.fromJson(b));
          }
          _selectedColor = _colors[0];
        });
      }
    }, (res) {});
  }

  _getMaterials() {
    ApiManager(context).makeGetRequest('/admin/material', {}, (res) {
      var data = res["data"];
      if (data != null) {
        setState(() {
          for (var m in data) {
            _materials.add(MyMaterial.fromJson(m));
          }
          _selectedMaterial = _materials[0];
        });
      }
    }, (res) {});
  }

  _createProduct() {
    if (!(_uploads.isEmpty || _modelText.text.isEmpty || _descriptionText.text.isEmpty || _retail.text.isEmpty || _selling.text.isEmpty)) {
      ApiManager(context).makePutRequest('/product', {
        "model": _modelText.text,
        "media_pk": _uploads[0],
        "brad_pk": _selectedBrand.id,
        "color_pk": _selectedColor.id,
        "material_pk": _selectedMaterial.id,
        "conditions": _selectedConditions.id,
        "year": _selectedBagYears.id,
        "size": _selectedBagSize.id,
        "price_retail": double.parse(_retail.text),
        "price_offer": double.parse(_offer.text.isEmpty ? '0': _offer.text),
        "selling_price": double.parse(_selling.text),
        "delivery_type": _selectedDelivery.id,
        "delivery_kit_pk": 0,
        "description": _descriptionText.text,
        "maximum_loan_days": -1
      }, (res) {
        Navigator.of(context).pop();
      }, (res) {});
    }
  }

  _upload() {
    if (_images.isNotEmpty) {
      ApiManager(context).makePutRequest('/client/media', {}, (res) {
        String mediaId = res["data"]["id"];
        int i = 1;
        for (var photo in _images) {
          ApiManager(context).makeUploadRequest(context, '/client/media/$mediaId/images', photo.path, i++, (res) {
            debugPrint('Photo uploaded');
            // _uploads.add(res["data"]["id"]);
          }, (res) {
            debugPrint('Failed uploading photo');
          });
        }
      }, (res) {});
    }
  }
}
