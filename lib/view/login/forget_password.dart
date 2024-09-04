import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';
import 'login_view.dart';
import 'reset_password.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();

  // Function to handle sending password reset email
  Future<void> reset() async {
    try {
      // Send password reset email using FirebaseAuth
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      // Navigate to ResetPassword view after sending email
      Get.offAll(ResetPassword());
    } catch (e) {
      print('Error sending reset email: $e');
      // Show error message if email sending fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send reset email. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Tcolor.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Forget Password",
              style: TextStyle(
                color: Tcolor.black,
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Image indicating password reset
            Container(
              width: screenWidth * 0.42,
              height: screenHeight * 0.20,
              child: Image.asset(
                "assets/images/enter_mail.png",
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              "Enter your registered email below",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Tcolor.gray,
                fontSize: screenWidth * 0.04,
              ),
            ),
            SizedBox(height: screenHeight * 0.06),
            // Input field for email
            RoundTextField(
              controller: emailController,
              hinttext: "Email",
              icon: "assets/images/message.png",
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: screenHeight * 0.01),
            // Text and link to navigate back to login view
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    "Remember the password?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Tcolor.gray,
                      fontSize: screenWidth * 0.036,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(LoginView()),
                  child: Text(
                    " Sign in",
                    style: TextStyle(
                      color: Tcolor.secondaryColor1,
                      decorationColor: Tcolor.lightgray2,
                      fontSize: screenWidth * 0.036,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.350),
            // Button to submit email for password reset
            RoundButton(
              text: "Submit",
              onPressed: () async {
                String email = emailController.text;

                if (email.isEmpty) {
                  // Show error if email field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter your email address.'),
                    ),
                  );
                } else {
                  // Call reset function to send password reset email
                  await reset();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
