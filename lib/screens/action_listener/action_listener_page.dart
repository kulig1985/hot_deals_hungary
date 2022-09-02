import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/controllers/cart_controller.dart';
import 'package:hot_deals_hungary/controllers/mongo_dao_controller.dart';
import 'package:hot_deals_hungary/controllers/user_controller.dart';
import 'package:hot_deals_hungary/models/mongo/offer_creation_done.dart';
import 'package:hot_deals_hungary/models/mongo/offer_listener_entity.dart';
import 'package:hot_deals_hungary/screens/action_listener/search_offer_new_page.dart';
import 'package:hot_deals_hungary/screens/components/bottom_bar.dart';
import 'package:hot_deals_hungary/screens/components/custom_app_bar.dart';
import 'package:hot_deals_hungary/screens/components/custom_page_route.dart';
import 'package:hot_deals_hungary/screens/components/header_widget.dart';
import 'package:hot_deals_hungary/screens/action_listener/offer_listener_item_widget.dart';
import 'package:hot_deals_hungary/screens/offer_grid_view/offer_grid_view_main_screen.dart';
import 'package:hot_deals_hungary/size_config.dart';
import 'package:path/path.dart';

class ActionListenerPage extends StatefulWidget {
  const ActionListenerPage({Key? key}) : super(key: key);

  @override
  State<ActionListenerPage> createState() => _ActionListenerPageState();
}

class _ActionListenerPageState extends State<ActionListenerPage>
    with RouteAware {
  CartController _cartController = Get.put(CartController());
  TextEditingController newOfferAddController = TextEditingController();
  final MongoDaoController _mongoDaoController = Get.find();
  final UserDataController _userDataController = Get.find();
  //late Future<List<OfferListenerEntity>> offerListenerList;

  @override
  void initState() {
    // TODO: implement initState

    /*_mongoDaoController
        .getAllOfferListenerByUser(_userDataController.user.uid, null)
        .then((value) => _mongoDaoController.update());
    _mongoDaoController.getAllShoppingListByUser(_userDataController.user);
*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    Future<String?> openOfferListenerDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Akció figyelő létrehozása!"),
              content: TextField(
                controller: newOfferAddController,
                autofocus: true,
                autocorrect: false,
                decoration:
                    const InputDecoration(hintText: "pld. Tej, Kenyér..."),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      /*
                      final navigator = Navigator.of(context);
                      if (newOfferAddController.text != "") {
                        OfferCreationDoneEntity offerCreationDoneEntity =
                            await _mongoDaoController.createOfferListener(
                                newOfferAddController.text,
                                _userDataController.user.uid);

                        print(
                            'New Item created id: ${offerCreationDoneEntity.id}');

                        setState(() {
                          offerListenerList =
                              _mongoDaoController.getAllOfferListenerByUser(
                                  _userDataController.user.uid,
                                  offerCreationDoneEntity.id);
                        });
                        newOfferAddController.clear();

                        OfferListenerEntity? offerList;

                        offerListenerList
                            .then((value) => value)
                            .then((value) => value.where((element) =>
                                element.id!.oid == offerCreationDoneEntity.id))
                            .then((value) => navigator.push(MaterialPageRoute(
                                builder: ((context) => OfferGridViewMainScreen(
                                    offerListenerEntity: value.first)))));

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OfferGridViewMainScreen(
                                    offerListenerEntity:
                                        _mongoDaoController.justAddedOffer!)));

                      }
                      navigator.pop(newOfferAddController.text);

                      navigator.push(MaterialPageRoute(
                          builder: (context) => OfferGridViewMainScreen(
                              offerListenerEntity:
                                  _mongoDaoController.justAddedOffer!)));
                      //OfferListnerItemWidget(offerListenerEntity: data[index]);
                      //Navigator.of(context).pop(newOfferAddController.text);
                      */
                    },
                    child: const Text("Mentés")),
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context, "Mégsem"), // passing false
                  child: const Text('Mégsem'),
                )
              ],
            ));

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(
          titleName: 'Akció figyelő',
          backButtonchooser: false,
        ),
      ),
      body: SafeArea(
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            color: const Color.fromRGBO(43, 47, 58, 1),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GetBuilder<MongoDaoController>(
                      builder: (_) => Visibility(
                        visible:
                            _mongoDaoController.offerListenerEntityListLength ==
                                0,
                        child: Container(
                          margin: EdgeInsets.only(left: 15),
                          width: 280,
                          child: Column(
                            children: const [
                              Text(
                                  'Üres az akció figyelőd. Keress akciókat és rakj rájuk figyelést!',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            CustomPageRoute(child: SearchOffersPage()));
                      },
                      child: Hero(
                        tag: 'searchHero',
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          child: Card(
                            color: Color.fromRGBO(54, 60, 73, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 4,
                            child: Container(
                              height: 120,
                              width: 188,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Expanded(
                                    child: SizedBox(
                                      width: 120,
                                      height: 40,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 15, top: 15, bottom: 5),
                                        child: Text(
                                          "Új akciók keresése",
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 15,
                                      ),
                                      child: Icon(
                                        Icons.search,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GetBuilder<MongoDaoController>(
                      builder: (_) => Visibility(
                        visible:
                            _mongoDaoController.offerListenerEntityListLength !=
                                0,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 15, bottom: 20),
                          child: Text(
                            "Mentett termék akciók",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: GetBuilder<MongoDaoController>(
                      builder: (_) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: 110.0,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10),
                            itemCount: _mongoDaoController
                                .offerListenerEntityListLength,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: Key(_mongoDaoController
                                    .offerListenerEntityList[index].id.oid),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  _mongoDaoController
                                      .modifyOfferListener(
                                          _mongoDaoController
                                              .offerListenerEntityList[index]
                                              .id,
                                          0)
                                      .then((value) => setState(() {
                                            _mongoDaoController
                                                .removeElement(index);
                                          }));
                                },
                                background: Container(
                                  margin: const EdgeInsets.only(bottom: 5.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFE6E6),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      const Spacer(),
                                      SvgPicture.asset(
                                          "assets/images/Trash.svg"),
                                    ],
                                  ),
                                ),
                                child: OfferListnerItemWidget(
                                    offerListenerEntity: _mongoDaoController
                                        .offerListenerEntityList[index]),
                              );
                            }),
                      ),
                    )),
                  ],
                ),
              ],
            )),
      ),
      /*floatingActionButton: FloatingActionButton.extended(
        label: const Text('Keress akciókat!'),
        onPressed: openOfferListenerDialog,
        backgroundColor: Color.fromRGBO(54, 60, 63, 1),
        icon: const Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,*/
      //bottomNavigationBar: BottomBar(),
    );
  }
}
