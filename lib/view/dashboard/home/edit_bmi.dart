import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../common/color_extension.dart';
import '../../../common_widget/round_button.dart';

class EditBMI extends StatefulWidget {
  final Function(String feet, String inches, String weight) onSave; // Change double to String

  const EditBMI({Key? key, required this.onSave}) : super(key: key);

  @override
  _EditBMIState createState() => _EditBMIState();
}


class _EditBMIState extends State<EditBMI> {

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  late User _currentUser; // To store the current user

  var hFT;
  var hIN;
  var W;


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

          feetController.text = hFT; // Example old value for feet
          inchesController.text = hIN; // Example old value for inches
          weightController.text = W;
        });
      }
    }, onError: (error) {
      print('Error fetching user data: $error');
    });
  }


  TextEditingController feetController = TextEditingController();
  TextEditingController inchesController = TextEditingController();
  TextEditingController weightController = TextEditingController();

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
          "Edit BMI",
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
              'Edit Height:',
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
                        TextField(
                          controller: feetController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: 'Enter feet',
                            border: InputBorder.none,),
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
                        TextField(
                          controller: inchesController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: 'Enter inches',
                            border: InputBorder.none,),

                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Edit Weight:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Tcolor.primaryColor2.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Enter weight in KG',
                  border: InputBorder.none,),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: 100,
                height: 40,
                child: RoundButton(
                  text: "Save",
                  backgroundGradient: LinearGradient(
                    colors: Tcolor.primaryG,
                  ),
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  onPressed: () {
                    double feet = double.tryParse(feetController.text) ?? 0;
                    double inches = double.tryParse(inchesController.text) ?? 0;
                    double weight = double.tryParse(weightController.text) ?? 0;
                    widget.onSave(
                      feet.toString(), // Convert double to String
                      inches.toString(), // Convert double to String
                      weight.toString(), // Convert double to String
                    );
                    Navigator.pop(context); // Navigate back after saving
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
