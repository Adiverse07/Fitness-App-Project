import 'package:fitness_app/view/login/forget_password.dart';
import 'package:fitness_app/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Tcolor.white,
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: screenheight * 0.065,
              ),
              Text(
                "Successful",
                style: TextStyle(
                  color: Tcolor.black,
                  fontSize: screenwidth * 0.05,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: screenheight * 0.02,
              ),
              Container(
                // color: Colors.red,
                width: screenwidth * 0.42,
                height: screenheight * 0.20,
                child: Image.asset(
                  "assets/images/success.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(
                height: screenheight * 0.02,
              ),
              Text(
                "Please check your email for create \na new password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Tcolor.gray,
                  fontSize: screenwidth * 0.04,
                ),
              ),
              SizedBox(
                height: screenheight * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Can't get email?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Tcolor.gray,
                      fontSize: screenwidth * 0.036,
                    ),
                  ),
                  GestureDetector(
                    onTap: (() => Get.to(ForgetPassword())),
                    child: Text(
                      " Resubmit",
                      style: TextStyle(
                        color: Tcolor.secondaryColor1,
                        decorationColor: Tcolor.lightgray2,
                        fontSize: screenwidth * 0.036,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenheight * 0.400,
              ),
              RoundButton(
                text: "Back to login",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginView()),
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
