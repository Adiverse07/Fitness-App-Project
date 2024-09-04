import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication package
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  String _data = '';
  late User _currentUser; // To store the current user

  @override
  void initState() {
    super.initState();
    _getCurrentUser(); // Fetch the current user on initialization
  }

  void _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
      _listenToUserData(user.uid); // Start listening to user data
    }
  }

  void _listenToUserData(String userId) {
    _databaseReference.child('Users').child(userId).onValue.listen((event) {
      // Convert the event snapshot to DataSnapshot
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        // Cast snapshot value to Map<dynamic, dynamic>
        Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;
        // Use null-aware operators (??) to handle nullable values
        String firstName = userData['firstname'] ?? '';
        String lastName = userData['lastname'] ?? '';
        setState(() {
          // Update the _data string to display first and last name of the current user
          _data = '$firstName $lastName';
        });
      }
    }, onError: (error) {
      print('Error fetching user data: $error');
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Data from Firebase Realtime Database:',
            ),
            Text('Data: $_data'),
          ],
        ),
      ),
    );
  }
}
