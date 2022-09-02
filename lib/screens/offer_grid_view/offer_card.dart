import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/controllers/mongo_dao_controller.dart';
import 'package:hot_deals_hungary/controllers/user_controller.dart';
import 'package:hot_deals_hungary/models/mongo/offer.dart';
import 'package:http/http.dart' as http;

class OfferCardWidget extends StatelessWidget {
  final OfferOld offer;
  OfferCardWidget({Key? key, required this.offer}) : super(key: key);
  final MongoDaoController _mongoDaoController = Get.find();
  final UserDataController _userDataController = Get.find();

  Future<String?> checkImageUrl(String imageUrl) async {
    var _httpClient = http.Client();
    print(imageUrl);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(.5),
                  offset: Offset(3, 2),
                  blurRadius: 7)
            ]),
        child: Column(
          children: [
            SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: FutureBuilder(
                  future: checkImageUrl(
                      'http://95.138.193.102:9988/image_download/${offer.imageUrl}'),
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
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                offer.itemName,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    offer.shopName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    offer.salesStart == 'N.a' ? '' : '${offer.salesStart}-tól',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w300, fontSize: 12),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '${offer.price},-Ft',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Material(
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
                )
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 0),
                    child: Text(
                      offer.measure,
                      style: const TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
