import 'dart:async';

import 'package:hot_deals_hungary/models/offer.dart';
import 'package:http/http.dart' as http;

class OfferService {
  Future<List<Offer>> getOffers(String itemCleanName) async {
    var client = http.Client();

    if (itemCleanName == '') {
      return createEmptyOfferList();
    } else {
      var uri =
          Uri.parse('http://95.138.193.102:9988/get_offer/' + itemCleanName);
      var response = await client.get(uri);

      var json = response.body;
      List<Offer> offerList = offerFromJson(json);

      if (offerList.isNotEmpty) {
        return offerList;
      } else {
        return createEmptyOfferList();
      }
    }
  }

  Future<List<Offer>> createEmptyOfferList() {
    var completer = Completer<List<Offer>>();

    List<Offer> emptyOfferList = <Offer>[];

    Offer emptyOffer = Offer(
        id: Id(oid: 'Na.'),
        itemId: 'Na.',
        itemName: 'Nincs akció - változtass a termék nevén',
        itemCleanName: 'Nincs akció',
        price: 0,
        measure: 'Na.',
        salesStart: 'Na.',
        source: 'Na.',
        runDate: 'Na.',
        shopName: 'Na.');

    emptyOfferList.add(emptyOffer);

    completer.complete(emptyOfferList);

    return completer.future;
  }
}
