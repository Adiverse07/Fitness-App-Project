import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class a extends StatefulWidget {
  const a({super.key});

  @override
  State<a> createState() => _aState();
}

class _aState extends State<a> {

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  String _data = '';
  late User _currentUser; // To store the current user
  late int _weight = 0;// Initialize _weight with an empty string


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
        int weight = userData['weight'] ?? '';
        setState(() {
          _data = '$firstName $lastName';
          _weight = weight;

        });
      }
    }, onError: (error) {
      print('Error fetching user data: $error');
    });
  }




  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            width:200,
            height: 200,
            color: Colors.yellow,
            child: Text(
              "$_data $_weight"
            ),
          ),
        ),
      ),
    );
  }
}
