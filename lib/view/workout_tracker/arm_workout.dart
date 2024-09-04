import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/view/workout_tracker/arm_workouts/arm_ar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../common/color_extension.dart';
import '../../common_widget/exercises_set_section.dart';
import '../../common_widget/round_button.dart';
import '../dashboard/home/chatpage.dart';
import 'exercises_step_details.dart';
// import other necessary imports

class ArmWorkout extends StatefulWidget {
  final Map dObj;
  const ArmWorkout({Key? key, required this.dObj}) : super(key: key);

  @override
  State<ArmWorkout> createState() => _ArmWorkoutState();
}

class _ArmWorkoutState extends State<ArmWorkout> {
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
      DatabaseReference _workoutsRef = FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child('workouts');

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
          "image": "assets/images/arm_raises.png",
          "title": "Arm Raises",
          "value": "00:30",
          "id": "0qMxUa67a-U"
        },
        {
          "image": "assets/images/side_arm_raise.png",
          "title": "Side Arm Raises",
          "value": "00:30",
          "id": "YslHgg2E-Ro"
        },
        {
          "image": "assets/images/triceps_dips.png",
          "title": "Triceps Dips",
          "value": "x10",
          "id": "c3ZGl4pAwZ4"
        },
        {
          "image": "assets/images/arm_circle_clockwise.png",
          "title": "Arm Circles Clockwise",
          "value": "00:30",
          "id": "Lha66p0ZXUc"
        },
        {
          "image": "assets/images/arm_circle_counterclockwise.png",
          "title": "Arm Circles CounterClockwise",
          "value": "00:30",
          "id": "Lha66p0ZXUc"
        },
        {
          "image": "assets/images/diamond_push_ups.png",
          "title": "Diamond Push-Ups",
          "value": "x6",
          "id": "J0DnG1_S92I"
        },
        {
          "image": "assets/images/jumping_jacks.png",
          "title": "Jumping Jack",
          "value": "00:30",
          "id": "CWpmIW6l-YA"
        },
        {
          "image": "assets/images/chest_press_pulse.png",
          "title": "Chest Press Pulse",
          "value": "00:16",
          "id": "Fz4oo1vFo9M"
        },
        {
          "image": "assets/images/leg_left.png",
          "title": "Leg Barbell Curl Left",
          "value": "x8",
          "id": "3kZS8HVFquk"
        },
        {
          "image": "assets/images/leg_right.png",
          "title": "Leg Barbell Curl Right",
          "value": "x8",
          "id": "3kZS8HVFquk"
        },
        {
          "image": "assets/images/diagonal_plank.png",
          "title": "Diagonal Plank",
          "value": "x10",
          "id": "OGfFtF-dhrk"
        },
        {
          "image": "assets/images/punches.png",
          "title": "Punches",
          "value": "00:30",
          "id": "M_4Vt5lfEUE"
        },
        {
          "image": "assets/images/push_ups.png",
          "title": "Push-Ups",
          "value": "x10",
          "id": "IODxDxX7oi4"
        },
        {
          "image": "assets/images/inchworms.png",
          "title": "Inchworms",
          "value": "x8",
          "id": "pv_8CdDPAAk"
        },
        {
          "image": "assets/images/wall_push_ups.png",
          "title": "Wall Push-Ups",
          "value": "x12",
          "id": "YB0egDzsu18"
        },
        {
          "image": "assets/images/triceps_left.png",
          "title": "Triceps Stretch Left",
          "value": "00:30",
          "id": "nbHOmIYMazk"
        },
        {
          "image": "assets/images/triceps_right.png",
          "title": "Triceps Stretch Right",
          "value": "00:30",
          "id": "nbHOmIYMazk"
        },
        {
          "image": "assets/images/standing_left.png",
          "title": "Standing Biceps Stretch Left",
          "value": "00:30",
          "id": "QY4gCIYbGQk"
        },
        {
          "image": "assets/images/standing_right.png",
          "title": "Standing Biceps Stretch Right",
          "value": "00:30",
          "id": "QY4gCIYbGQk"
        }
      ]
    },
  ];

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
                                builder: (context) => arm_ar(),
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
