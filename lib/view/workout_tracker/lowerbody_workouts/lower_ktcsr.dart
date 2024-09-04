import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import '../../../common/color_extension.dart';
import '../workout_tracker_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class lower_ktcsr extends StatefulWidget {
  @override
  _lower_ktcsrState createState() => _lower_ktcsrState();
}

class _lower_ktcsrState extends State<lower_ktcsr> {
  late VideoPlayerController _controller;
  late Timer _timer;
  int _countdownSeconds = 30;
  bool _isPlaying = true;

  Future<void> updateWorkoutsNode(int currentDay) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        DatabaseReference ref = FirebaseDatabase.instance.reference().child('users/$userId/workouts_count');

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

  void updateCalories(int newCalories) async {
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
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/v1.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller.play(); // Start video playback by default
          _controller.setLooping(true); // Loop the video
        });
      });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_isPlaying && _countdownSeconds > 0) {
        setState(() {
          _countdownSeconds--;
        });
      } else if (_countdownSeconds == 0) {
        _handleCountdownFinish();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    _controller.pause(); // Pause the video
    _timer.cancel(); // Pause the timer

    bool quitConfirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you want to quit?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel button
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Quit button
            },
            child: Text('Quit'),
          ),
        ],
      ),
    );

    if (!quitConfirmed) {
      _controller.play(); // Resume video playback
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_isPlaying && _countdownSeconds > 0) {
          setState(() {
            _countdownSeconds--;
          });
        } else if (_countdownSeconds == 0) {
          _handleCountdownFinish();
        }
      });
    }

    return quitConfirmed ?? false;
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  void _handleCountdownFinish() {
    _controller.pause();
    int currentDay = DateTime.now().weekday;
    updateWorkoutsNode(currentDay);
    updateCalories(376); // Update user calories to 500
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => WorkoutTrackerView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.only(top: 250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : Container(),
              SizedBox(height: 100),
              Text(
                'Knee To Chest Stretch Right',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                '${(_countdownSeconds ~/ 60).toString().padLeft(2, '0')}:${(_countdownSeconds % 60).toString().padLeft(2, '0')}',
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
                  onPressed: _togglePlayPause,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Make button transparent
                    elevation: 0, // Remove default elevation
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),

                  ),
                  child: Text(
                    _isPlaying ? 'Pause' : 'Resume',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),


              SizedBox(height: 50),
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
                        Navigator.of(context).pop(); // Navigate to the previous page
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
                          MaterialPageRoute(builder: (context) => WorkoutTrackerView()),

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
      ),
    );
  }
}

