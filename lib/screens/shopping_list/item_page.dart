import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/controllers/main_dao_controller.dart';
import 'package:hot_deals_hungary/controllers/user_controller.dart';
import 'package:hot_deals_hungary/models/mongo/shopping_list_complex_model.dart';
import 'package:hot_deals_hungary/screens/components/custom_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:pinch_zoom/pinch_zoom.dart';

class ItemPageScreen extends StatefulWidget {
  final Offer offer;
  final int index;
  const ItemPageScreen({Key? key, required this.offer, required this.index})
      : super(key: key);

  @override
  State<ItemPageScreen> createState() => _ItemPageScreenState();
}

Future<String?> checkImageUrl(String imageUrl) async {
  var _httpClient = http.Client();
  var uri = Uri.parse(imageUrl);

  try {
    var response = await _httpClient.get(uri);

    if (response.statusCode == 200) {
      return imageUrl;
    } else {
      return null;
    }
  } catch (_) {
    return null;
  }
}

class _ItemPageScreenState extends State<ItemPageScreen> {
  final MainDaoController _mainDaoController = Get.find();
  final UserDataController _userDataController = Get.find();

  @override
  Widget build(BuildContext context) {
    Offer offer = widget.offer;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(
          titleName: "Termék",
          backButtonchooser: true,
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(37, 37, 37, 1),
        child: SafeArea(
            child: Container(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3,
                width: double.infinity,
                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                color: Colors.white,
                child: FutureBuilder(
                  future: checkImageUrl(
                      'http://95.138.193.102:9988/image_download/${offer.imageUrl}'),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data != null) {
                        return FadeInImage(
                          width: 100,
                          height: 100,
                          placeholder:
                              const AssetImage('assets/images/wait.png'),
                          image: NetworkImage(
                              'http://95.138.193.102:9988/image_download/${offer.imageUrl}'),
                        );
                      } else {
                        return const Image(
                          image:
                              AssetImage('assets/images/image_not_found.png'),
                          width: 100,
                          height: 100,
                        );
                      }
                    } else {
                      return const Image(
                        image: AssetImage('assets/images/image_not_found.png'),
                        width: 100,
                        height: 100,
                      );
                    }
                  }),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                height: MediaQuery.of(context).size.height / 3,
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.itemName,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${offer.price} Ft",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Mennyiség: ${offer.measure}",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      offer.salesStart == 'N.a'
                          ? 'Akció kezdete: Nincs információ'
                          : 'Akció kezdete:${offer.salesStart}',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      "Forrás: ${offer.source}",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      "Üzlet: ${offer.shopName}",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                    /*Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(37, 37, 37, 1),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                splashRadius: 60,
                                icon: const FaIcon(
                                  FontAwesomeIcons.cartShopping,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    //listVisible = false;
                                  });

                                  _mainDaoController
                                      .addItemToShoppingList(
                                          _mainDaoController
                                              .choosenShoppingList
                                              .value
                                              .offerModelList[widget.index!]
                                              .offerListenerEntity
                                              .id,
                                          offer)
                                      .then((value) => _mainDaoController
                                          .getAllComplexShoppingListByUser(
                                              _userDataController.user,
                                              _mainDaoController
                                                  .choosenShoppingList
                                                  .value
                                                  .id
                                                  .oid,
                                              true,
                                              false,
                                              true))
                                      .then((value) => _mainDaoController
                                          .selectShoppingList(_mainDaoController
                                              .oldShoppingListoid!))
                                      .then((value) => Navigator.pop(context));
                                }),
                            Container(
                              width: 70,
                              child: const Text(
                                "Kiválaszt!",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    )*/
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
