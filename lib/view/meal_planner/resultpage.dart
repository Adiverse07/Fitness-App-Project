import 'package:fitness_app/view/meal_planner/model.dart';
import 'package:fitness_app/view/meal_planner/recipe_view.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/view/meal_planner/model.dart';
import 'package:fitness_app/view/meal_planner/meal_food_details_view.dart';
import  '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widget/round_button2.dart';
class ResultPage extends StatefulWidget {
  final List<Map<String, dynamic>> recipesData;

  const ResultPage({Key? key, required this.recipesData}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  _openYouTube(String query) async {
    query = query.replaceAll(' ', '+'); // Replace spaces with '+'
    String url = 'https://www.youtube.com/results?search_query=$query'+' recipe';
    if (await canLaunchUrl( Uri.parse(url))) {
      await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.inAppWebView
      );
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Results'),
      ),
      backgroundColor: Colors.grey[200],
      body: ListView.builder(
        itemCount: widget.recipesData.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> recipeData = widget.recipesData[index];
          bool isEvent = index % 2 == 0;
          return Container(
            margin: EdgeInsets.all(media.width * 0.02), // Adjust margin based on screen width
            width: media.width * 0.5,
            height: media.width * 0.6,
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
              borderRadius: BorderRadius.circular(media.width * 0.05), // Adjust border radius based on screen width
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: media.width * 0.02),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(media.width * 0.05),
                        // Adjust border radius based on screen width
                        child: Image.network(
                          recipeData["appimgUrl"],
                          width: media.width * 0.4,
                          height: media.width * 0.4,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: media.width * 0.02), // Adjust spacing based on screen width
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: media.width * 0.02), // Adjust padding based on screen width
                        child: Column(

                          children: [
                            Text(
                              recipeData["applabel"].toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: media.width * 0.04, // Adjust font size based on screen width
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: media.width*0.05,
                            ),
                            Text(
                              "Protein: " +
                                  double.parse(recipeData["appProtein"].toString()).toStringAsFixed(3),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: media.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Calories: " +
                                  double.parse(recipeData["appcalories"].toString()).toStringAsFixed(3),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: media.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: media.width*0.05,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 90,
                                    height: 35,
                                    child: RoundButton2(
                                        fontSize: 12,
                                        type: isEvent
                                            ? RoundButtonType.bgGradient
                                            : RoundButtonType.bgSGradient,
                                        title: "Recipe",
                                      onPressed: () {
                                        if (recipeData["appurl"] != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => RecipeView(recipeData["appurl"]),
                                            ),
                                          );
                                        } else {
                                          // Handle the case when appurl is null, such as showing a snackbar or alert
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Recipe URL not available'),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: media.height*0.03,
                                  ),
                                  SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: InkWell(
                                      onTap: (){
                                        String query = recipeData["applabel"].toString();
                                        _openYouTube(query);
                                      },
                                      child: Image(
                                         image: AssetImage('assets/images/youtube.png'),
                                      ),
                                    )
                                  ),

                                ],
                              ),

                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}