import 'package:flutter/material.dart';
import 'package:hot_deals_hungary/models/item.dart';
import 'package:hot_deals_hungary/screens/new_item.dart';
import 'package:hot_deals_hungary/services/database_helper.dart';
import 'package:hot_deals_hungary/shoping_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePagetState();
}

class _HomePagetState extends State<HomePage> {
  DataBaseHelper _dataBaseHelper = DataBaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: const Image(
                        image: AssetImage('assets/images/logo.png'),
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(bottom: 20),
                        child: const Text('Akció figyelő lista',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ))),
                    Expanded(
                      child: FutureBuilder(
                        initialData: [],
                        future: _dataBaseHelper.getAllItem(),
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
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => NewItem(
                                                      item: data[index])))
                                          .then((value) => setState(
                                                () {},
                                              ));
                                    },
                                    child: ShopingItem(
                                      itemId: data[index].id,
                                      itemName: data[index].itemName,
                                    ),
                                  );
                                });
                          }
                        },
                      ),
                    ),
                  ],
                ),
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
                    ))
              ],
            )),
      ),
    );
  }
}
