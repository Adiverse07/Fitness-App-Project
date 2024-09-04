import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../dashboard/home/home.dart';
import '../on_boarding/onb1/onb1_view.dart';
// import '../main_tab/main_tab_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {

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
        setState(() {
          // Update the _data string to display first and last name of the current user
          _data = '$firstName';
        });
      }
    }, onError: (error) {
      print('Error fetching user data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SafeArea(
        child: Container(
          width: media.width,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: media.width * 0.1,
              ),
              Image.asset(
                "assets/images/welcome.png",
                width: media.width * 0.75,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: media.width * 0.1,
              ),
              Text(
                "Welcome, $_data",
                style: TextStyle(
                    color: Tcolor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "You are all set now, let’s reach your\ngoals together with us",
                textAlign: TextAlign.center,
                style: TextStyle(color: Tcolor.gray, fontSize: 12),
              ),
              const Spacer(),

              // RoundButton(
              //     title: "Go To Home",
              //     onPressed: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => const MainTabView()));
              //     }),

              RoundButton(
                text: "Go To Home",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                },
              ),

            ],
          ),
        ),

      ),
    );
  }
}