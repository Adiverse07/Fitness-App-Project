import '../../common_widget/round_button.dart';
import 'package:flutter/material.dart';

import  '../../common/color_extension.dart';
import '../view/meal_planner/resultpage.dart';


class MealCategoryCell extends StatelessWidget {
  final Map cObj;
  final int index;
  const MealCategoryCell({Key? key, required this.index, required this.cObj});

  @override
  Widget build(BuildContext context) {
    bool isEvent = index % 2 == 0;
    String categoryName = cObj["name"];
    return Container(
      margin: const EdgeInsets.all(4),
      width: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEvent
              ? [
            Tcolor.primaryColor2.withOpacity(0.5),
            Tcolor.primaryColor1.withOpacity(0.5)
          ]
              : [
            Tcolor.secondaryColor2.withOpacity(0.5),
            Tcolor.secondaryColor1.withOpacity(0.5)
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [


            ClipRRect(
              borderRadius: BorderRadius.circular(17.5),
              child: Container(
                decoration: BoxDecoration(
                  color: Tcolor.white,
                  borderRadius: BorderRadius.circular(17.5),
                ),
                child: Image.asset(
                  cObj["image"].toString(),
                  width: 35,
                  height: 35,
                  fit: BoxFit.contain,
                ),
              ),
            ),


          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              categoryName,
              maxLines: 1,
              style: TextStyle(
                color: Tcolor.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
