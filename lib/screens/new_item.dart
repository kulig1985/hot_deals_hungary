import 'package:flutter/material.dart';
import 'package:hot_deals_hungary/models/item.dart';
import 'package:hot_deals_hungary/models/offer.dart';
import 'package:hot_deals_hungary/services/database_helper.dart';
import 'package:hot_deals_hungary/services/offer_service.dart';

class NewItem extends StatefulWidget {
  final Item? item;
  const NewItem({Key? key, this.item}) : super(key: key);

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final itemNameController = TextEditingController();
  DataBaseHelper _dataBaseHelper = DataBaseHelper();
  OfferService _offerService = OfferService();

  int itemId = 0;
  String itemName = "";

  @override
  void initState() {
    if (widget.item != null) {
      itemName = widget.item!.itemName;
      itemId = widget.item!.id!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Stack(children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        /*
                        if (itemNameController.text != '') {
                          Navigator.pop(context);
                          
                          DataBaseHelper _dbHelper = DataBaseHelper();

                          Item newItem =
                              Item(itemName: itemNameController.text);

                          await _dbHelper.insertItem(newItem);

                          print('New Item created!');

                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                        */
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Image(
                          image: AssetImage('assets/images/cart_ok.png'),
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ),
                    Expanded(
                      // ignore: unnecessary_const
                      child: TextField(
                        autocorrect: false,
                        controller: itemNameController..text = itemName,
                        onSubmitted: (value) async {
                          // ignore: avoid_print

                          if (value != '') {
                            if (widget.item == null) {
                              DataBaseHelper _dbHelper = DataBaseHelper();

                              Item newItem = Item(itemName: value);

                              await _dbHelper.insertItem(newItem);

                              print('New Item created!');

                              itemName = value;

                              setState(() {});

                              //Navigator.pop(context);
                            } else {}
                          }
                        },
                        decoration: const InputDecoration(
                            hintText: 'Adj hozzá egy új terméket..',
                            border: InputBorder.none),
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 100.0),
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                    initialData: [],
                    future: _offerService.getOffers(itemName),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        var data = (snapshot.data as List<dynamic>).toList();
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                //padding: const EdgeInsets.all(2),
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 10.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data[index].itemName,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${data[index].price} ,-Ft - ${data[index].shopName}',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'Kiszerelés: ${data[index].measure}',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'Akció kezdete: ${data[index].salesStart}',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                          /*Text(
                                    'Bolt: ${offerList![index].shopName}',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  )*/
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 10.0,
              right: 32.0,
              child: GestureDetector(
                onTap: () {
                  if (itemId != 0) {
                    _dataBaseHelper.deleteTask(itemId);
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  //decoration: BoxDecoration(color: Color(0xFF7349FE)),
                  child: Container(
                    width: 65,
                    height: 65,
                    child: const Image(
                      image: AssetImage('assets/images/clear.png'),
                      width: 55,
                      height: 55,
                    ),
                  ),
                ),
              ))
        ])),
      ),
    );
  }
}
