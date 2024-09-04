import 'package:fitness_app/view/workout_tracker/shoulder_workouts/sh_kpu.dart';
import 'package:fitness_app/view/workout_tracker/shoulder_workouts/sh_sr.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import '../../../common/color_extension.dart';
import '../next_workout.dart';


class sh_sl extends StatefulWidget {
  @override
  _sh_slState createState() => _sh_slState();
}

class _sh_slState extends State<sh_sl> {
  late VideoPlayerController _controller;
  late Timer _timer;
  int _countdownSeconds = 30;
  bool _isPlaying = true;

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
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => WorkoutPage(
        nextWorkoutName: 'Side-Lying Floor Stretch Right',
        redirectPage: sh_sr(),
      ),),
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
                'Side-Lying Floor Stretch Left',
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => sh_kpu(),
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
                            nextWorkoutName: 'Side-Lying Floor Stretch Right',
                            redirectPage: sh_sr(),
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
      ),
    );
  }
}

