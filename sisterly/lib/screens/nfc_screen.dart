import 'dart:io';

import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:sisterly/models/record.dart';
import 'package:sisterly/screens/signup_screen.dart';
import 'package:sisterly/utils/api_manager.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:sisterly/utils/extensions.dart';
import 'package:sisterly/utils/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/constants.dart';

class NfcScreen extends StatefulWidget {

  @override
  NfcScreenState createState() => NfcScreenState();
}

class NfcScreenState extends State<NfcScreen> {

  String _errorMessage = "msg";

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      bool isAvailable = await NfcManager.instance.isAvailable();

      debugPrint("nfc isAvailable: "+isAvailable.toString());

      startScan();
    });
  }

  startScan() {
    NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        try {
          debugPrint("on discovererd");
          final result = await handleTag(tag);
            if (result == null) {
              debugPrint("on discovererd result NULL");
              return;
            }

            debugPrint("on discovererd OK. STOP session. "+result.toString());
            await NfcManager.instance.stopSession();
          //setState(() => _alertMessage = result);
        } catch (e) {
          debugPrint("on discovererd EXCEPTION "+e.toString());
          await NfcManager.instance.stopSession().catchError((_) { /* no op */ });
          //setState(() => _errorMessage = '$e');
        }
      },
    ).catchError((e) => setState(() => _errorMessage = '$e'));
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession().catchError((_) { /* no op */ });
    super.dispose();
  }


  /*Future<String?> handleTag(NfcTag tag, Iterable<WriteRecord> recordList) async {
    final tech = Ndef.from(tag);

    if (tech == null)
      throw('Tag is not ndef.');

    if (!tech.isWritable)
      throw('Tag is not ndef writable.');

    try {
      final message = NdefMessage(recordList.map((e) => e.record).toList());
      await tech.write(message);
    } on PlatformException catch (e) {
      throw(e.message ?? 'Some error has occurred.');
    }

    return '[Ndef - Write] is completed.';
  }*/
  /*Future<String?> handleTag(NfcTag tag) async {
    //this.tag = tag;
    //additionalData = {};

    Object? tech;

    // todo: more additional data
    if (Platform.isIOS) {
      tech = FeliCa.from(tag);
      debugPrint("tech is "+tech.toString());
      if (tech is FeliCa) {
        final polling = await tech.polling(
          systemCode: tech.currentSystemCode,
          requestCode: FeliCaPollingRequestCode.noRequest,
          timeSlot: FeliCaPollingTimeSlot.max1,
        );
        debugPrint("tag ok "+polling.requestData.toString());
        //additionalData!['manufacturerParameter'] = polling.manufacturerParameter;
      }
    }

    //notifyListeners();
    return '[Tag - Read] is completed.';
  }*/
  Future<String?> handleTag(NfcTag tag) async {
    final tech = Ndef.from(tag);

    if (tech == null) {
      debugPrint("tag "+tech.toString());

      throw('Tag is not ndef formatable.');
    }

    if (tech is Ndef) {
      final cachedMessage = tech.cachedMessage;
      final canMakeReadOnly = tech.additionalData['canMakeReadOnly'] as bool?;
      final type = tech.additionalData['type'] as String?;
      debugPrint("tech is ndef "+('${cachedMessage?.byteLength ?? 0} / ${tech.maxSize} bytes'));
      debugPrint("isWritable: "+tech.isWritable.toString());

      if (cachedMessage != null) {
        var productId = "";

        Iterable.generate(cachedMessage.records.length).forEach((i) {
          final record = cachedMessage.records[i];
          final info = NdefRecordInfo.fromNdef(record);

          debugPrint("info " + info.subtitle.toString());

          productId = info.subtitle.replaceAll("(en)", "");
        });

        if(productId.isNotEmpty) {
          debugPrint("open product "+productId);
        }
      } else {
        debugPrint("cached messages null");
      }
    }

    try {
      debugPrint("reading "+tech.cachedMessage.toString());
      //await tech.format(NdefMessage([]));
    } on PlatformException catch (e) {
      throw(e.message ?? 'Some error has occurred.');
    }

    return '[Ndef - Format] is completed.';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.PRIMARY_COLOR,
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white,),
        child: Stack(
          children: [
            SvgPicture.asset("assets/images/bg-pink-ellipse.svg"),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                          child: Container(padding: const EdgeInsets.all(12), child: SvgPicture.asset("assets/images/back_black.svg")),
                          onTap: () {
                            Navigator.of(context).pop();
                          }
                      ),
                    ),
                    const SizedBox(height: 44),
                    Text(
                      "Pronto",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Constants.PRIMARY_COLOR,
                        fontFamily: Constants.FONT,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Mantieni il telefono vicino all'oggetto per scansionarlo",
                        style: TextStyle(
                          color: Constants.TEXT_COLOR,
                          fontSize: 16,
                          fontFamily: Constants.FONT,
                        ),
                      textAlign: TextAlign.center,
                    ),
                    Text(_errorMessage),
                    const SizedBox(height: 80),
                    InkWell(
                      onTap: () {
                        startScan();
                      },
                        child: SvgPicture.asset("assets/images/phone_nfc.svg")
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NdefRecordInfo {
  const NdefRecordInfo({required this.record, required this.title, required this.subtitle});

  final Record record;

  final String title;

  final String subtitle;

  static NdefRecordInfo fromNdef(NdefRecord record) {
    final _record = Record.fromNdef(record);
    if (_record is WellknownTextRecord)
      return NdefRecordInfo(
        record: _record,
        title: 'Wellknown Text',
        subtitle: '(${_record.languageCode}) ${_record.text}',
      );
    if (_record is WellknownUriRecord)
      return NdefRecordInfo(
        record: _record,
        title: 'Wellknown Uri',
        subtitle: '${_record.uri}',
      );
    if (_record is MimeRecord)
      return NdefRecordInfo(
        record: _record,
        title: 'Mime',
        subtitle: '(${_record.type}) ${_record.dataString}',
      );
    if (_record is AbsoluteUriRecord)
      return NdefRecordInfo(
        record: _record,
        title: 'Absolute Uri',
        subtitle: '(${_record.uriType}) ${_record.payloadString}',
      );
    if (_record is ExternalRecord)
      return NdefRecordInfo(
        record: _record,
        title: 'External',
        subtitle: '(${_record.domainType}) ${_record.dataString}',
      );
    if (_record is UnsupportedRecord) {
      // more custom info from NdefRecord.
      if (record.typeNameFormat == NdefTypeNameFormat.empty)
        return NdefRecordInfo(
          record: _record,
          title: _typeNameFormatToString(_record.record.typeNameFormat),
          subtitle: '-',
        );
      return NdefRecordInfo(
        record: _record,
        title: _typeNameFormatToString(_record.record.typeNameFormat),
        subtitle: '(${_record.record.type.toHexString()}) ${_record.record.payload.toHexString()}',
      );
    }
    throw UnimplementedError();
  }
}

String _typeNameFormatToString(NdefTypeNameFormat format) {
  switch (format) {
    case NdefTypeNameFormat.empty:
      return 'Empty';
    case NdefTypeNameFormat.nfcWellknown:
      return 'NFC Wellknown';
    case NdefTypeNameFormat.media:
      return 'Media';
    case NdefTypeNameFormat.absoluteUri:
      return 'Absolute Uri';
    case NdefTypeNameFormat.nfcExternal:
      return 'NFC External';
    case NdefTypeNameFormat.unknown:
      return 'Unknown';
    case NdefTypeNameFormat.unchanged:
      return 'Unchanged';
  }
}