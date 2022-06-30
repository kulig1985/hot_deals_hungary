import 'package:flutter/material.dart';
import 'package:hot_deals_hungary/models/offer.dart';
import 'package:hot_deals_hungary/services/offer_service.dart';

class ShopingItem extends StatefulWidget {
  final String itemName;
  final int itemId;
  const ShopingItem({Key? key, required this.itemName, required this.itemId})
      : super(key: key);

  @override
  State<ShopingItem> createState() => _ShopingItemState();
}

class _ShopingItemState extends State<ShopingItem> {
  List<Offer>? offerList;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    offerList = await OfferService().getOffers(widget.itemName);
    if (offerList != null) {
      if (mounted) {
        setState(() {
          isLoaded = true;
        });
      }
    }
  }
  /*
  Future<List<Widget>> data() async {
    List<Widget> list = [];

    offerList = await OfferService().getOffers('xxx');

    if (offerList != null) {
      setState(() {
        isLoaded = true;
        print('isloaded!');
      });
    }

    for (var i = 0; i < offerList!.length; i++) {
      list.add(Text(
          'Termék: ${offerList![i].itemName} - Ár ${offerList![i].price} ,-Ft - Bolt: ${offerList![i].shopName}'));
    }
    return list;
  }
  */

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            //'id: ${widget.itemId} - ${widget.itemName}',
            '✓ - ${widget.itemName}',
            style: const TextStyle(
                color: Color(0XFF211551),
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          /*Visibility(
            visible: isLoaded,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: ListView.builder(
              //scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: offerList?.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              offerList![index].itemName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Ár: ${offerList![index].price} ,-Ft - ${offerList![index].shopName}',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            /*Text(
                              'Bolt: ${offerList![index].shopName}',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            )*/
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )*/
        ],
      ),
    );
  }
}
