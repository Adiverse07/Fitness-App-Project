import 'package:fitness_app/common_widget/round_button.dart';
import 'package:fitness_app/common_widget/round_button2.dart';
import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../view/meal_planner/resultpage.dart';

class MealRecommendCell extends StatelessWidget {
  final Map fObj;
  final int index;
  final List recommendArr;
  final Function(String) getRecipe;
  final Function(String) addToRecentSearches;

  const MealRecommendCell({
    Key? key,

    required this.fObj,
    required this.index,
    required this.recommendArr,
    required this.getRecipe,
    required this.addToRecentSearches,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    bool isEvent = index % 2 == 0;
    return Container(
      margin: const EdgeInsets.all(5),
      width: media.width * 0.5,
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
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            fObj["image"].toString(),
            width: media.width * 0.3,
            height: media.width * 0.25,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              fObj["name"],
              style: TextStyle(
                color: Tcolor.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "${fObj["size"]} | ${fObj["time"]} | ${fObj["kcal"]}",
              style: TextStyle(color: Tcolor.gray, fontSize: 12),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              width: 90,
              height: 35,
              child: RoundButton2(
                fontSize: 12,
                type: isEvent
                    ? RoundButtonType.bgGradient
                    : RoundButtonType.bgSGradient,
                title: "View",
                onPressed: () async {
                  String recommendName = recommendArr[index]["name"].toString();
                  List<Map<String, dynamic>> recipesData =
                  await getRecipe(recommendName);
                  addToRecentSearches(recommendName);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultPage(
                        recipesData: recipesData,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
