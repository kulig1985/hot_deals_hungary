import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/controllers/mongo_dao_controller.dart';
import 'package:hot_deals_hungary/controllers/user_controller.dart';
import 'package:hot_deals_hungary/screens/components/custom_app_bar.dart';
import 'package:hot_deals_hungary/screens/components/header_widget.dart';

class AllShoppingListPage extends StatefulWidget {
  const AllShoppingListPage({Key? key}) : super(key: key);

  @override
  State<AllShoppingListPage> createState() => _AllShoppingListPageState();
}

class _AllShoppingListPageState extends State<AllShoppingListPage> {
  final MongoDaoController _mongoDaoController = Get.find();
  final UserDataController _userDataController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(
          titleName: 'Listáim',
          backButtonchooser: false,
        ),
      ),
      body: SafeArea(
          child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        color: const Color(0XFFF6F6F6),
        child: Stack(children: [
          Column(
            children: [
              /*HeaderWidget(
                titleName: 'Listáim',
                backButtonchooser: false,
              )*/
              const Divider(
                color: Colors.black12,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 600,
                    child: GetBuilder<MongoDaoController>(
                      builder: (_) => ListView.builder(
                          itemCount:
                              _mongoDaoController.shoppingListEntityListLength,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              title: Text(_mongoDaoController
                                  .shoppingListEntityList[index].listName),
                              value: _mongoDaoController.selectedListMap[
                                  _mongoDaoController
                                      .shoppingListEntityList[index].id.oid],
                              onChanged: (value) {
                                setState(() {
                                  _mongoDaoController.selectShoppingList(
                                      _mongoDaoController
                                          .shoppingListEntityList[index].id.oid,
                                      value!);
                                  print(
                                      'checked:${_mongoDaoController.selectedListMap}');
                                  _mongoDaoController.update();
                                  //Navigator.pop(context);
                                });
                              },
                              secondary: const Icon(
                                Icons.list_alt,
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              )
            ],
          )
        ]),
      )),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Lista létrehozása!'),
        onPressed: () {
          setState(() {
            _mongoDaoController.createNewShoppingList(_userDataController.user);
            _mongoDaoController.update();
          });
        },
        backgroundColor: Color.fromRGBO(196, 99, 82, 1),
        icon: Icon(Icons.list_alt_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
