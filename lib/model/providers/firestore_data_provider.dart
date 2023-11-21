import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:highest_dimension/logic/firestore_handler.dart';
import 'package:highest_dimension/model/app_data_settings.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../quote.dart';

class FirestoreDataProvider extends ChangeNotifier {
  final FirestoreHandler _firestoreHandler = FirestoreHandler();
  late List<Quote> quoteList;
  late AppDataSettings appDataSettings;
  late SharedPreferences prefs;

  getData() async {
    quoteList = await _firestoreHandler.getQuotes();
    print('hellow');

    await getAppData();
    notifyListeners();
  }

  getAppData() async {
    print('hellow2');
    prefs = await SharedPreferences.getInstance();
    print('dateNow1');
    String? appDataString = prefs.getString(SharedPrefNames.appDataSettings.name);
    print('dateNow2');
    DateFormat df = DateFormat('dd/MM/yyyy');
    print('dateNow3');
    var dateNow = DateTime.now();
    var dateString = df.format(dateNow);
    print(dateString);
    if (appDataString != null && appDataString.isNotEmpty) {
      // Not first time
      Map<String, dynamic> appDataJson = jsonDecode(appDataString);
      appDataSettings = AppDataSettings.fromJson(appDataJson);
      if (appDataSettings.lastOpenDate != dateString) {}
    } else {
      // First time
      appDataSettings = AppDataSettings(dateNow.millisecondsSinceEpoch, dateString);
      prefs.setString(SharedPrefNames.appDataSettings.name, jsonEncode(appDataSettings));
    }
  }

  Future<bool> addQuote(Quote quote, void Function(String) errorCallback) async {
    var result = await _firestoreHandler.addQuote(quote, errorCallback);

    if (result) {
      getData();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteQuote(String id, void Function(String) errorCallback) async {
    var result = await _firestoreHandler.deleteQuote(id, errorCallback);

    if (result) {
      getData();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
