import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:highest_dimension/logic/firestore_handler.dart';
import 'package:highest_dimension/model/app_data_settings.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../quote.dart';

class AppDataProvider extends ChangeNotifier {
  final FirestoreHandler _firestoreHandler = FirestoreHandler();
  late List<Quote> quoteList;
  late AppDataSettings appDataSettings;
  late SharedPreferences prefs;

  getData() async {
    quoteList = await _firestoreHandler.getQuotes();

    await getAppData();
    notifyListeners();
  }

  getAppData() async {
    prefs = await SharedPreferences.getInstance();
    String? appDataString = prefs.getString(SharedPrefNames.appDataSettings.name);
    DateFormat df = DateFormat('dd/MM/yyyy');
    var dateNow = DateTime.now();
    var dateString = df.format(dateNow);
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

  void setAdvancedSettings(bool value) async {
    appDataSettings.showAdvancedSettings = value;
    await prefs.setString(SharedPrefNames.appDataSettings.name, jsonEncode(appDataSettings));
    notifyListeners();
  }
}
