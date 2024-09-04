
import 'package:flutter/material.dart';
import '../common/color_extension.dart';

class TodayTargetCell extends StatelessWidget {
  final String icon;
  final String value;
  final String title;
  const TodayTargetCell({super.key, required this.icon, required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Tcolor.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Image.asset(
           icon,
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) {
                  return LinearGradient(
                          colors: Tcolor.primaryG,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)
                      .createShader(
                          Rect.fromLTRB(0, 0, bounds.width, bounds.height));
                },
                child: Text(
                  value,
                  style: TextStyle(
                      color: Tcolor.white.withOpacity(0.7),
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: Tcolor.black,
                  fontSize: 12,
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}