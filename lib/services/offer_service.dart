import 'dart:async';

import 'package:hot_deals_hungary/models/mongo/offer.dart';
import 'package:http/http.dart' as http;

class OfferService {
  Future<List<OfferOld>> getOffers(String itemCleanName) async {
    var client = http.Client();

    if (itemCleanName == '') {
      return createEmptyOfferList();
    } else {
      var uri =
          Uri.parse('http://95.138.193.102:9988/get_offer/' + itemCleanName);
      var response = await client.get(uri);

      var json = response.body;
      List<OfferOld> offerList = offerOldFromJson(json);

      if (offerList.isNotEmpty) {
        return offerList;
      } else {
        return createEmptyOfferList();
      }
    }
  }

  Future<List<OfferOld>> createEmptyOfferList() {
    var completer = Completer<List<OfferOld>>();

    List<OfferOld> emptyOfferList = <OfferOld>[];

    OfferOld emptyOffer = OfferOld(
        id: IdOf(oid: 'Na.'),
        itemId: 'Na.',
        itemName: 'Nincs akció - változtass a termék nevén',
        itemCleanName: 'Nincs akció',
        imageUrl: 'https://picsum.photos/60',
        price: 0,
        measure: 'Na.',
        salesStart: 'Na.',
        source: 'Na.',
        runDate: 'Na.',
        shopName: 'Na.',
        timeKey: 'Na.',
        insertType: 'Na.');

    emptyOfferList.add(emptyOffer);

    completer.complete(emptyOfferList);

    return completer.future;
  }
}
