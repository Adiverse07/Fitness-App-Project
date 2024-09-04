import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/common_widget/round_button.dart';
import 'package:fitness_app/common_widget/round_textfield.dart';
import 'package:fitness_app/view/login/forget_password.dart';
import 'package:fitness_app/view/login/signup_view.dart';
import 'package:fitness_app/view/login/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../common/color_extension.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();



  // Function to handle signing in
  signup() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);
  }

  // Function to handle back button press
  Future<bool> _onWillPop() async {
    SystemNavigator.pop(); // Exit the app
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                  "Welcome Back",
                  style: TextStyle(
                    color: Tcolor.black,
                    fontSize: screenwidth * 0.05,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: screenheight * 0.04,
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
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
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
                  height: screenheight * 0.015,
                ),
                GestureDetector(
                  onTap: (() => Get.to(ForgetPassword())),
                  child: Text(
                    "Forgot your password?",
                    style: TextStyle(
                      color: Tcolor.lightgray2,
                      decoration: TextDecoration.underline,
                      decorationColor: Tcolor.lightgray2,
                      fontSize: screenwidth * 0.036,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenheight * 0.453,
                ),
                // Button for login
                RoundButton(
                  text: "Login",
                  onPressed: () async {
                    if (emailController.text.isEmpty &&
                        passwordController.text.isEmpty) {
                      // Show error message if the text field is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter your credentials.'),
                        ),
                      );
                    } else {
                      try {
                        // Attempt to sign in with email and password
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );

                        // If sign in is successful, navigate to home page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeView()),
                        );
                      } catch (e) {
                        // Handle authentication errors, including wrong password
                        String errorMessage =
                            'Wrong Credentials, please try again.';
                        if (e is FirebaseAuthException) {
                          if (e.code == 'user-not-found' ||
                              e.code == 'wrong-password') {
                            errorMessage = 'Invalid email or password.';
                          }
                        }
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage),
                          ),
                        );
                      }
                    }
                  },
                  icon: "assets/images/login.png",
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
                      "Don't have an account yet?",
                      style: TextStyle(
                        fontSize: screenwidth * 0.036,
                      ),
                    ),
                    GestureDetector(
                      onTap: (() => Get.to(SignUpView())),
                      child: Text(
                        " Register",
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
      ),
    );
  }
}
