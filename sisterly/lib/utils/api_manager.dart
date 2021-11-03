import 'dart:convert';
import 'dart:developer';

import 'package:sisterly/utils/localization/app_localizations.dart';
import 'package:sisterly/utils/session_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sisterly/widgets/alert/custom_alert.dart';
import 'constants.dart';

class ApiManager {

  static bool isErrorShowing = false;
  final BuildContext context;

  ApiManager(this.context);

  //USER APIS

  login(email, password, success, failure) async {
    var params = {
      "email": email,
      "password": password,
    };

    //makePublicPostRequest("/public-api/login", params, success, failure);
  }

  createUser(success, failure){
    debugPrint("postUser called");
    makePostRequest("/api/users", null, success, failure);
  }

  refreshToken(refreshToken, userId, success, failure) async {
    debugPrint("refreshToken called");
    var params = {
      "refreshToken": refreshToken,
      "userId": userId
    };

    //await makePublicPostRequest("/public-api/refresh", params, success, failure);
  }

  makePostRequest(endpoint, params, success, failure) async {
    await internalMakePostRequest(endpoint, params, SessionData().token, success, failure, true);
  }

  internalMakePostRequest(endpoint, params, token, success, failure, retry) async {
    String url = SessionData().serverUrl + endpoint;

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": token,
      "Accept-Language": await getLocale(context)
    };
    String json = jsonEncode(params);

    debugPrint("internalMakePostRequest "+url+" with params: "+json);

