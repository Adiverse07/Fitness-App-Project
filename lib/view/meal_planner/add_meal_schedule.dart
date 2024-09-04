import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';

import '../../common/color_extension.dart';

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
      title: 'Meal Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MealSchedule(),
    );
  }
}

class MealSchedule extends StatefulWidget {
  @override
  _MealScheduleState createState() => _MealScheduleState();
}

class _MealScheduleState extends State<MealSchedule> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  int? _notificationId;

  User? _user;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController _mealController = TextEditingController(); // Controller for the workout input field

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
      String workout = workoutData['meal'];
      DateTime dateTime = workoutData['dateTime'];

      print('Scheduling notification for $workout at $dateTime');

      int notificationId = workout.hashCode; // Store the notification ID

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId, // Use the stored notification ID
          channelKey: 'Basic_channel',
          title: 'Meal Reminder',
          body: 'It\'s time for your meal: $workout',
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
    // Cancel scheduled notification
  }

  void _saveWorkout(BuildContext context) async {
    // Save workout logic
    String meal = _mealController.text;
    if (_user != null && meal.isNotEmpty) {
      // Proceed with scheduling the workout
      String date = '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
      String time = _selectedTime.format(context); // Use the formatted time

      DatabaseReference userWorkoutsRef = _database.reference().child('users').child(_user!.uid).child('scheduled_meals');
      DatabaseReference newWorkoutRef = userWorkoutsRef.push();

      Map<String, dynamic> workoutData = {
        'meals': meal,
        'date': date,
        'time': time, // Save the formatted time to the database
      };

      newWorkoutRef.set(workoutData);

      List<Map<String, dynamic>> workoutSchedule = [
        {
          'meal': meal,
          'dateTime': DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            _selectedTime.hour,
            _selectedTime.minute,
          ),
        }
      ];

      await _scheduleNotifications(workoutSchedule);

      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(content: Text('Meal scheduled successfully!')),
      );

      Navigator.of(context).pop(); // Pass the notification ID back
    } else {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(content: Text('Please enter a meal!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;

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
          "Meal Scheduler",
          style: TextStyle(
            color: Tcolor.black,
            fontSize: mediaWidth * 0.046, // Adjusted font size
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Select Date:',
              style: TextStyle(fontSize: 18),
            ),
            // Date selection button
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                'Select Date: ${getFormattedDate(_selectedDate)}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select Time:',
              style: TextStyle(fontSize: 18),
            ),
            // Time selection button
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text(
                'Select Time: ${_selectedTime.format(context)}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Enter Meal Name:',
              style: TextStyle(fontSize: 18),
            ),
            // Input field for workout
            TextField(
              controller: _mealController,
              decoration: InputDecoration(
                hintText: 'Enter Meal',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _saveWorkout(context),
              child: Text('Save Meal'),
            ),
          ],
        ),
      ),
    );
  }

  String getFormattedDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
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
