import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

void _loginWithFacebook() {
  final facebookAuth = FacebookAuth.instance.login();
  final userData = FacebookAuth.instance.getUserData();
  print(userData);
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: const Color.fromRGBO(43, 47, 58, 1),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: ElevatedButton(
                  onPressed: () {
                    _loginWithFacebook();
                  },
                  child: Text("FacebookLogin")),
            )
          ],
        ),
      ),
    );
  }
}
