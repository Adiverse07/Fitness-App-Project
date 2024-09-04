import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../common/color_extension.dart';
import '../../common_widget/exercises_set_section.dart';
import '../../common_widget/round_button.dart';
import '../dashboard/home/chatpage.dart';
import 'exercises_step_details.dart';
import 'shoulder_workouts/sh_jj.dart';

class ShoulderWorkout extends StatefulWidget {
  final Map dObj;
  const ShoulderWorkout({super.key, required this.dObj});

  @override
  State<ShoulderWorkout> createState() => _ShoulderWorkoutState();
}

class _ShoulderWorkoutState extends State<ShoulderWorkout> {
  late Map<String, YoutubePlayerController> _controllersMap;

  @override
  void initState() {
    super.initState();
    _controllersMap = {};
    for (var exercise in exercisesArr) {
      for (var set in exercise['set']) {
        _controllersMap[set['id']] = YoutubePlayerController(
          initialVideoId: set['id'],
          flags: const YoutubePlayerFlags(autoPlay: false),
        );
      }
    }
  }

  Future<void> saveWorkoutData(String workoutName, String dateTime) async {
    try {
      // Format the current date and time
      String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
      String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

      // Initialize the workouts reference
      DatabaseReference _workoutsRef = FirebaseDatabase.instance.reference().child('users').child(FirebaseAuth.instance.currentUser!.uid).child('workouts');

      // Save workout data to Firebase
      await _workoutsRef.push().set({
        'workoutName': workoutName,
        'date': formattedDate,
        'time': formattedTime,
        // Add more data as needed
      });
      print('Workout data saved successfully!');
    } catch (error) {
      print('Error saving workout data: $error');
    }
  }

  List exercisesArr = [
    {
      "set": [
        {
          "image": "assets/images/jumping_jacks.png",
          "title": "Jumping Jack",
          "value": "00:30",
          "id": "CWpmIW6l-YA"
        },
        {
          "image": "assets/images/arm_raises.png",
          "title": "Arm Raise",
          "value": "00:16",
          "id": "0qMxUa67a-U"
        },
        {
          "image": "assets/images/rhomboid_pulls.png",
          "title": "Rhomboid Pulls",
          "value": "x14",
          "id": "DEyDbzSudEU"
        },
        {
          "image": "assets/images/knee_push_up.png",
          "title": "Knee Push-Ups",
          "value": "x10",
          "id": "WcHtt6zT3Go"
        },
        {
          "image": "assets/images/side_arm_raise.png",
          "title": "Side Arm Raise",
          "value": "00:16",
          "id": "YslHgg2E-Ro"
        },
        {
          "image": "assets/images/knee_push_up.png",
          "title": "Knee Push-Ups",
          "value": "x14",
          "id": "WcHtt6zT3Go"
        },
        {
          "image": "assets/images/side_left.png",
          "title": "Side-Lying Floor Stretch Left",
          "value": "00:30",
          "id": "DMlSdmsHEeI"
        },
        {
          "image": "assets/images/side_right.png",
          "title": "Side-Lying Floor Stretch Right",
          "value": "00:30",
          "id": "DMlSdmsHEeI"
        },
        {
          "image": "assets/images/arm_scissors.png",
          "title": "Arm Scissors",
          "value": "00:30",
          "id": "Cilm0WNRdCo"
        },
        {
          "image": "assets/images/cat_cow.png",
          "title": "Cat Cow Pose",
          "value": "00:30",
          "id": "vuyUwtHl694"
        },
        {
          "image": "assets/images/prone.png",
          "title": "Prone Triceps Push Ups",
          "value": "x14",
          "id": "Rr43jMaoJ9g"
        },
        {
          "image": "assets/images/reclined.png",
          "title": "Reclined Rhomboid Squeezes",
          "value": "x12",
          "id": "olv2Sv9DwmA"
        },
        {
          "image": "assets/images/child.png",
          "title": "Child's Pose",
          "value": "00:30",
          "id": "eqVMAPM00DM"
        },
      ],
    },
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   _controllersMap = {};
  //   for (var exercise in exercisesArr) {
  //     for (var set in exercise['set']) {
  //       _controllersMap[set['id']] = YoutubePlayerController(
  //         initialVideoId: set['id'],
  //         flags: const YoutubePlayerFlags(autoPlay: false),
  //       );
  //     }
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration:
          BoxDecoration(gradient: LinearGradient(colors: Tcolor.primaryG)),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leading: Container(
                margin: const EdgeInsets.all(10),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
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
                ),
              ) ,
              // actions: [
              //   InkWell(
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const ChatPage(),
              //         ),
              //       );
              //     },
              //     splashColor: Colors.transparent,
              //     highlightColor: Colors.transparent,
              //     child: Container(
              //       margin: const EdgeInsets.fromLTRB(8,12,8,8),
              //       height: mediaWidth * 0.092,
              //       width: mediaWidth * 0.092,
              //       alignment: Alignment.center,
              //       decoration: BoxDecoration(
              //           color: Tcolor.lightgray,
              //           borderRadius: BorderRadius.circular(10)),
              //       child: Image.asset(
              //         "assets/images/chat.png",
              //         width: 30,
              //         height: 30,
              //         fit: BoxFit.contain,
              //       ),
              //     ),
              //   )
              //
              // ],
            ),
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leadingWidth: 0,
              leading: Container(),
              expandedHeight: media.width * 0.5,
              flexibleSpace: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/detail_top.png",
                  width: media.width * 0.75,
                  height: media.width * 0.8,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ];
        },
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Tcolor.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Tcolor.gray.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(3)),
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.dObj["title"].toString(),
                                  style: TextStyle(
                                      color: Tcolor.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "${widget.dObj["exercises"].toString()} | ${widget.dObj["time"].toString()}",
                                  style: TextStyle(
                                      color: Tcolor.gray, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Exercises",
                            style: TextStyle(
                                color: Tcolor.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: exercisesArr.length,
                          itemBuilder: (context, index) {
                            var sObj = exercisesArr[index] as Map? ?? {};
                            return ExercisesSetSection(
                              sObj: sObj,
                              onPressed: (obj) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExercisesStepDetails(
                                      eObj: obj,
                                      controller: _controllersMap[obj['id']],
                                      intId: obj['id'],
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                      SizedBox(
                        height: media.width * 0.2,
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Padding(

                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RoundButton(
                          text: "Start Workout",
                          onPressed: () async {
                            // Get the current date and time
                            String currentDateTime = DateTime.now().toString();

                            // Save workout data to Firebase
                            await saveWorkoutData(widget.dObj["title"].toString(), currentDateTime);

                            // Navigate to the workout page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => sh_jj(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
