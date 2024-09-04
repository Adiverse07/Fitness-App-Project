import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/common_widget/round_button.dart';
import 'package:fitness_app/common_widget/round_textfield.dart';
import 'package:fitness_app/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/color_extension.dart';
import 'package:firebase_database/firebase_database.dart';

import 'complete_profile_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool loading = false; // Flag to track loading state
  final databaseRef = FirebaseDatabase.instance
      .ref('Users'); // Reference to Firebase Realtime Database

  bool _obscureText = true;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signup() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      // After successful authentication, save user information to the database
      if (userCredential.user != null) {
        await databaseRef.child(userCredential.user!.uid).set({
          'firstname': firstNameController.text.toString(),
          'lastname': lastNameController.text.toString(),
          'email': emailController.text.toString(),
          'calories': 0,
          'user_calories':0,
        });

        // Create workouts node for the user
        createWorkoutsNode(userCredential.user!.uid);
      }

      // Navigate to the complete profile view after successful registration
      Get.offAll(CompleteProfileView());
    } catch (e) {
      // Handle registration errors
      print('Error registering user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to register user. Please try again.'),
        ),
      );
    }
  }

  void createWorkoutsNode(String userId) {
    final ref = FirebaseDatabase.instance.reference().child('users/$userId/workouts_count');
    ref.set({
      'Sunday': 0,
      'Monday': 0,
      'Tuesday': 0,
      'Wednesday': 0,
      'Thursday': 0,
      'Friday': 0,
      'Saturday': 0,
    });
  }


  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Tcolor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: screenheight * 0.02,
              ),
              Text(
                "Hey there,",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenwidth * 0.042,
                ),
              ),
              SizedBox(
                height: screenheight * 0.006,
              ),
              Text(
                "Create an account,",
                style: TextStyle(
                  color: Tcolor.black,
                  fontSize: screenwidth * 0.05,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: screenheight * 0.04,
              ),
              // Input field for first name
              RoundTextField(
                controller: firstNameController,
                hinttext: "First Name",
                icon: "assets/images/profile_icon.png",
              ),
              SizedBox(
                height: screenheight * 0.02,
              ),
              // Input field for last name
              RoundTextField(
                controller: lastNameController,
                hinttext: "Last Name",
                icon: "assets/images/profile_icon.png",
              ),
              SizedBox(
                height: screenheight * 0.02,
              ),
              // Input field for email
              RoundTextField(
                controller: emailController,
                hinttext: "Email",
                icon: "assets/images/message.png",
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: screenheight * 0.02,
              ),
              // Input field for password
              RoundTextField(
                controller: passwordController,
                hinttext: "Password",
                icon: "assets/images/lock.png",
                keyboardType: TextInputType.visiblePassword,
                rightIcon: TextButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: Container(
                      alignment: Alignment.center,
                      height: screenheight * 0.05,
                      width: screenwidth * 0.05,
                      child: _obscureText
                          ? Image.asset(
                              "assets/images/hide_password.png",
                              width: screenwidth * 0.06,
                              fit: BoxFit.contain,
                              color: Tcolor.lightgray2,
                            )
                          : Image.asset(
                              "assets/images/show_password.png",
                              width: screenwidth * 0.06,
                              fit: BoxFit.contain,
                              color: Tcolor.lightgray2,
                            )),
                ),
                obscureText: _obscureText,
              ),
              SizedBox(
                height: screenheight * 0.325,
              ),
              // Button for registration
              RoundButton(
                text: "Register",
                loading: loading, // Show loading indicator when loading is true
                onPressed: () async {
                  // Check if any of the text fields is empty
                  if (firstNameController.text.isEmpty ||
                      lastNameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    // Show error message if any of the text fields is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill in all fields.'),
                      ),
                    );
                  } else {
                    // All fields are filled, proceed with registration
                    setState(() {
                      loading = true; // Set loading to true
                    });

                    try {
                      // Proceed with the registration process
                      await signup();

                      // Reset text field controllers
                      firstNameController.clear();
                      lastNameController.clear();
                      emailController.clear();
                      passwordController.clear();

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Registration successful.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } catch (e) {
                      // Handle registration errors
                      print('Error registering user: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Failed to register user. Please try again.'),
                        ),
                      );
                    } finally {
                      // Set loading to false after registration attempt
                      setState(() {
                        loading = false;
                      });
                    }
                  }
                },
              ),
              SizedBox(
                height: screenheight * 0.025,
              ),
              SizedBox(
                width: screenwidth * 0.80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: screenheight * 0.001,
                        color: Tcolor.gray.withOpacity(0.5),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Or",
                        style: TextStyle(
                          color: Tcolor.black,
                          fontSize: screenwidth * 0.034,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: screenheight * 0.001,
                        color: Tcolor.gray.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenheight * 0.018,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontSize: screenwidth * 0.036,
                    ),
                  ),
                  GestureDetector(
                    onTap: (() => Get.to(LoginView())),
                    child: Text(
                      " Login",
                      style: TextStyle(
                        color: Tcolor.secondaryColor1,
                        fontSize: screenwidth * 0.036,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
