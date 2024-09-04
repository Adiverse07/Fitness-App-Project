import 'package:fitness_app/view/login/benefits.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../common_widget/round_textfield.dart';

const List<String> list = <String>['Male', 'Female'];

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  var bmi;

  void storeUserData() {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get user ID
      String userId = user.uid;

      // Calculate BMI
      var wt = weight.text.toString();
      var ft = heightFT.text.toString();
      var inch = heightIN.text.toString();

      if (heightFT.text.isNotEmpty &&
          heightIN.text.isNotEmpty &&
          weight.text.isNotEmpty) {
        var iWt = int.parse(wt);
        var iFt = int.parse(ft);
        var iInch = int.parse(inch);

        var tInch = (iFt * 12) + iInch;

        var tCm = tInch * 2.54;

        var tM = tCm / 100;

        bmi = (iWt / (tM * tM)).toStringAsFixed(
            1); // Format BMI with 1 digit after the decimal point
      } else {
        // Show error message if any field is empty
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fields cannot be empty.'),
          ),
        );
        return;
      }

      // Reference to the database
      DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child('Users').child(userId);

      // Data to be updated
      Map<String, dynamic> userData = {
        'gender': dropdownValue,
        'dateOfBirth': datepicked,
        'weight': weight.text,
        'heightFT': heightFT.text,
        'heightIN': heightIN.text,
        'BMI': bmi,
      };

      // Update data in the database
      userRef.update(userData).then((_) {
        print('Data updated successfully!');
        // Navigate to the next page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const benefits(),
          ),
        );
      }).catchError((error) {
        print('Failed to update data: $error');
        // Handle error
      });
    }
  }

  String dropdownValue = list.first;

  TextEditingController date = TextEditingController();
  TextEditingController heightFT = TextEditingController();
  TextEditingController heightIN = TextEditingController();
  TextEditingController weight = TextEditingController();

  String datepicked = '';

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //      datepicked = "${picked.day}/${picked.month}/${picked.year}";
  //     });
  //   }
  // }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = DateTime(now.year - 18, now.month, now.day);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 100),
      lastDate: initialDate,
    );
    if (picked != null) {
      setState(() {
        datepicked = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/complete_profile.png",
                  width: media.width,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Text(
                  "Let’s complete your profile",
                  style: TextStyle(
                      color: Tcolor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "It will help us to know more about you!",
                  style: TextStyle(color: Tcolor.gray, fontSize: 12),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Tcolor.lightgray,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Image.asset(
                                  "assets/images/gender.png",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                  color: Tcolor.gray,
                                )),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  itemHeight: 55,
                                  value: dropdownValue,
                                  icon: Image.asset(
                                      "assets/images/arrowdown.png",
                                      width: media.width * 0.05),
                                  elevation: 16,
                                  style: TextStyle(
                                      color: Tcolor.gray,
                                      fontSize: 14), // Adjust style here
                                  onChanged: (String? value) {
                                    // Handle the change here
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                  isExpanded: true,
                                  hint: Text(
                                    "Choose Gender",
                                    style: TextStyle(
                                        color: Tcolor.gray, fontSize: 12),
                                  ),
                                  items: ["Male", "Female"]
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            color: Tcolor.gray, fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await _selectDate(
                              context); // Call the _selectDate method
                        },
                        child: Container(
                          width: media.width * 0.85,
                          height: media.width * 0.145,
                          decoration: BoxDecoration(
                            color: Tcolor.lightgray,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 17, horizontal: 14),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await _selectDate(
                                        context); // Call the _selectDate method
                                  },
                                  child: ImageIcon(
                                    AssetImage('assets/images/calendar.png'),
                                    size: 24,
                                    color: Tcolor
                                        .gray, // Color of the icon, optional
                                  ),
                                ),
                                SizedBox(
                                  width: media.width * 0.032,
                                ),
                                Text(
                                  datepicked.isNotEmpty
                                      ? datepicked
                                      : "Date of Birth",
                                  style: TextStyle(
                                      color: Tcolor.lightgray2,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:
                                // RoundTextField(
                                //   controller: txtDate,
                                //   hitText: "Your Weight",
                                //   icon: "assets/images/weight.png",
                                // ),

                                RoundTextField(
                              controller: weight,
                              hinttext: "Your Weight",
                              icon: "assets/images/weight.png",
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: Tcolor.secondaryG,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "KG",
                              style:
                                  TextStyle(color: Tcolor.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextField(
                              controller: heightFT,
                              hinttext: "Your Height In Feet",
                              icon: "assets/images/swap.png",
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: Tcolor.secondaryG,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "FT",
                              style:
                                  TextStyle(color: Tcolor.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextField(
                              controller: heightIN,
                              hinttext: "Your Height In Inches ",
                              icon: "assets/images/swap.png",
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: Tcolor.secondaryG,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "IN",
                              style:
                                  TextStyle(color: Tcolor.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.07,
                      ),
                      RoundButton(
                        text: "Next >",
                        onPressed: () {
                          var wt = weight.text.toString();
                          var ft = heightFT.text.toString();
                          var inch = heightIN.text.toString();

                          if (heightFT.text.isEmpty ||
                              heightIN.text.isEmpty ||
                              weight.text.isEmpty) {
                            // Show error message if any field is empty
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Fields cannot be empty.'),
                              ),
                            );
                          } else {
                            // Proceed with storing user data and navigating to the next page
                            storeUserData();
                          }
                          // Redirect to another page after registration
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  benefits(), // Replace YourSecondPage() with the desired page
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
