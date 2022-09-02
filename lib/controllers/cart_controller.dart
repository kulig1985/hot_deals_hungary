import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/models/mongo/offer.dart';
import 'package:hot_deals_hungary/services/database_helper.dart';

class CartController extends GetxController {
  var _offers = {}.obs;
  DataBaseHelper _dataBaseHelper = DataBaseHelper();

  void addOffer(OfferOld offer) {
    print(offer);

    if (_offers.containsKey(offer)) {
      _offers[offer] += 1;
    } else {
      _offers[offer] = 1;
    }
  }

  get offers => _offers;

  get length => _offers.length;

  void removeOffer(OfferOld offer) {
    if (_offers.containsKey(offer) && _offers[offer] == 1) {
      _offers.removeWhere((key, value) => key == offer);
    } else {
      _offers[offer] -= 1;
    }
  }

  get offerSubTotal =>
      _offers.entries.map((offer) => offer.key.price * offer.value).toList();

  List showOfferSubTotal() {
    if (_offers.isNotEmpty) {
      return _offers.entries
          .map((offer) => offer.key.price * offer.value)
          .toList();
    } else {
      return [];
    }
  }

  String showTotal() {
    print(_offers);
    if (_offers.isNotEmpty) {
      return _offers.entries
          .map((offer) => offer.key.price * offer.value)
          .toList()
          .reduce((value, element) => value + element)
          .toString();
    } else {
      return "0";
    }
  }

  get total => _offers.entries
      .map((offer) => offer.key.price * offer.value)
      .toList()
      .reduce((value, element) => value + element)
      .toString();
}
