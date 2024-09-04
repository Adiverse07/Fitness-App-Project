import 'package:flutter/material.dart';
import '../../../common/color_extension.dart';
import '../../../common_widget/notification_row.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  List<Map<String, String>> notificationArr = [
    {"image": "assets/images/Workout1.png", "title": "Hey, it’s time for lunch", "time": "About 1 minutes ago"},
    {"image": "assets/images/Workout2.png", "title": "Don’t miss your lowerbody workout", "time": "About 3 hours ago"},
    {"image": "assets/images/Workout3.png", "title": "Hey, let’s add some meals for your b", "time": "About 3 hours ago"},
    {"image": "assets/images/Workout1.png", "title": "Congratulations, You have finished A..", "time": "29 May"},
    {"image": "assets/images/Workout2.png", "title": "Hey, it’s time for lunch", "time": "8 April"},
    {"image": "assets/images/Workout3.png", "title": "Ups, You have missed your Lowerbo...", "time": "8 April"},
  ];

  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Tcolor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: mediaWidth * 0.1, // Adjusted height
            width: mediaWidth * 0.1, // Adjusted width
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Tcolor.lightgray,
              borderRadius: BorderRadius.circular(mediaWidth * 0.025), // Adjusted borderRadius
            ),
            child: Image.asset(
              "assets/images/black_btn.png",
              width: mediaWidth * 0.038, // Adjusted width
              height: mediaWidth * 0.038, // Adjusted height
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Notification",
          style: TextStyle(
            color: Tcolor.black,
            fontSize: mediaWidth * 0.046, // Adjusted font size
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: Tcolor.white,
      body: ListView.separated(
        padding: EdgeInsets.symmetric(
          vertical: mediaWidth * 0.036, // Adjusted padding
          horizontal: mediaWidth * 0.064, // Adjusted padding
        ),
        itemBuilder: (context, index) {
          var nObj = notificationArr[index];
          return NotificationRow(nObj: nObj);
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Tcolor.lightgray2.withOpacity(0.5),
            height: 1,
          );
        },
        itemCount: notificationArr.length,
      ),
    );
  }
}
