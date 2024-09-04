
import 'dart:math';

import 'package:fitness_app/common_widget/exercises_row.dart';
import 'package:flutter/material.dart';

import '../../common/color_extension.dart';

class ExercisesSetSection extends StatelessWidget {
  final Map sObj;
  final Function(Map obj) onPressed;
  const ExercisesSetSection ({super.key, required this.sObj, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var exercisesArr = sObj["set"] as List? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 8,
        ),
        ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: exercisesArr.length,
            itemBuilder: (context, index) {
              var eObj = exercisesArr[index] as Map? ?? {};
              return ExercisesRow(eObj: eObj, onPressed: (){
                  onPressed(eObj);
              },);
            }),
      ],
    );
  }
}