    try {
      Response response = await http.post(Uri.parse(url), headers: headers, body: json);
      int statusCode = response.statusCode;
      String body = response.body;

      log("Status: " + statusCode.toString() + "  body: " + body);

      if (statusCode == 200 || statusCode == 201) {
        var bodyResponse = jsonDecode(body);

        if (bodyResponse["status"].toString() == "500") {
          debugPrint("internalMakePostRequest " + url + " invalid token");
          failure(401);
        } else if(bodyResponse["status"] != null && bodyResponse["status"].toString() == "401" && retry){
          debugPrint("makeGetRequest: refreshToken");
          retry = false;
          var preferences = await SharedPreferences.getInstance();
          var token = preferences.getString(Constants.PREFS_REFRESH_TOKEN);
          refreshToken(token, SessionData().userId, (response) async {
            var preferences = await SharedPreferences.getInstance();
            preferences.setString(Constants.PREFS_TOKEN, response["data"].toString());
            SessionData().token = response["data"].toString();
            internalMakePostRequest(endpoint, params, SessionData().token, success, failure, false);
          }, failure);
        }else {
          debugPrint(
              "internalMakePostRequest " + url + " success. Body: " + body);
          success(bodyResponse);
        }
      } else {
        debugPrint("internalMakePostRequest " + url + " failure");
        failure(statusCode);
      }
    } catch(ex) {
      debugPrint("internalMakePostRequest exception "+ex.toString());
      failure(null);
    }
  }

  String encodeMap(Map data) {
    return data.keys.map((key) => "${Uri.encodeComponent(key)}=${Uri.encodeComponent(data[key])}").join("&");
  }

  makeGetRequest(endpoint, params, success, failure) async {
    await internalMakeGetRequest(endpoint, params, SessionData().token, success, failure, true);
  }

  makeFutureGetRequest(endpoint, params) async {
    return await internalFutureMakeGetRequest(endpoint, params, SessionData().token);
  }

  internalMakeGetRequest(endpoint, params, token, success, failure, retry) async {
    debugPrint("makeGetRequest "+SessionData().serverUrl + endpoint +" with params: "+jsonEncode(params));

    var paramsString = "";

    if(params != null) {
      paramsString = "?" + encodeMap(params);
    }

    debugPrint("makeGetRequest final url "+SessionData().serverUrl + endpoint + paramsString);

    try {
      var response = await http.get(Uri.parse(SessionData().serverUrl + endpoint + paramsString), headers: {
        "Accept": "application/json",
        "Authorization": token,
        "Accept-Language": await getLocale(context)
      });

      /*Response response = await get(uri);*/

      int statusCode = response.statusCode;
      String json = response.body;

      log("Status: "+statusCode.toString()+"  body: "+ json);

      if(statusCode == 200 || statusCode == 201) {
        try {
          var bodyResponse = jsonDecode(json);

          if(bodyResponse["status"] != null && bodyResponse["status"].toString() == "500") {
            debugPrint("makeGetRequest "+endpoint+" invalid token");
            manageFailure(failure, context, 401, json);
          }else if(bodyResponse["status"] != null && bodyResponse["status"].toString() == "401" && retry){
            debugPrint("makeGetRequest: refreshToken");
            retry = false;
            var preferences = await SharedPreferences.getInstance();
            var token = preferences.getString(Constants.PREFS_REFRESH_TOKEN);
            refreshToken(token, SessionData().userId, (response) async {
              var preferences = await SharedPreferences.getInstance();
              preferences.setString(Constants.PREFS_TOKEN, response["data"].toString());
              SessionData().token = response["data"].toString();
              internalMakeGetRequest(endpoint, params, SessionData().token, success, failure, false);
            }, failure);
          } else {
            if(bodyResponse["success"] == true) {
              debugPrint("makeGetRequest "+endpoint+" success");
              success(bodyResponse);
            } else {
              debugPrint("makeGetRequest "+endpoint+" success FALSE");
              failure();
            }
          }
        } catch(ex) {
          debugPrint("makeGetRequest "+endpoint+" catch failure "+ex.toString());
          manageFailure(failure, context, statusCode, json);
        }
      } else {
        manageFailure(failure, context, statusCode, json);
      }
    } catch(ex) {
      manageFailure(failure, context, null, json);
    }
  }

  internalFutureMakeGetRequest(endpoint, params, token) async {
    debugPrint("internalFutureMakeGetRequest "+SessionData().serverUrl + endpoint +" with params: "+jsonEncode(params));

    var paramsString = "";

    if(params != null) {
      paramsString = "?" + encodeMap(params);
    }

    debugPrint("internalFutureMakeGetRequest final url "+SessionData().serverUrl + endpoint + paramsString);

    try {
      var response = await http.get(Uri.parse(SessionData().serverUrl + endpoint + paramsString), headers: {
        "Accept": "application/json",
        "Authorization": token,
        "Accept-Language": await getLocale(context)
      });

      /*Response response = await get(uri);*/

      int statusCode = response.statusCode;
      String json = response.body;

      log("Status: "+statusCode.toString()+"  body: "+ json);

      if(statusCode == 200 || statusCode == 201) {
        try {
          var bodyResponse = jsonDecode(json);

          if(bodyResponse["status"] != null && bodyResponse["status"].toString() == "500") {
            debugPrint("internalFutureMakeGetRequest "+endpoint+" invalid token");
            return await manageFutureFailure(context, 401, json);
          } else {
            if(bodyResponse["success"] == true) {
              debugPrint("internalFutureMakeGetRequest "+endpoint+" success");
              return bodyResponse;
            } else {
              ApiManager.showFreeToast(context, endpoint + " success FALSE");
              debugPrint("internalFutureMakeGetRequest "+endpoint+" success FALSE");
              return await manageFutureFailure(context, statusCode, json);
            }
          }
        } catch(ex) {
          ApiManager.showFreeToast(context, endpoint + " catch failure "+ex.toString());
          debugPrint("internalFutureMakeGetRequest "+endpoint+" catch failure "+ex.toString());
          return await manageFutureFailure(context, statusCode, json);
        }
      } else {
        ApiManager.showFreeToast(context, endpoint + " status code error: "+statusCode.toString());
        debugPrint("internalFutureMakeGetRequest status code error: "+statusCode.toString());
        return await manageFutureFailure(context, statusCode, json);
      }
    } catch(ex) {
      ApiManager.showFreeToast(context, endpoint + " catch error " + ex.toString());
      debugPrint("internalFutureMakeGetRequest catch error " + ex.toString());
      return await manageFutureFailure(context, null, json);
    }
  }

  makePutRequest(endpoint, params, success, failure) async {
    internalMakePutRequest(endpoint, params, SessionData().token, success, failure, true);
  }

  internalMakePutRequest(endpoint, params, token, success, failure, retry) async {
    String url = SessionData().serverUrl + endpoint;

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": token,
      "Accept-Language": await getLocale(context)
    };
    String json = jsonEncode(params);

    debugPrint("internalMakePutRequest "+url+" with params: "+json);

    try {
      Response response = await http.put(Uri.parse(url), headers: headers, body: json);
      int statusCode = response.statusCode;
      String body = response.body;

      debugPrint("Status: " + statusCode.toString() + "  body: " + body);

      if (statusCode == 200 || statusCode == 201) {
        var bodyResponse = jsonDecode(body);

        if (!bodyResponse["success"] && bodyResponse["status"].toString() == "500") {
          debugPrint("internalMakePutRequest " + url + " invalid token");
          manageFailure(failure, context, 401, json);
        } else if(bodyResponse["status"] != null && bodyResponse["status"].toString() == "401" && retry){
          debugPrint("makeGetRequest: refreshToken");
          retry = false;
          var preferences = await SharedPreferences.getInstance();
          var token = preferences.getString(Constants.PREFS_REFRESH_TOKEN);
          refreshToken(token, SessionData().userId, (response) async {
            var preferences = await SharedPreferences.getInstance();
            preferences.setString(Constants.PREFS_TOKEN, response["data"].toString());
            SessionData().token = response["data"].toString();
            internalMakePutRequest(endpoint, params, SessionData().token, success, failure, false);
          }, failure);
        } else {
          debugPrint("internalMakePutRequest " + url + " success. Body: " + body);
          success(bodyResponse);
        }
      } else {
        debugPrint("internalMakePutRequest " + url + " failure");
        manageFailure(failure, context, statusCode, json);
      }
    } catch(ex) {
      debugPrint("errorTryCatch");
      manageFailure(failure, context, null, json);
    }
  }

  internalMakeDeleteRequest(endpoint, success, failure) async {
    String url = SessionData().serverUrl + endpoint;

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": SessionData().token!,
      "Accept-Language": await getLocale(context)
    };

    debugPrint("internalMakeDeleteRequest "+url);

    try {
      Response response = await http.delete(Uri.parse(url), headers: headers);
      int statusCode = response.statusCode;
      String body = response.body;

      debugPrint("Status: " + statusCode.toString() + "  body: " + body);

      if (statusCode == 200 || statusCode == 201) {
        var bodyResponse = jsonDecode(body);

        if (bodyResponse["status"].toString() == "500") {
          debugPrint("internalMakeDeleteRequest " + url + " invalid token");
          manageFailure(failure, context, 401, null);
        } else {
          debugPrint(
              "internalMakeDeleteRequest " + url + " success. Body: " + body);
          success(bodyResponse);
        }
      } else {
        debugPrint("internalMakeDeleteRequest " + url + " failure");
        manageFailure(failure, context, statusCode, null);
      }
    } catch(ex) {
      debugPrint("internalMakeDeleteRequest " + url + " failure ex "+ex.toString());
      manageFailure(failure, context, null, null);
    }
  }

  makeUploadRequest(context, endpoint, filePath, success, failure) async {
    final postUri = Uri.parse(SessionData().serverUrl + endpoint);
    http.MultipartRequest request = http.MultipartRequest('POST', postUri);
    request.headers.addAll({
      "Authorization": SessionData().token!,
      "Content-Type": "multipart/form-data",
      "Accept-Language": await getLocale(context)
    });

    try {
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath('image', filePath);

      debugPrint("multipartFile postUri: "+postUri.toString()+"  multipartFile.length: "+multipartFile.length.toString());

      request.files.add(multipartFile);

      http.StreamedResponse response = await request.send();
      final json = await response.stream.bytesToString();
      int statusCode = response.statusCode;

      debugPrint("makeUploadRequest completed json: "+json+"   files: " + request.files.length.toString());

      if (statusCode == 200 || statusCode == 201) {
        try {
          success(jsonDecode(json.toString()));
        } catch (ex) {
          manageFailure(failure, context, statusCode, json);
        }
      } else {
        manageFailure(failure, context, statusCode, json);
      }
    } catch(ex) {
      manageFailure(failure, context, 500, json);
    }
  }

  /*uploadFile(File file, String folder) async {
    var uuid = Uuid();
    var urlParts = file.path.split(".");
    var extension = urlParts[urlParts.length - 1];
    var filename = uuid.v1() + "." + extension;

    String uploadedImageUrl = await UploadAWS().uploadImage(file, folder + "/" + filename, filename);

    /*String uploadedImageUrl = await AmazonS3Cognito.upload(
        file.path,
        "swappyverse",
        "eu-central-1:45466813-e5f8-4325-8b7d-929c3fc9c68b",
        folder + "/" + uuid.v1() + "." + extension,
        AwsRegion.EU_CENTRAL_1,
        AwsRegion.EU_CENTRAL_1);*/

    debugPrint("uploadedImageUrl "+uploadedImageUrl);

    return uploadedImageUrl;
  }*/

  manageFailure(callback, context, statusCode, json) async {
    debugPrint("manageFailure " + statusCode.toString() + " json: "+json.toString());

    if(json != null) {
      var response = jsonDecode(json.toString());
      Map<String, dynamic> rawItem = new Map<String, dynamic>.from(response);

      if (rawItem["status"] == "500" || rawItem["message"] == "INVALID TOKEN") {
        debugPrint("manageFailure logout due to invalid token");
        SessionData().logout(context);
        return;
      }
    }

    debugPrint("manageFailure calling failure callback");

    callback(statusCode);
  }

  manageFutureFailure(context, statusCode, json) async {
    debugPrint("manageFutureFailure " + statusCode.toString() + " json: "+json.toString());

    if(statusCode == null) {
      return null;
    }

    if(json != null) {
      var response = jsonDecode(json.toString());
      Map<String, dynamic> rawItem = new Map<String, dynamic>.from(response);

      if (rawItem["status"] == "500" || rawItem["message"] == "INVALID TOKEN") {
        debugPrint("manageFailure logout due to invalid token");
        SessionData().logout(context);
        return null;
      } else if(response["success"] == false) {
        showErrorMessage(context, "generic_error");
      }
    }

    debugPrint("manageFailure calling failure callback");

    return null;
  }

  static showSuccessMessage(context, String textKey) {
    if(context == null) return;

    CustomAlert.show(context,
        title: AppLocalizations.of(context).translate("generic_success"),
        subtitle: AppLocalizations.of(context).translate(textKey),
        style: CustomAlertStyle.success,
        onPress: (bool isConfirm) {
          Navigator.of(context, rootNavigator: true).pop();

          return false;
        });
  }

  static showErrorMessage(context, String textKey) {
    if(context == null) return;

    CustomAlert.show(context,
        confirmButtonColor: Colors.red,
        title: AppLocalizations.of(context).translate("generic_warning"),
        subtitle: AppLocalizations.of(context).translate(textKey),
        style: CustomAlertStyle.error,
        onPress: (bool isConfirm) {
          Navigator.of(context, rootNavigator: true).pop();

          return false;
        });
  }

  static showSadMessage(context, String textKey) {
    if(context == null) return;

    CustomAlert.show(context,
        title: ":-(",
        subtitle: AppLocalizations.of(context).translate(textKey),
        style: CustomAlertStyle.error,
        onPress: (bool isConfirm) {
          Navigator.of(context, rootNavigator: true).pop();

          return false;
        });
  }

  static showConnectionError(context, String textKey) {
    isErrorShowing = true;

    CustomAlert.show(context,
        title: AppLocalizations.of(context).translate("generic_warning"),
        subtitle: AppLocalizations.of(context).translate(textKey),
        style: CustomAlertStyle.error,
        confirmButtonText: "Riprova",
        onPress: (bool isConfirm) {
          isErrorShowing = false;
          Navigator.of(context, rootNavigator: true).pop();

          return false;
        });
  }

  static isOnline() async {
    return true;
  }

  static showSuccessToast(context, String textKey) {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context).translate(textKey),
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 2,
        gravity: ToastGravity.CENTER,
        backgroundColor: Theme.of(context).primaryColor,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static showErrorToast(context, String textKey) {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context).translate(textKey),
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 3,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static showFreeToast(context, String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Constants.SECONDARY_COLOR,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  finalizeLogin(loginResponse) async {
    debugPrint("finalizeLogin refreshToken: "+loginResponse["refreshToken"]);

    Map<String, dynamic> rawResponse = new Map<String, dynamic>.from(loginResponse);
    //var user = new User(rawResponse["user"]);

    //SessionData().user = user;
    SessionData().token = loginResponse["accessToken"];
    //SessionData().userId = SessionData().user.id;

    var preferences = await SharedPreferences.getInstance();
    preferences.setString(Constants.PREFS_REFRESH_TOKEN, loginResponse["refreshToken"]);
    //preferences.setString(Constants.PREFS_TOKEN, SessionData().token);
    //preferences.setString(Constants.PREFS_USERID, SessionData().userId);
    //preferences.setString(Constants.PREFS_USER, jsonEncode(SessionData().user));
  }

  loadLanguage() async {
    /*var preferences = await SharedPreferences.getInstance();
    String lang = preferences.getString(Constants.PREFS_LANGUAGE);

    if(lang == null) {
      SessionData().updateLanguage("it");
      lang = "it";
    }

    SessionData().updateLanguage(lang);

    Locale newLocale = Locale(lang.toLowerCase(), lang.toUpperCase());
    AppLocalizations.of(context).locale = newLocale;
    await AppLocalizations.of(context).load();
    await AppLocalizations.delegate.load(newLocale);
    debugPrint("load new locale "+lang);*/
  }

  subscribePushNotifications(user) {
    if(user == null) return;

    /*OneSignal.shared.sendTag("userId", user.id);
    OneSignal.shared.sendTag("firstName", user.firstName);
    OneSignal.shared.sendTag("lastName", user.lastName);
    OneSignal.shared.sendTag("email", user.email);
    OneSignal.shared.setEmail(email: user.email);
    OneSignal.shared.setExternalUserId(user.id);
    OneSignal.shared.setSubscription(true);

    debugPrint("subscribePushNotifications for userId "+user.id+"  and email "+user.email);*/
  }

  manageApiError(errorCode, context) {
    if(errorCode == 401 || errorCode == 403) {
      SessionData().logout(context);
    }
  }

  static isEmpty(String text) {
    if(text == null || text == "") {
      return true;
    }

    return false;
  }

  getLocale(context) async {
   /* Locale locale = Localizations.localeOf(context);
    return locale.languageCode;*/
    var preferences = await SharedPreferences.getInstance();
   return preferences.getString(Constants.PREFS_LANGUAGE);
  }

  static storeJson(String key, String json) async {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString(key, json);
  }

  static retrieveJson(String key) async {
    var preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

}