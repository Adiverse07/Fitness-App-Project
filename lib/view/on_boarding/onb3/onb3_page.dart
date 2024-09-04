import 'package:flutter/material.dart';
import '../../../common/color_extension.dart';

class OnB3_Page extends StatelessWidget {
  const OnB3_Page({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SizedBox(
      width: media.width,
      height: media.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/on_3.png',
            width: media.width,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(
            height: media.width * 0.1,
          ),
          Container(
            margin: const EdgeInsets.only(left: 30),
            child: Text(
              "Eat Well",
              style: TextStyle(
                color: Tcolor.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 25, 0, 0),
            child: Text(
              "Let's start a healthy lifestyle with us, we can \ndetermine your diet every day. healthy \neating is fun",
              style: TextStyle(
                color: Tcolor.gray,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
