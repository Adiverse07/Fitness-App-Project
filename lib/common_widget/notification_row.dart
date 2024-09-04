import 'package:flutter/material.dart';
import '../common/color_extension.dart';

class NotificationRow extends StatelessWidget {
  final Map nObj;
  const NotificationRow({Key? key, required this.nObj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: mediaWidth * 0.025), // Adjusted padding
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(mediaWidth * 0.076), // Adjusted borderRadius
            child: Image.asset(
              nObj["image"].toString(),
              width: mediaWidth * 0.128, // Adjusted width
              height: mediaWidth * 0.128, // Adjusted height
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: mediaWidth * 0.038, // Adjusted width
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nObj["title"].toString(),
                  style: TextStyle(
                    color: Tcolor.black,
                    fontWeight: FontWeight.w500,
                    fontSize: mediaWidth * 0.031, // Adjusted font size
                  ),
                ),
                SizedBox(
                  height: mediaWidth * 0.018, // Adjusted height
                ),
                Text(
                  nObj["time"].toString(),
                  style: TextStyle(
                    color: Tcolor.gray,
                    fontSize: mediaWidth * 0.025, // Adjusted font size
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              "assets/images/sub_menu.png",
              width: mediaWidth * 0.038, // Adjusted width
              height: mediaWidth * 0.038, // Adjusted height
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
