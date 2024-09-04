import 'package:flutter/material.dart';

import '../../../common/color_extension.dart';
import '../../meal_planner/meal_planner_view.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tcolor.secondaryColor1,
      body: MealPlannerView(),
    );  }
}
