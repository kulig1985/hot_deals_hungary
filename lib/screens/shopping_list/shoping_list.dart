import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/controllers/cart_controller.dart';
import 'package:hot_deals_hungary/controllers/mongo_dao_controller.dart';
import 'package:hot_deals_hungary/models/mongo/offer.dart';
import 'package:hot_deals_hungary/screens/components/bottom_bar.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({Key? key}) : super(key: key);

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final CartController _cartController = Get.find();
  final MongoDaoController _mongoDaoController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          title: const Text("Bevásárló lista",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 63, 63, 63),
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: const Color.fromRGBO(247, 196, 105, 1),
          leading: SizedBox(
            height: 30,
            width: 30,
            child: IconButton(
              icon: SvgPicture.asset(
                "assets/images/back_icon.svg",
                height: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          actions: [],
        ),
        body: SafeArea(
          child: Stack(children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _cartController.offers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CartOfferCard(
                            cartController: _cartController,
                            offer: _cartController.offers.keys.toList()[index],
                            quantity:
                                _cartController.offers.values.toList()[index],
                            index: index);
                      },
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CartTotal())
                ],
              ),
            )
          ]),
        ),
        bottomNavigationBar: const BottomBar(),
      ),
    );
  }
}

class CartOfferCard extends StatelessWidget {
  final CartController cartController;
  final OfferOld offer;
  final int quantity;
  final int index;
  const CartOfferCard(
      {Key? key,
      required this.cartController,
      required this.offer,
      required this.quantity,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.all(2),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${offer.itemName} - ${offer.shopName}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${offer.price},-Ft',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                cartController.removeOffer(offer);
              },
              icon: Icon(Icons.remove_circle)),
          Text(
            quantity.toString(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          IconButton(
              onPressed: () {
                cartController.addOffer(offer);
              },
              icon: const Icon(Icons.add_circle))
        ],
      ),
    );
  }
}

class CartTotal extends StatelessWidget {
  final CartController cartController = Get.find();
  CartTotal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 75),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Összesen",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          Text('${cartController.showTotal()},-Ft',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ))
        ]),
      ),
    );
  }
}
