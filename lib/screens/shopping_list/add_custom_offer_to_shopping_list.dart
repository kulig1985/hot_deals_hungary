import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/controllers/mongo_dao_controller.dart';
import 'package:hot_deals_hungary/controllers/user_controller.dart';
import 'package:hot_deals_hungary/screens/components/bottom_bar.dart';
import 'package:hot_deals_hungary/screens/components/custom_app_bar.dart';
import 'package:hot_deals_hungary/screens/components/header_widget.dart';

class AddCustomItemToShoppingList extends StatefulWidget {
  const AddCustomItemToShoppingList({Key? key}) : super(key: key);

  @override
  State<AddCustomItemToShoppingList> createState() =>
      _AddCustomItemToShoppingListState();
}

class _AddCustomItemToShoppingListState
    extends State<AddCustomItemToShoppingList> {
  int _index = 0;
  TextEditingController itemNameController = TextEditingController();
  String dropdownValue = 'aldi';
  final _formKey = GlobalKey<FormState>();
  final MongoDaoController _mongoDaoController = Get.find();
  final UserDataController _userDataController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(
          titleName: 'Egyedi termék hozzáadása',
          backButtonchooser: true,
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
                  children: [
                    /*HeaderWidget(
                      titleName: 'Új termék hozzáadása',
                      backButtonchooser: true,
                    ),*/
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 20, top: 40, right: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                autofocus: true,
                                autocorrect: false,
                                controller: itemNameController,
                                decoration: const InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintStyle: TextStyle(color: Colors.white),
                                  icon: Icon(
                                    Icons.abc,
                                    color: Colors.white,
                                  ),
                                  hintText: 'Írd be a termék nevét!',
                                  labelText: 'Termék neve. Pld. Tej, vaj',
                                ),
                              ),
                              DropdownButtonFormField<String>(
                                dropdownColor:
                                    const Color.fromRGBO(43, 47, 58, 1),
                                menuMaxHeight: 200,
                                style: TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white),
                                  icon: Icon(
                                    Icons.shop,
                                    color: Colors.white,
                                  ),
                                  labelText: 'Bolt neve?',
                                ),
                                isExpanded: true,
                                value: dropdownValue,
                                icon: const Icon(
                                  Icons.arrow_downward,
                                  color: Color.fromRGBO(196, 99, 82, 1),
                                ),
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                                items: <String>[
                                  'aldi',
                                  'auchan',
                                  'spar',
                                  'tesco',
                                  'lidl',
                                  'piac',
                                  'egyéb'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 150.0, top: 40.0),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: const Color.fromRGBO(
                                          69, 125, 174, 1), // background
                                      onPrimary: Colors.white, // foreground
                                    ),
                                    child: const Text('Mentés'),
                                    onPressed: () async {
                                      if (itemNameController.text != '') {
                                        print('item save pressed');
                                        await _mongoDaoController
                                            .addOfferByUser(
                                                itemNameController.text,
                                                dropdownValue,
                                                _userDataController.user);
                                        Navigator.pop(context);
                                      }
                                    }),
                              ),
                            ],
                          ),
                        )),
                  ],
                )
              ],
            )),
      ),
      //bottomNavigationBar: const BottomBar(),
    );
  }
}
