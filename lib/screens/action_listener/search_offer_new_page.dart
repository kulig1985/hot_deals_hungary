import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/controllers/main_dao_controller.dart';
import 'package:hot_deals_hungary/controllers/mongo_dao_controller.dart';
import 'package:hot_deals_hungary/controllers/user_controller.dart';
import 'package:hot_deals_hungary/models/mongo/offer.dart';
import 'package:hot_deals_hungary/models/mongo/offer_creation_done.dart';
import 'package:hot_deals_hungary/models/mongo/shopping_list_complex_model.dart';
import 'package:hot_deals_hungary/screens/components/custom_app_bar.dart';
import 'package:hot_deals_hungary/screens/shopping_list/item_page.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SearchOffersPage extends StatefulWidget {
  final int? index;
  final String? itemCleanName;
  const SearchOffersPage({Key? key, this.index, this.itemCleanName})
      : super(key: key);

  @override
  State<SearchOffersPage> createState() => _SearchOffersPageState();
}

class _SearchOffersPageState extends State<SearchOffersPage> {
  TextEditingController offerSearchTextController = TextEditingController();
  final MongoDaoController _mongoDaoController = Get.find();
  final MainDaoController _mainDaoController = Get.find();
  final UserDataController _userDataController = Get.find();
  Future<List<OfferOld>>? offerList;
  var messageVisible = false;
  var opactityVisible = false;
  var saveButtonVisible = true;
  var listVisible = true;

