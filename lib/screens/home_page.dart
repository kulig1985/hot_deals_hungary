import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hot_deals_hungary/models/offer_listener_item.dart';
import 'package:hot_deals_hungary/screens/new_item.dart';
import 'package:hot_deals_hungary/services/database_helper.dart';
import 'package:hot_deals_hungary/shoping_item.dart';
import 'package:hot_deals_hungary/size_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePagetState();
}

class _HomePagetState extends State<HomePage> {
  DataBaseHelper _dataBaseHelper = DataBaseHelper();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    Future<List<OfferListenerItem>> offerListenerItemList =
        _dataBaseHelper.getAllItem();

    void removeElement(int index) {
      print('removeElement invoked!');
      offerListenerItemList.then(
        (value) {
          print("value: " + value.toString());
          value.removeAt(index);
        },
      );
    }

    ;

    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 100,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 249, 249, 249),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/images/checklist.svg"),
                ),
              ),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NewItem(item: null)))
                        .then((value) => setState(
                              () {},
                            ));
                  },
                  icon: const Image(
                    image: AssetImage('assets/images/cart_ok.png'),
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            color: const Color(0XFFF6F6F6),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ignore: avoid_unnecessary_containers
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: const Image(
                          image: AssetImage('assets/images/logo.png'),
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                          padding: EdgeInsets.only(bottom: 20),
                          child: const Text('Akció figyelő lista',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ))),
                    ),
                    Expanded(
                      child: FutureBuilder(
                        initialData: [],
                        future: offerListenerItemList,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Container(
                              child: Text("Loading"),
                            );
                          } else {
                            var data =
                                (snapshot.data as List<dynamic>).toList();
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    key: Key(data[index].id.toString()),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      setState(() {
                                        removeElement(index);

                                        _dataBaseHelper
                                            .deleteTask(data[index].id);
                                      });
                                    },
                                    background: Container(
                                      margin: EdgeInsets.only(bottom: 5.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFE6E6),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          SvgPicture.asset(
                                              "assets/images/Trash.svg"),
                                        ],
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewItem(
                                                            item: data[index])))
                                            .then((value) => setState(
                                                  () {},
                                                ));
                                      },
                                      child: ShopingItem(
                                        itemId: data[index].id,
                                        itemName: data[index].itemName,
                                      ),
                                    ),
                                  );
                                });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                /*
                Positioned(
                    top: 0.0,
                    right: 10.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NewItem(item: null)))
                            .then((value) => setState(
                                  () {},
                                ));
                      },
                      child: Container(
                        //decoration: BoxDecoration(color: Color(0xFF7349FE)),
                        child: const Image(
                          image: AssetImage('assets/images/add.png'),
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ))*/
              ],
            )),
      ),
    );
  }
}
