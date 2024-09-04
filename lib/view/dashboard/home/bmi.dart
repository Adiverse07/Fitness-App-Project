import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import '../../../common/color_extension.dart';
import '../../../common_widget/round_button.dart';
import 'edit_bmi.dart'; // Import the edit page

class BMI extends StatefulWidget {
  const BMI({Key? key}) : super(key: key);

  @override
  State<BMI> createState() => _BMIState();
}

class _BMIState extends State<BMI> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  late User _currentUser; // To store the current user

  var hFT;
  var hIN;
  var W;
  var BMI;

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
        var hft = userData['heightFT'] ?? '';
        var hin = userData['heightIN'] ?? '';
        var w = userData['weight'] ?? '';
        var bmi = userData['BMI'] ?? '';
        setState(() {
          // Update the _data string to display first and last name of the current user
          hFT = '$hft';
          hIN = '$hin';
          W = '$w';
          BMI = '$bmi';
        });
      }
    }, onError: (error) {
      print('Error fetching user data: $error');
    });
  }

  void _updateUserData(double feet, double inches, double weight) {
    String userId = _currentUser.uid;
    double newBMI = calculateBMI(feet, inches, weight);

    // Round the BMI value to one decimal place
    newBMI = double.parse(newBMI.toStringAsFixed(1));

    // Convert double values to strings for updating Firebase
    String feetString = feet.toString();
    String inchesString = inches.toString();
    String weightString = weight.toString();
    String newBMIString = newBMI.toString();

    _databaseReference.child('Users').child(userId).update({
      'heightFT': feetString,
      'heightIN': inchesString,
      'weight': weightString,
      'BMI': newBMIString,
    }).then((_) {
      setState(() {
        hFT = feetString;
        hIN = inchesString;
        W = weightString;
        BMI = newBMIString;
      });
    }).catchError((error) {
      print('Failed to update user data: $error');
    });
  }



  double calculateBMI(double feet, double inches, double weight) {
    double heightInMeters = (feet * 12 + inches) * 0.0254; // Convert height to meters
    double bmi = weight / (heightInMeters * heightInMeters);
    return double.parse(bmi.toStringAsFixed(1)); // Round BMI to one decimal place
  }

  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
    height: mediaWidth * 0.1,
    width: mediaWidth * 0.1,
    alignment: Alignment.center,
    decoration: BoxDecoration(
    color: Tcolor.lightgray,
    borderRadius: BorderRadius.circular(mediaWidth * 0.025),
    ),
    child: Image.asset(
    "assets/images/black_btn.png",
    width: mediaWidth * 0.038,
    height: mediaWidth * 0.038,
    fit: BoxFit.contain,
    ),
    ),
    ),
    title: Text(
    "BMI Details",
    style: TextStyle(
    color: Tcolor.black,
    fontSize: mediaWidth * 0.046,
    fontWeight: FontWeight.w700,
    ),
    ),
    ),
      backgroundColor: Tcolor.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your BMI is:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              width: 173,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Tcolor.primaryColor2.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    '$BMI', // Display BMI here
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Height:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Tcolor.primaryColor2.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Feet',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '$hFT', // Display feet value here
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Tcolor.primaryColor2.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Inches',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '$hIN', // Display inches value here
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Weight:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              width: 173,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Tcolor.primaryColor2.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'KG',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '$W', // Display weight value here
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: 100,
                height: 40,
                child: RoundButton(
                  text: "Edit",
                  backgroundGradient: LinearGradient(
                    colors: Tcolor.primaryG,
                  ),
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditBMI(
                        onSave: (feet, inches, weight) {
                          _updateUserData(
                            double.tryParse(feet) ?? 0,
                            double.tryParse(inches) ?? 0,
                            double.tryParse(weight) ?? 0,
                          );
                        },
                      )),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

