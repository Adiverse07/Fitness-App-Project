import 'package:flutter/material.dart';

class CongratulationPage extends StatelessWidget {
  final String workoutName;

  CongratulationPage({required this.workoutName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Congratulations!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Congratulations on completing your workout:',
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            Text(
              workoutName,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous screen
              },
              child: Text('Back to Workout'),
            ),
          ],
        ),
      ),
    );
  }
}
