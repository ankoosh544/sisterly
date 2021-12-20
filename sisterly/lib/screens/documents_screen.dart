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

class DocumentsScreen extends StatefulWidget {

  final Product? editProduct;

  const DocumentsScreen({Key? key, this.editProduct}) : super(key: key);

  @override
  DocumentsScreenState createState() => DocumentsScreenState();
}

class DocumentsScreenState extends State<DocumentsScreen>  {

  final ImagePicker picker = ImagePicker();
  List<XFile> _images = [];
  List<String> _imageUrls = [];
  bool _isUploading = false;

  List<Document> _documents = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getDocuments();
    });
  }

  getDocuments() {
    setState(() {
      _isLoading = true;
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
        _isLoading = false;
      });
    }, (res) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
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

  getTypeLabel(String slug) {
    switch(slug) {
      case 'IDENTITY_PROOF': return "Prova di identità";
      case 'REGISTRATION_PROOF': return "Prova di registrazione";
      case 'ARTICLES_OF_ASSOCIATION': return "Statuto";
      case 'SHAREHOLDER_DECLARATION': return "Dichiarazione";
      case 'ADDRESS_PROOF': return "Prova di indirizzo";
    }
  }

  getStatusLabel(String slug) {
    switch(slug) {
      case 'CREATED': return "Creato";
      case 'VALIDATION_ASKED': return "Validazione richiesta";
      case 'VALIDATED': return "Validato";
      case 'REFUSED': return "Rifiutato";
      case 'OUT_OF_DATE': return "Scaduto";
    }
  }

  documentCell(Document document) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getTypeLabel(document.type),
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Constants.TEXT_COLOR,
                fontFamily: Constants.FONT,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 8,),
            Text(
              getStatusLabel(document.status),
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Constants.TEXT_COLOR,
                fontFamily: Constants.FONT,
                fontSize: 16,
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
          HeaderWidget(title: "Documenti"),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 8),
                      Text(
                        "Carica l’immagine fronte retro del tuo documento di identità o passaporto in corso di validità",
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
                            SizedBox(height: 16),
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
                                      imageUrl: SessionData().serverUrl + img,
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
                      SizedBox(height: 60),
                      Text(
                        "Documenti caricati",
                        style: TextStyle(
                            color: Constants.DARK_TEXT_COLOR,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: Constants.FONT
                        ),
                      ),
                      SizedBox(width: 8,),
                      ListView.builder(
                        shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            return documentCell(_documents[index]);
                          }
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

  _upload() {
    if (_images.isNotEmpty) {
      setState(() {
        _isUploading = true;
      });

        int i = 1;
        for (var photo in _images) {
          var params = {
            "order": i++
          };
          ApiManager(context).makeUploadRequest(context, "POST", '/payment/kyc', photo.path, params, (res) {
            debugPrint('Photo uploaded');
            setState(() {
              _isUploading = false;
            });
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

}
