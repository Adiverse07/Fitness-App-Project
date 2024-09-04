import 'package:flutter/material.dart';
import '../../../common/color_extension.dart';

class OnB2_Page extends StatelessWidget {
  const OnB2_Page({super.key});

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
            'assets/images/on_2.png',
            width: media.width,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(
            height: media.width * 0.1,
          ),
          Container(
            margin: const EdgeInsets.only(left: 30),
            child: Text(
              "Get Burn",
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
              "Let’s keep burning, to achive yours goals, it \nhurts only temporarily, if you give up now \nyou will be in pain forever",
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