  @override
  void initState() {
    // TODO: implement initState

    _mongoDaoController.resetOfferListSize();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    /*if (widget.searchText != null) {
      offerSearchTextController.text = widget.searchText!;
      saveButtonVisible = false;
      setState(() {
        offerList =
            _mongoDaoController.getOffers(offerSearchTextController.text);
      });
    }*/

    final snackBar = SnackBar(
      content: const Text('Yay! A SnackBar!'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(
          titleName: 'Akciós termékek',
          backButtonchooser: true,
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(37, 37, 37, 1),
        child: SafeArea(
            child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          color: const Color.fromRGBO(37, 37, 37, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                maintainAnimation: true,
                maintainState: true,
                visible: messageVisible,
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                  height: 38.0,
                  color: Color.fromRGBO(65, 176, 125, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "${offerSearchTextController.text} mentve az akció figyelőbe!",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              messageVisible = false;
                            });
                          },
                          icon: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
              ),
              Hero(
                tag: 'searchHero',
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 10),
                    height: 20,
                    child: Visibility(
                      visible: listVisible,
                      child: Text(
                        "${_mainDaoController.choosenShoppingList.value.offerModelList[widget.index!].offers.length.toString()}db akciós ${widget.itemCleanName} találat",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    /*Text(
                        widget.searchText!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ) TextField(
                        style: const TextStyle(color: Colors.white),
                        //autofocus: true,
                        controller: offerSearchTextController,
                        onChanged: (value) {
                          print(value);
                          if (value != '' && value.length >= 3) {
                            setState(() {
                              offerList = _mongoDaoController
                                  .getOffers(offerSearchTextController.text);
                            });
                          }
                        },
                        /*onEditingComplete: () {
                          print('editing completed!');
                        },
                        onSubmitted: (value) {
                          print(offerSearchTextController.text);
                        },*/
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.bottom,
                        autocorrect: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText:
                                "Add meg milyen akciót keresel, pld: Tej, Vaj, Sör",
                            fillColor: Color.fromRGBO(54, 60, 73, 1))),*/
                  ),
                ),
              ),
              GetBuilder<MongoDaoController>(
                builder: (_) => Container(
                  margin: const EdgeInsets.only(top: 0, left: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      /*Text(
                        "${_mainDaoController.choosenShoppingList.value.offerModelList[widget.index!].offers.length.toString()} találat",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Visibility(
                        visible: saveButtonVisible,
                        child: Material(
                          clipBehavior: Clip.antiAlias,
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () async {
                              //OfferCreationDoneEntity offerCreationDoneEntity = await
                              _mongoDaoController
                                  .createOfferListener(
                                      offerSearchTextController.text,
                                      _userDataController.user.uid)
                                  .then((value) => _mongoDaoController
                                      .getAllOfferListenerByUser(
                                          _userDataController.user.uid, null))
                                  .then((value) => _mongoDaoController.update())
                                  .then((value) => setState(() {
                                        messageVisible = true;
                                      }));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 15, left: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 5),
                                    child: const Text("Mentés figyelőbe",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  const Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: !listVisible,
                  child: Container(
                    margin: EdgeInsets.only(top: 150),
                    child: Center(
                        child: Column(
                      children: const [
                        CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            "Egy pillanat...",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )),
                  )),
              Visibility(
                visible: listVisible,
                child: Expanded(
                    child: ListView.builder(
                        itemCount: _mainDaoController.choosenShoppingList.value
                            .offerModelList[widget.index!].offers.length,
                        itemBuilder: (BuildContext ctx, index) {
                          Offer offer = _mainDaoController
                              .choosenShoppingList
                              .value
                              .offerModelList[widget.index!]
                              .offers[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 70),
                            child: SlideAnimation(
                              verticalOffset: 20.0,
                              child: FadeInAnimation(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ItemPageScreen(
                                                  offer: offer,
                                                  index: index,
                                                )));
                                  },
                                  child: Container(
                                    height: 120,
                                    margin: const EdgeInsets.only(
                                        bottom: 2, left: 5, right: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 1,
                                            color: offer.isSelectedFlag == 0
                                                ? Colors.transparent
                                                : const Color.fromRGBO(
                                                    104, 237, 173, 1)),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: FutureBuilder(
                                            future: checkImageUrl(
                                                'http://95.138.193.102:9988/image_download/${offer.imageUrl}'),
                                            builder: ((context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                if (snapshot.data != null) {
                                                  return FadeInImage(
                                                    width: 100,
                                                    height: 100,
                                                    placeholder: const AssetImage(
                                                        'assets/images/wait.png'),
                                                    image: NetworkImage(
                                                        'http://95.138.193.102:9988/image_download/${offer.imageUrl}'),
                                                  );
                                                } else {
                                                  return const Image(
                                                    image: AssetImage(
                                                        'assets/images/image_not_found.png'),
                                                    width: 100,
                                                    height: 100,
                                                  );
                                                }
                                              } else {
                                                return const Image(
                                                  image: AssetImage(
                                                      'assets/images/image_not_found.png'),
                                                  width: 100,
                                                  height: 100,
                                                );
                                              }
                                            }),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(left: 20),
                                            width: 200,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${offer.price},-Ft',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 200,
                                                  child: AutoSizeText(
                                                    offer.itemName,
                                                    maxLines: 3,
                                                  ),
                                                ),
                                                Text(offer.shopName),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: offer.isSelectedFlag == 0,
                                          child: Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                      splashRadius: 60,
                                                      icon: const FaIcon(
                                                        FontAwesomeIcons
                                                            .cartShopping,
                                                        color: Colors.grey,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          listVisible = false;
                                                        });

                                                        _mainDaoController
                                                            .addItemToShoppingList(
                                                                _mainDaoController
                                                                    .choosenShoppingList
                                                                    .value
                                                                    .offerModelList[
                                                                        widget
                                                                            .index!]
                                                                    .offerListenerEntity
                                                                    .id,
                                                                offer)
                                                            .then((value) => _mainDaoController
                                                                .getAllComplexShoppingListByUser(
                                                                    _userDataController
                                                                        .user,
                                                                    _mainDaoController
                                                                        .choosenShoppingList
                                                                        .value
                                                                        .id
                                                                        .oid,
                                                                    true,
                                                                    false,
                                                                    true))
                                                            .then((value) =>
                                                                _mainDaoController
                                                                    .selectShoppingList(
                                                                        _mainDaoController
                                                                            .oldShoppingListoid!))
                                                            .then((value) =>
                                                                Navigator.pop(
                                                                    context));
                                                      }),
                                                  Container(
                                                    width: 60,
                                                    child: const Text(
                                                      "Kiválaszt!",
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w200),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        })

                    /*FutureBuilder(
                      initialData: [],
                      future: offerList,
                      builder: (context, snapshot) {
                        var data = (snapshot.data as List<dynamic>).toList();
                        if (data.isNotEmpty) {
                          print('data not empty:${data.length}');
                          print(snapshot.connectionState);
                          return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return Container(
                                  height: 90,
                                  margin: const EdgeInsets.only(
                                      bottom: 10, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16.0)),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      FutureBuilder(
                                        future: checkImageUrl(
                                            'http://95.138.193.102:9988/image_download/${data[index].imageUrl}'),
                                        builder: ((context, snapshot) {
                                          if (snapshot.data != null) {
                                            return FadeInImage(
                                              width: 70,
                                              height: 70,
                                              placeholder: const AssetImage(
                                                  'assets/images/wait.png'),
                                              image: NetworkImage(
                                                  'http://95.138.193.102:9988/image_download/${data[index].imageUrl}'),
                                            );
                                          } else {
                                            return const Image(
                                              image: AssetImage(
                                                  'assets/images/image_not_found.png'),
                                              width: 75,
                                              height: 75,
                                            );
                                          }
                                        }),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${data[index].price},-Ft',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: AutoSizeText(
                                              data[index].itemName,
                                              maxLines: 2,
                                            ),
                                          ),
                                          Text(data[index].shopName),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 50),
                                        child: Material(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white,
                                          child: IconButton(
                                              splashRadius: 60,
                                              icon: Icon(Icons.add_box_outlined),
                                              onPressed: () {
                                                _mongoDaoController
                                                    .addOfferToShoppingList(
                                                        data[index],
                                                        1,
                                                        _userDataController.user);
                                                //_mongoDaoController.update();
                                              }),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        } else {
                          print('if data.length: ${data.length}');
                          print(snapshot.connectionState);
                          if (snapshot.connectionState != ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 200),
                              child: Center(
                                child: SizedBox(
                                  width: 200,
                                  child: Text(
                                    "Nem találtam akciókat! Módosítsd a kereső szót! 😿",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        }
                      })*/
                    ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
