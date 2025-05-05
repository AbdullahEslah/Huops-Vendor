import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huops/models/user.dart';
import 'package:huops/requests/user.request.dart';
import 'package:huops/view_models/base.view_model.dart';
import 'package:http/http.dart' as http;

class AssignOrderViewModel extends MyBaseViewModel {
  //
  UserRequest userRequest = UserRequest();
  List<User> drivers = [];
  List<User> unfilteredDrivers = [];
  int? selectedDriverId;
  String? currentCountry;
  String? countryCode;
  void initialise() {
    fetchDrivers();
    getCountryFromIP();
  }

  Future<void> getCountryFromIP() async {
    try {
      final response = await http.get(Uri.parse('http://ip-api.com/json/'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        currentCountry = data[
            'country']; // ممكن تستخدم كمان data['countryCode'] لو محتاج الكود زي "EG"

        getCurrentCountryCode(currentCountry ?? "");
        debugPrint(currentCountry);
      } else {
        print("HTTP error: ${response.statusCode}");
      }
    } catch (e) {
      print("Failed to get country from IP: $e");
    }
  }

  getCurrentCountryCode(String currentCountry) {
    switch (currentCountry) {
      case "Pakistan":
        countryCode = "PK";
        break;

      case "Egypt":
        countryCode = "EG";
        break;

      case "Russia":
        countryCode = "RU";
        break;

      case "Italy":
        countryCode = "IT";
        break;

      case "France":
        countryCode = "FR";
        break;

      case "Spain":
        countryCode = "ES";
        break;

      case "Germany":
        countryCode = "DE";
        break;

      case "Portugal":
        countryCode = "PT";
        break;
    }
  }

  //
  fetchDrivers() async {
    setBusy(true);
    // try {
    drivers = await userRequest
        .getUsers(
      role: "driver",
    )
        .then((list) {
      return list.where((e) => e.countryCode == countryCode).toList();
    });

    unfilteredDrivers = drivers;

    // } catch (error) {
    //   print("Users Error ==> $error");
    //   setError(error);
    // }

    clearErrors();
    setBusy(false);
  }

  filterDrivers(String keyword) {
    drivers = unfilteredDrivers
        .where((e) => e.countryCode == countryCode)
        .where((e) => e.name.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
    notifyListeners();
  }

  //
  changeSelectedDriver(int? driverId) {
    selectedDriverId = driverId;
    notifyListeners();
  }
}
