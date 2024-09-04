import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'Basic_channel_Group',
        channelKey: 'Basic_channel',
        channelName: 'Basic_notification',
        channelDescription: 'Basic_notification_channel',
        playSound: true,
      )
    ],
    channelGroups: [
      NotificationChannelGroup(channelGroupKey: 'basic_channel_group', channelGroupName: 'Basi_Group'),
    ],
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WorkoutScheduler(),
    );
  }
}

class WorkoutScheduler extends StatefulWidget {
  @override
  _WorkoutSchedulerState createState() => _WorkoutSchedulerState();
}

class _WorkoutSchedulerState extends State<WorkoutScheduler> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  int? _notificationId;


  User? _user;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedWorkout = 'Select Workout'; // Initialize with placeholder value

  List<String> workouts = [
    'Select Workout', // Add placeholder item
    'Full Body Workout',
    'Lower Body Workout',
    'ABS Workout',
    'Chest Workout',
    'ARM Workout',
    'Leg Workout',
    'Shoulder & Back Workout'
  ];

  @override
  void initState() {
    super.initState();
    _getUser();
    var androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    _flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: _onSelectNotification);
  }

  void _getUser() {
    _user = _auth.currentUser;
  }

  Future<void> _onSelectNotification(String? payload) async {
    // Handle notification tap
    print('Notification tapped with payload: $payload');
  }



  Future<void> _scheduleNotifications(List<Map<String, dynamic>> workoutSchedule) async {
    print('Scheduling notifications for multiple workouts');

    for (var workoutData in workoutSchedule) {
      String workout = workoutData['workout'];
      DateTime dateTime = workoutData['dateTime'];

      print('Scheduling notification for $workout at $dateTime');

      int notificationId = workout.hashCode; // Store the notification ID

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId, // Use the stored notification ID
          channelKey: 'Basic_channel',
          title: 'Workout Reminder',
          body: 'It\'s time for your workout: $workout',
        ),
        schedule: NotificationCalendar(
          year: dateTime.year,
          month: dateTime.month,
          day: dateTime.day,
          hour: dateTime.hour,
          minute: dateTime.minute,
          repeats: false,
        ),
      );

      // Store the notification ID in _notificationId
      _notificationId = notificationId;
    }
  }




  void _cancelScheduledNotification(int notificationId) async {
    await AwesomeNotifications().cancel(notificationId);
  }


  void _saveWorkout(BuildContext context) async {
    DateTime currentTime = DateTime.now();
    DateTime selectedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (_user != null && _selectedWorkout != 'Select Workout') {
      if (selectedDateTime.isAfter(currentTime) ||
          (selectedDateTime.day == currentTime.day &&
              selectedDateTime.month == currentTime.month &&
              selectedDateTime.year == currentTime.year &&
              selectedDateTime.hour > currentTime.hour) ||
          (selectedDateTime.day == currentTime.day &&
              selectedDateTime.month == currentTime.month &&
              selectedDateTime.year == currentTime.year &&
              selectedDateTime.hour == currentTime.hour &&
              selectedDateTime.minute > currentTime.minute)) {
        // Proceed with scheduling the workout
        String date = '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
        String time = _selectedTime.format(context); // Use the formatted time

        DatabaseReference userWorkoutsRef =
        _database.reference().child('users').child(_user!.uid).child('scheduled_workouts');
        DatabaseReference newWorkoutRef = userWorkoutsRef.push();

        Map<String, dynamic> workoutData = {
          'workout': _selectedWorkout,
          'date': date,
          'time': time, // Save the formatted time to the database
        };
        newWorkoutRef.set(workoutData);

        if (_selectedWorkout != 'Select Workout') {
          List<Map<String, dynamic>> workoutSchedule = [
            {
              'workout': _selectedWorkout,
              'dateTime': selectedDateTime,
            }
          ];

          await _scheduleNotifications(workoutSchedule);

          final scaffold = ScaffoldMessenger.of(context);
          scaffold.showSnackBar(
            SnackBar(content: Text('Workout scheduled successfully!')),
          );

          Navigator.of(context).pop(); // Pass the notification ID back
        }
      } else {
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
          SnackBar(content: Text('Please choose a future date and time!')),
        );
      }
    } else {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(content: Text('Please select a workout!')),
      );
    }
  }

  String getFormattedDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }

  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;
    var media = MediaQuery.of(context).size;

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
          "Workout Scheduler",
          style: TextStyle(
            color: Tcolor.black,
            fontSize: mediaWidth * 0.046, // Adjusted font size
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0,0,20.0,0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Select Date:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            // ElevatedButton(
            //   onPressed: () => _selectDate(context),
            //   child: Text(
            //     '${getFormattedDate(_selectedDate)}',
            //     style: TextStyle(fontSize: 16),
            //   ),
            // ),
            RoundButton(
              text: getFormattedDate(_selectedDate),
              onPressed: () => _selectDate(context),
              fontSize: 16,
            ),

            SizedBox(height: 20),
            Text(
              'Select Time:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            RoundButton(
              text: _selectedTime.format(context),
              onPressed: () => _selectTime(context),
              fontSize: 16,
            ),

            // ElevatedButton(
            //   onPressed: () => _selectTime(context),
            //   child: Text(
            //     '${_selectedTime.format(context)}',
            //     style: TextStyle(fontSize: 16),
            //   ),
            // ),
            SizedBox(height: 20),
            Text(
              'Select Workout:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: Tcolor.primaryG,
                ),
              ),
              width: media.width * 0.85,
              height: media.width * 0.15,
              child: DropdownButton<String>(
                value: _selectedWorkout,
                onChanged: (newValue) {
                  setState(() {
                    _selectedWorkout = newValue!;
                  });
                },
                items: workouts.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                        child: Text(
                          value,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  );
                }).toList(),
                dropdownColor: Tcolor.primaryColor1, // Set dropdown background color
                underline: Container(), // Hide the default underline
                icon: Icon(Icons.arrow_drop_down, color: Colors.white), // Set dropdown arrow color
              ),
            ),

            // DropdownButton<String>(
            //   value: _selectedWorkout,
            //   onChanged: (newValue) {
            //     setState(() {
            //       _selectedWorkout = newValue!;
            //     });
            //   },
            //   items: workouts.map<DropdownMenuItem<String>>((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            // ),
            SizedBox(height: 50),
            Center(
              child: Container(
                width: 165,
                height: 40,
                child: RoundButton(
                  text: 'Save Workout',
                  onPressed: () => _saveWorkout(context), // Use an anonymous function to pass the context
                  fontSize: 16,
                  backgroundGradient: LinearGradient(
                    colors: Tcolor.secondaryG,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}
