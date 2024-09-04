import '../../common/color_extension.dart';
import 'package:flutter/material.dart';

import '../view/meal_planner/food_info_details_view.dart';
import '../view/meal_planner/resultpage.dart';


class PopularMealRow extends StatelessWidget {
  final Map mObj;
  final int index;
  final List recommendArr;
  final Function(String) getRecipe;
  final Function(String) addToRecentSearches;
  const PopularMealRow({Key? key, required this.mObj,required this.recommendArr,
    required this.getRecipe,
    required this.addToRecentSearches,
    required this.index,}) : super(key: key); // Add Key? key here

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Tcolor.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
        child: Row(
          children: [
            Image.asset(
              mObj["image"].toString(),
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mObj["name"].toString(),
                    style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${mObj["size"]} | ${mObj["time"]} | ${mObj["kcal"]}",
                    style: TextStyle(color: Tcolor.gray, fontSize: 12),
                  )
                ],
              ),
            ),
            IconButton(
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
              icon: Image.asset(
                "assets/images/next_icon.png",
                width: 25,
                height: 25,
              ),
            )
          ],
        ));
  }
}
