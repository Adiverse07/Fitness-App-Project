import 'package:flutter/material.dart';

import '../common/color_extension.dart';


enum RoundButtonType { bgGradient, bgSGradient , textGradient }

class RoundButton2 extends StatelessWidget {
  final String title;
  final RoundButtonType type;
  final VoidCallback onPressed;
  final double fontSize;
  final double elevation;
  final FontWeight fontWeight;

  const RoundButton2(
      {super.key,
        required this.title,
        this.type = RoundButtonType.bgGradient,
        this.fontSize = 16,
        this.elevation = 1,
        this.fontWeight= FontWeight.w700,
        required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: type == RoundButtonType.bgSGradient ? Tcolor.secondaryG :  Tcolor.primaryG,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: type == RoundButtonType.bgGradient ||  type == RoundButtonType.bgSGradient
              ? const [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 0.5,
                offset: Offset(0, 0.5))
          ]
              : null),
      child: MaterialButton(
        onPressed: onPressed,
        height: 50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        textColor: Tcolor.primaryColor1,
        minWidth: double.maxFinite,
        elevation: type == RoundButtonType.bgGradient ||  type == RoundButtonType.bgSGradient ? 0 : elevation,
        color: type == RoundButtonType.bgGradient ||  type == RoundButtonType.bgSGradient
            ? Colors.transparent
            : Tcolor.white,
        child: type == RoundButtonType.bgGradient ||  type == RoundButtonType.bgSGradient
            ? Text(title,
            style: TextStyle(
                color: Tcolor.white,
                fontSize: fontSize,
                fontWeight: fontWeight))
            : ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
                colors: Tcolor.primaryG,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight)
                .createShader(
                Rect.fromLTRB(0, 0, bounds.width, bounds.height));
          },
          child: Text(title,
              style: TextStyle(
                  color:  Tcolor.primaryColor1,
                  fontSize: fontSize,
                  fontWeight: fontWeight)),
        ),
      ),
    );
  }
}