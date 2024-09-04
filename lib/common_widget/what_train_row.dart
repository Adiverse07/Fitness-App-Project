import 'package:fitness_app/common_widget/round_button2.dart';
import 'package:fitness_app/view/dashboard/home/profile.dart';
import 'package:fitness_app/view/workout_tracker/arm_workout.dart';
import 'package:fitness_app/view/workout_tracker/chest_workout.dart';
import 'package:fitness_app/view/workout_tracker/shoulder_workout.dart';
import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../view/workout_tracker/abs_workout.dart';
import '../view/workout_tracker/fullbody.dart';
import '../view/workout_tracker/lowerbody.dart';

class WhatTrainRow extends StatelessWidget {
  final Map wObj;
  const WhatTrainRow.abs_workout({super.key, required this.wObj});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency, // Ensure that the Material widget is transparent
      clipBehavior: Clip.antiAlias, // Clip the ripple effect to the rounded corners
      borderRadius: BorderRadius.circular(15),
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Tcolor.primaryColor2.withOpacity(0.3),
                Tcolor.primaryColor1.withOpacity(0.3)
              ]),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wObj["title"].toString(),
                        style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${wObj["exercises"].toString()} | ${ wObj["time"].toString() }" ,
                        style: TextStyle(
                          color: Tcolor.gray,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 100,
                        height: 30,
                        child: RoundButton2(
                            title: "View More",
                            fontSize: 10,
                            type: RoundButtonType.textGradient,
                            elevation:0.05,
                            fontWeight: FontWeight.w400,
                            onPressed: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) =>  WorkoutDetailView( dObj: wObj, ) ));
                              String exerciseType = wObj["id"].toString();
                              if (exerciseType == "1") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullBody( dObj: wObj, ),
                                  ),
                                );
                              } else if (exerciseType == "2") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LowerBody( dObj: wObj, ),
                                  ),
                                );
                              } else if (exerciseType == "3")  {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ABSWorkout(dObj: wObj,),
                                  ),
                                );
                              }
                              else if (exerciseType == "4")  {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChestWorkout(dObj: wObj,),
                                  ),
                                );
                              }
                              else if (exerciseType == "5")  {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArmWorkout(dObj: wObj,),
                                  ),
                                );
                              }
                              else if (exerciseType == "6")  {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShoulderWorkout(dObj: wObj,),
                                  ),
                                );
                              }
                            }
                            ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.54),
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        wObj["image"].toString(),
                        width: 90,
                        height: 90,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
