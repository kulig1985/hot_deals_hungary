import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/controllers/mongo_dao_controller.dart';
import 'package:hot_deals_hungary/controllers/user_controller.dart';
import 'package:hot_deals_hungary/models/mongo/offer.dart';
import 'package:http/http.dart' as http;

class OfferElevatedCardWidget extends StatelessWidget {
  final OfferOld offer;
  OfferElevatedCardWidget({Key? key, required this.offer}) : super(key: key);
  final MongoDaoController _mongoDaoController = Get.find();
  final UserDataController _userDataController = Get.find();

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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        child: Column(children: [
          const SizedBox(
            height: 15,
          ),
          FutureBuilder(
            future: checkImageUrl(offer.imageUrl),
            builder: ((context, snapshot) {
              if (snapshot.data != null) {
                return FadeInImage(
                  width: 85,
                  height: 85,
                  placeholder: AssetImage('assets/images/wait.png'),
                  image: NetworkImage(offer.imageUrl),
                );
              } else {
                return const Image(
                  image: AssetImage('assets/images/image_not_found.png'),
                  width: 80,
                  height: 80,
                );
              }
            }),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 35,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: AutoSizeText(
                offer.itemName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                maxLines: 2,
              ),
            ),
          ),
          SizedBox(
            height: 20,
            child: Text(
              offer.shopName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  '${offer.price},-Ft',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  child: IconButton(
                      splashRadius: 60,
                      icon: Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        _mongoDaoController.addOfferToShoppingList(
                            offer, 1, _userDataController.user);
                        //_mongoDaoController.update();
                      }),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
