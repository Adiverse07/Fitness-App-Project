import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../common/color_extension.dart';
import '../Fullbody_workouts/full_pu.dart';
import '../next_workout.dart';
import 'chest_ipu_12.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class chest_wapu extends StatefulWidget {
  @override
  _chest_wapuState createState() => _chest_wapuState();
}

class _chest_wapuState extends State<chest_wapu> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/wide.mp4')
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

  Future<void> updateWorkoutsNode(int currentDay) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        DatabaseReference ref = FirebaseDatabase.instance.reference().child('users/$userId/workouts_count');

        // Get the current date to determine the day of the week
        DateTime now = DateTime.now();
        String dayName = getDayName(now.weekday);

        // Update the workouts node only if it's the current day
        if (currentDay == now.weekday) {
          await ref.child(dayName).set(ServerValue.increment(1));
          print('Workouts node updated successfully.');
        } else {
          print('Not updating workouts node as it is not the current day.');
        }
      }
    } catch (e) {
      print('Error updating workouts node: $e');
    }
  }

  Future<void> updateCalories(int newCalories) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users/${user.uid}');
        await userRef.update({'user_calories': newCalories});
        print('User calories updated successfully!');
      } else {
        print('User not found. Unable to update calories.');
      }
    } catch (e) {
      print('Error updating user calories: $e');
    }
  }

  String getDayName(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
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
              'Wide Arm Push-Ups',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'x10',
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
                onPressed: () async {
                  // Get the current day of the week (1 for Monday, 7 for Sunday)
                  int currentDay = DateTime.now().weekday;
                  // Update the value of the current day in the user's workouts node
                  await updateWorkoutsNode(currentDay);
                  // Update user calories to 200
                  await updateCalories(717);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutPage(
                        nextWorkoutName: 'Incline Push-Ups',
                        redirectPage: chest_ipu_12(),
                      ),
                    ),
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
                        MaterialPageRoute(
                          builder: (context) => full_pu(),
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
                    onPressed: () async {
                      // Get the current day of the week (1 for Monday, 7 for Sunday)
                      int currentDay = DateTime.now().weekday;
                      // Update the value of the current day in the user's workouts node
                      await updateWorkoutsNode(currentDay);
                      // Update user calories to 200
                      await updateCalories(200);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutPage(
                            nextWorkoutName: 'Incline Push-Ups',
                            redirectPage: chest_ipu_12(),
                          ),
                        ),
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
