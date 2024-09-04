import 'package:flutter/material.dart';
import 'dart:async';

class WorkoutPage extends StatefulWidget {
  final String nextWorkoutName;
  final Widget redirectPage;

  const WorkoutPage({
    Key? key,
    required this.nextWorkoutName,
    required this.redirectPage,
  }) : super(key: key);

  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late Timer _timer;
  int _countdownSeconds = 10;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        setState(() {
          _countdownSeconds--;
        });
      } else {
        _timer.cancel();
        _handleCountdownFinish();
      }
    });
  }

  void _handleCountdownFinish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => widget.redirectPage),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          _timer.cancel();
          return _showConfirmationDialog();
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Next Workout:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                widget.nextWorkoutName,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                '${_countdownSeconds.toString()} seconds',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => widget.redirectPage),
                  );
                },
                icon: Icon(Icons.arrow_forward),
                iconSize: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showConfirmationDialog() async {
    bool quitConfirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you want to quit?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel button
              _startTimer(); // Resume the timer
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

    if (quitConfirmed) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => widget.redirectPage),
      );
    }

    return quitConfirmed;
  }
}

class AnotherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Another Page'),
      ),
      body: Center(
        child: Text('Redirected from Workout Page'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: WorkoutPage(
        nextWorkoutName: 'Sample Workout',
        redirectPage: AnotherPage(),
      ),
    ),
  ));
}
