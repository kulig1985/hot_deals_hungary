// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderWidget extends StatefulWidget {
  final String titleName;
  final bool backButtonchooser;
  HeaderWidget(
      {Key? key, required this.titleName, required this.backButtonchooser})
      : super(key: key);

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  Widget conditionalImage() {
    if (widget.backButtonchooser) {
      return IconButton(
        icon: SvgPicture.asset(
          "assets/images/back_icon.svg",
          height: 20,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } else {
      return const Image(
        image: AssetImage('assets/images/logo.png'),
        width: 50,
        height: 50,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: conditionalImage(),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            widget.titleName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        )
      ],
    );
  }
}
