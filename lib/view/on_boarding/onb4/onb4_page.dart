import 'package:flutter/material.dart';
import '../../../common/color_extension.dart';

class OnB4_Page extends StatelessWidget {
  const OnB4_Page({super.key});

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
            'assets/images/on_4.png',
            width: media.width,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(
            height: media.width * 0.1,
          ),
          Container(
            margin: const EdgeInsets.only(left: 30),
            child: Text(
              "Improve Sleep \nQuality",
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
              "Improve the quality of your sleep with us, \ngood quality sleep can bring a good mood \nin the morning",
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
