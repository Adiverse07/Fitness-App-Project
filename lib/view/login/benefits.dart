import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitness_app/common/color_extension.dart';
import 'package:fitness_app/view/login/login_view.dart';
import 'package:flutter/material.dart';
import '../../common_widget/round_button.dart';
import 'complete_profile_view.dart';

class benefits extends StatefulWidget {
  const benefits({super.key});

  @override
  State<benefits> createState() => _benefitsState();
}

class _benefitsState extends State<benefits> {
  CarouselController buttonCarouselController = CarouselController();
  List goalArr = [
    {
      "image": "assets/images/goal_3.png",
      "title": "Lose a Fat",
      "subtitle":
          "I have over 20 lbs to lose. I want to \ndrop all this fat and gain muscle \nmass"
    },
    {
      "image": "assets/images/goal_2.png",
      "title": "Lean & Tone",
      "subtitle":
          "I’m “skinny fat”. look thin but have \nno shape. I want to add learn \nmuscle in the right way"
    },
    {
      "image": "assets/images/goal_1.png",
      "title": "Improve Shape",
      "subtitle":
          "I have a low amount of body fat \nand need / want to build more \nmuscle"
    }
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: CarouselSlider(
                items: goalArr
                    .map(
                      (gObj) => Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: Tcolor.primaryG,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(25)),
                        padding: EdgeInsets.symmetric(
                          vertical: media.width * 0.1,
                          horizontal: 25,
                        ),
                        alignment: Alignment.center,
                        child: FittedBox(
                          child: Column(
                            children: [
                              Image.asset(
                                gObj["image"].toString(),
                                width: media.width * 0.7,
                                fit: BoxFit.fitWidth,
                              ),
                              SizedBox(
                                height: media.width * 0.1,
                              ),
                              Text(
                                gObj["title"].toString(),
                                style: TextStyle(
                                  color: Tcolor.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Container(
                                width: media.width * 0.15,
                                height: 1,
                                color: Tcolor.white,
                              ),
                              SizedBox(
                                height: media.width * 0.06,
                              ),
                              Text(
                                gObj["subtitle"].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Tcolor.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.75,
                  aspectRatio: 0.74,
                  initialPage: 2,
                ),
              ),
            ),
            SizedBox(
              width: media.width,
              child: Column(
                children: [
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Text(
                    "Benefits",
                    style: TextStyle(
                      color: Tcolor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Following are the Pros of using this app !",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Tcolor.black,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  RoundButton(
                    text: "Confirm",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
