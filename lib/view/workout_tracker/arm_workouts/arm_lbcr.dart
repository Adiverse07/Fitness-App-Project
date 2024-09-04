import 'package:fitness_app/view/workout_tracker/arm_workouts/arm_dpu.dart';
import 'package:fitness_app/view/workout_tracker/arm_workouts/arm_lbcl.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../common/color_extension.dart';
import '../next_workout.dart';
import 'arm_dp.dart';

class arm_lbcr extends StatefulWidget {
  @override
  _arm_lbcrState createState() => _arm_lbcrState();
}

class _arm_lbcrState extends State<arm_lbcr> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/push.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller.play(); // Auto-play video
          _controller.setLooping(true); // Loop the video
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 250),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 16/9, // You can adjust the aspect ratio as needed
              child: VideoPlayer(_controller),
            ),
            SizedBox(height: 100),
            Text(
              'Leg Barbell Curl Right',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'x8',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            Container(
              width: 110,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: Tcolor.primaryG,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF3366FF).withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 1.5),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WorkoutPage(
                      nextWorkoutName: 'Diamond Plank',
                      redirectPage: arm_dp(),
                    ),),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Make button transparent
                  elevation: 0, // Remove default elevation
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Container(
              width: 125,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: Tcolor.primaryG,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF3366FF).withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 1.5),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => arm_lbcl(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Previous',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
                SizedBox(width: 50),
                Container(
                  width: 125,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: Tcolor.primaryG,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF3366FF).withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 1.5),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => WorkoutPage(
                          nextWorkoutName: 'Diamond Plank',
                          redirectPage: arm_dp(),
                        ),),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Make button transparent
                      elevation: 0, // Remove default elevation
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
