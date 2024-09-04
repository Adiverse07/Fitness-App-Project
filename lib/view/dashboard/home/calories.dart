import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';

import '../../../common/color_extension.dart';

class UpdateCaloriesPage extends StatefulWidget {
  @override
  _UpdateCaloriesPageState createState() => _UpdateCaloriesPageState();
}

class _UpdateCaloriesPageState extends State<UpdateCaloriesPage> {
  final TextEditingController caloriesController = TextEditingController();
  int newCalories = 0;

  void updateCalories() async {
    try {
      int calories = int.parse(caloriesController.text);

      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Reference to the user's node in the database
        DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users/${user.uid}');

        // Update the "calories" field
        await userRef.update({'calories': calories});

        print('Calories updated successfully!');
      } else {
        print('User not found. Unable to update calories.');
      }
    } catch (e) {
      print('Error updating calories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Tcolor.white,
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
          "Set Calories",
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                // labelText: 'New Calories',
                hintText: 'Enter the calories',
              ),
              onChanged: (value) {
                setState(() {
                  newCalories = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateCalories();
                Navigator.of(context).pop(); // Navigate back to the previous page
              },
              child: Text('Set Calories'),
            ),

          ],
        ),
      ),
    );
  }
}
