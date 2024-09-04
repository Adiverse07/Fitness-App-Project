import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../common/color_extension.dart';
import '../next_workout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'full_ipu.dart';
import 'full_pu.dart';

class full_kpu extends StatefulWidget {
  @override
  _full_kpuState createState() => _full_kpuState();
}

class _full_kpuState extends State<full_kpu> {
  late VideoPlayerController _controller;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  Future<void> updateCalories(int newCalories) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('Users/${user.uid}');
        await userRef.update({'user_calories': newCalories});
        print('User calories updated successfully!');
      } else {
        print('User not found. Unable to update calories.');
      }
    } catch (e) {
      print('Error updating user calories: $e');
    }
  }

  Future<void> updateWorkoutsNode(int currentDay) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        DatabaseReference ref = FirebaseDatabase.instance
            .reference()
            .child('users/$userId/workouts_count');

        DateTime now = DateTime.now();
        String dayName = getDayName(now.weekday);

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
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/knee.mp4')
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
              aspectRatio: 16 / 9, // You can adjust the aspect ratio as needed
              child: VideoPlayer(_controller),
            ),
            SizedBox(height: 100),
            Text(
              'Knee Push-Ups',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'x4',
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
                  int currentDay = DateTime.now().weekday;
                  updateWorkoutsNode(currentDay);
                  await updateCalories(34); // Update user calories to 500
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutPage(
                        nextWorkoutName: 'Push-Ups',
                        redirectPage: full_pu(),
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
                          builder: (context) => full_ipu(),
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
                        MaterialPageRoute(
                          builder: (context) => WorkoutPage(
                            nextWorkoutName: 'Push-Ups',
                            redirectPage: full_pu(),
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
