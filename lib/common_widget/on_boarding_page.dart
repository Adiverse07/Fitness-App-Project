import 'package:flutter/cupertino.dart';
import '../common/color_extension.dart';

class OnBoardingPage extends StatelessWidget {
  final Map pObj;
  const OnBoardingPage({super.key, required this.pObj});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return  SizedBox(
      width: media.width,
      height: media.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Image.asset(
            pObj["image"].toString(),
            width: media.width,
            fit: BoxFit.fitWidth,
          ),

          SizedBox(height: media.width * 0.1,),

          Container(
            margin: const EdgeInsets.only(left: 30),
            child: Text(
                pObj["title"].toString(),
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
                pObj["subtitle"].toString(),
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
