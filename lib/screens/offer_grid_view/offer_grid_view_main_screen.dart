import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/controllers/cart_controller.dart';
import 'package:hot_deals_hungary/controllers/mongo_dao_controller.dart';
import 'package:hot_deals_hungary/models/mongo/offer_listener_entity.dart';
import 'package:hot_deals_hungary/models/mongo/offer.dart';
import 'package:hot_deals_hungary/screens/components/bottom_bar.dart';
import 'package:hot_deals_hungary/screens/components/custom_app_bar.dart';
import 'package:hot_deals_hungary/screens/components/header_widget.dart';
import 'package:hot_deals_hungary/screens/offer_grid_view/offer_card.dart';
import 'package:hot_deals_hungary/screens/offer_grid_view/offer_elevated_card.dart';

class OfferGridViewMainScreen extends StatefulWidget {
  final OfferListenerEntityOld offerListenerEntity;
  const OfferGridViewMainScreen({Key? key, required this.offerListenerEntity})
      : super(key: key);

  @override
  State<OfferGridViewMainScreen> createState() =>
      _OfferGridViewMainScreenState();
}

class _OfferGridViewMainScreenState extends State<OfferGridViewMainScreen> {
  final MongoDaoController _mongoDaoController = Get.find();
  final CartController _cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(
          titleName: 'Akciós termékek',
          backButtonchooser: true,
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          color: const Color(0XFFF6F6F6),
          child: Stack(
            children: [
              Column(
                children: [
                  /*HeaderWidget(
                    titleName: 'Akciós termékek',
                    backButtonchooser: true,
                  ),*/
                  const Divider(
                    color: Colors.black12,
                  ),
                  Expanded(
                    child: conditionalGridViewBuilder(),
                  )
                ],
              ),
            ],
          ),
        ),
      ),

      //bottomNavigationBar: const BottomBar(),
    );
  }

  Widget conditionalGridViewBuilder() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0),
      child: FutureBuilder(
          initialData: [],
          future: _mongoDaoController
              .getOffers(widget.offerListenerEntity.itemName),
          builder: (context, snapshot) {
            var data = (snapshot.data as List<dynamic>).toList();
            if (data.isNotEmpty) {
              print('data not empty:${data.length}');
              print(snapshot.connectionState);
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 240.0,
                  ),
                  itemCount: data.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return OfferElevatedCardWidget(offer: data[index]);
                  });
            } else {
              print('if data.length:${data.length}');
              print(snapshot.connectionState);
              if (snapshot.connectionState != ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 200),
                  child: Text(
                    "Nem találtam akciókat! 😿",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }
          }),
    );
  }
}
