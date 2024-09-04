import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import 'add_schedule_view.dart';

class workout_schedule_view extends StatefulWidget {
  final String userId;

  const workout_schedule_view({Key? key, required this.userId}) : super(key: key);

  @override
  _workout_schedule_viewState createState() => _workout_schedule_viewState();
}

class _workout_schedule_viewState extends State<workout_schedule_view> {
  late DatabaseReference _userWorkoutsRef;
  bool _isLoading = true;
  List<Map<dynamic, dynamic>> _workoutsList = [];

  @override
  void initState() {
    super.initState();
    _initFirebase();
  }

  Future<void> _initFirebase() async {
    await Firebase.initializeApp();
    _userWorkoutsRef = FirebaseDatabase.instance.reference().child('users').child(widget.userId).child('scheduled_workouts');
    _userWorkoutsRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        _workoutsList.clear();
        (event.snapshot.value as Map<dynamic, dynamic>).forEach((key, value) {
          _workoutsList.add({'key': key, 'notificationId': value['notificationId'], ...value});
        });
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  // Future<void> _deleteWorkout(String key, int? notificationId) async {
  //   // Delete the workout from Firebase database
  //   await _userWorkoutsRef.child(key).remove();
  //
  //   // Cancel the scheduled notification using the notification ID if it's not null
  //   if (notificationId != null) {
  //     await AwesomeNotifications().cancel(notificationId);
  //   }
  //
  //   // Update the local list of workouts
  //   setState(() {
  //     _workoutsList.removeWhere((workout) => workout['key'] == key);
  //   });
  // }


  Future<void> _deleteWorkout(String key, int? notificationId) async {
    // Delete the workout from Firebase database
    await _userWorkoutsRef.child(key).remove();

    // Cancel the scheduled notification using the notification ID if it's not null
    if (notificationId != null) {
      await AwesomeNotifications().cancel(notificationId);
    }

    // Update the local list of workouts
    setState(() {
      _workoutsList.removeWhere((workout) => workout['key'] == key);
    });
  }



  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Tcolor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
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
        title: Text(
          "Sheduled Workouts",
          style: TextStyle(
            color: Tcolor.black,
            fontSize: mediaWidth * 0.046, // Adjusted font size
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _workoutsList.isNotEmpty
          ? ListView.builder(
        itemCount: _workoutsList.length,
        itemBuilder: (context, index) {
          final workout = _workoutsList[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: Tcolor.primaryG, // Add your desired colors here
              ),              borderRadius: BorderRadius.circular(15),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15,top: 10),
                  child: Text(
                    workout['workout'] ?? '',
                    style: TextStyle(
                      color: Tcolor.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  margin: EdgeInsets.only(left: 15,top: 10),
                  child: Text(
                    '${workout['date'] ?? ''} ${workout['time'] ?? ''}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: Tcolor.secondaryG, // Default gradient colors
                        ),
                      ),
                      width: 105,
                      height: 35,
                      child: TextButton(
                        onPressed: () => _deleteWorkout(workout['key'], workout['notificationId']),
                        child: Text(
                          'Delete',
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
          );
        },
      )
          : Center(
        child: Text('No scheduled workouts found.'),
      ),
      floatingActionButton: SizedBox(
        width: screenwidth * 0.18,
        height: screenheight * 0.1,
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: FloatingActionButton(
            elevation: 0,
            shape: CircleBorder(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>   WorkoutScheduler(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Tcolor.primaryColor1, Tcolor.primaryColor2],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(23),
                child: Icon(
                    Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => WorkoutScheduler()),
      //     );
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}

    class ScheduleWorkoutPage extends StatelessWidget {
  final String userId;

  const ScheduleWorkoutPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Workout'),
      ),
      body: Center(
        child: Text('This is where you schedule a workout.'),
      ),
    );
  }
}
