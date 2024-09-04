import 'package:fitness_app/view/meal_planner/meal_food_details_view.dart';
import 'package:flutter/material.dart';

import '../../common/color_extension.dart';

class DemoButton extends StatelessWidget {
  const DemoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MealFoodDetailsView(eObj: {"name": "Have some food"})));
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Tcolor.primaryColor1, Tcolor.primaryColor2],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Image.asset(
                'assets/images/search_icon.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Demo')),
      body: DemoButton(),
    ),
  ));
}
