import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/controllers/cart_controller.dart';
import 'package:hot_deals_hungary/controllers/mongo_dao_controller.dart';
import 'package:hot_deals_hungary/controllers/user_controller.dart';
import 'package:hot_deals_hungary/models/mongo/offer_listener_entity.dart';
import 'package:hot_deals_hungary/models/mongo/offer.dart';
import 'package:hot_deals_hungary/screens/action_listener/search_offer_new_page.dart';
import 'package:hot_deals_hungary/screens/components/custom_page_route.dart';
import 'package:hot_deals_hungary/screens/offer_grid_view/offer_grid_view_main_screen.dart';
import 'package:hot_deals_hungary/services/offer_service.dart';

class OfferListnerItemWidget extends StatefulWidget {
  final OfferListenerEntityOld offerListenerEntity;
  const OfferListnerItemWidget({Key? key, required this.offerListenerEntity})
      : super(key: key);

  @override
  State<OfferListnerItemWidget> createState() => _OfferListnerItemWidgetState();
}

class _OfferListnerItemWidgetState extends State<OfferListnerItemWidget> {
  List<OfferOld>? offerList;
  var isLoaded = false;
  //CartController cartController = Get.find();
  final MongoDaoController _mongoDaoController = Get.find();
  final UserDataController _userDataController = Get.find();

  @override
  void initState() {
    super.initState();

    //getData();
  }

  getData() async {
    offerList = await _mongoDaoController
        .getOffers(widget.offerListenerEntity.itemName);
    if (offerList != null) {
      if (mounted) {
        setState(() {
          isLoaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var colors = [
      Color.fromRGBO(65, 176, 125, 1),
      Color.fromRGBO(241, 77, 43, 1),
      Color.fromRGBO(255, 183, 90, 1),
      Color.fromRGBO(69, 125, 174, 1),
      Color.fromRGBO(83, 120, 252, 1),
    ];

    return GestureDetector(
      onTap: () {
/*
        Navigator.push(
            context,
            CustomPageRoute(
                child: SearchOffersPage(
              searchText: widget.offerListenerEntity.itemName,
            )));

         Navigator.push(context, MaterialPageRoute(builder: (context) => SearchOffersPage(
              searchText: widget.offerListenerEntity.itemName,
            ))).then((value) {
                  setState(() {
                    // refresh state of Page1
                  });
                });*/
      },
      child: Container(
        width: double.infinity,
        //margin: EdgeInsets.only(bottom: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
        decoration: BoxDecoration(
            color: colors[widget.offerListenerEntity.imageColorIndex],
            borderRadius: BorderRadius.circular(16.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    //'id: ${widget.itemId} - ${widget.itemName}',
                    //'🔍 - ${widget.offerListenerEntity.itemName}',
                    widget.offerListenerEntity.itemName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                      splashColor: Colors.white,
                      splashRadius: 20,
                      onPressed: () {
                        _mongoDaoController
                            .modifyOfferListener(
                                widget.offerListenerEntity.id!, 0)
                            .then((value) =>
                                _mongoDaoController.getAllOfferListenerByUser(
                                    _userDataController.user.uid, null))
                            .then((value) => _mongoDaoController.update());
                      },
                      color: Colors.white,
                      icon: Icon(Icons.cancel)),
                )
                /*Text(widget.offerListenerEntity.crDate.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w500))*/
              ],
            ),

            /*ExpansionTile(
              title: Row(
                children: const [
                  /*
                  Image(
                    image: AssetImage('assets/images/sales.png'),
                    height: 35,
                    width: 35,
                  ),*/
                  Padding(
                    padding: EdgeInsets.only(left: 220),
                    child: Text("Akciók:",
                        style: TextStyle(
                            color: Color(0XFF211551),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              children: [
                Visibility(
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      offerList![index].itemName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Ár: ${offerList![index].price} ,-Ft - ${offerList![index].shopName}',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        width: 105,
                                        child: Image.network(
                                            offerList![index].imageUrl),
                                      ),
                                    ],
                                  ),
                                  Material(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    child: InkWell(
                                        borderRadius: BorderRadius.circular(120),
                                        radius: 120,
                                        onTap: () {
                                          cartController
                                              .addOffer(offerList![index]);
                                        },
                                        splashColor: const Color.fromARGB(
                                            255, 173, 173, 173),
                                        highlightColor: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        child: const SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/add_bag_yellow.png'),
                                              width: 60,
                                              height: 60,
                                            ))),
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    height: 30,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}
