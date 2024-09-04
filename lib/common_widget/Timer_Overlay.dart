import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

import '../view/workout_tracker/workout_tracker_view.dart';

class TimerOverlay extends StatelessWidget {
  final String workoutName;
  final Widget redirectPage;
  final BuildContext context;
  final AnimationController animationController;

  const TimerOverlay({
    Key? key,
    required this.workoutName,
    required this.redirectPage,
    required this.context,
    required this.animationController,
  }) : super(key: key);

  Future<bool> _onWillPop() async {
    animationController.stop(); // Stop the timer when quitting
    bool confirmQuit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you want to quit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Cancel
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Quit
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WorkoutTrackerView()),
              );
            },
            child: Text('Quit'),
          ),
        ],
      ),
    );
    return confirmQuit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Next: $workoutName',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
              SizedBox(height: 20),
              CountdownTimer(
                endTime: DateTime.now().millisecondsSinceEpoch + 11000, // 11 seconds from now
                widgetBuilder: (_, CurrentRemainingTime? time) {
                  if (time == null) {
                    return SizedBox(); // Empty widget when timer is null
                  }
                  return Text(
                    'Time Left: ${time.sec} seconds',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  );
                },
                onEnd: () {
                  // Redirect to the specified page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => redirectPage),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Skip the timer and redirect
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => redirectPage),
                  );
                },
                child: Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
