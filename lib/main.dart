import 'package:fitness_app/common/color_extension.dart';
import 'package:fitness_app/view/on_boarding/notification_controller.dart';
import 'package:fitness_app/view/wrapper.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelGroupKey: "Basic_channel_Group",
      channelKey: "Basic_channel",
      channelName: "Basic_notification",
      channelDescription: "Basic_notification_channel",
      playSound: true,
    )
  ], channelGroups: [
    NotificationChannelGroup(
      channelGroupKey: "basic_channel_group",
      channelGroupName: "Basic_Group",
    )
  ]);
  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fitness App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Tcolor.primaryColor1,
        fontFamily: "Poppins",
      ),
      home: Wrapper(),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return GetMaterialApp(
  //     title: 'Fitness App',
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData(
  //       primaryColor: Tcolor.primaryColor1,
  //       fontFamily: "Poppins",
  //     ),
  //     home: Scaffold(
  //       floatingActionButton: FloatingActionButton(
  //         onPressed: (){
  //           AwesomeNotifications().createNotification(content: NotificationContent(id: 1, channelKey: "Basic_channel",
  //           title: "helllo",
  //           body: "workout time!"),);
  //         },
  //         child: Icon(
  //           Icons.notification_add,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
