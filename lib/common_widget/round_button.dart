import 'package:flutter/material.dart';
import '../common/color_extension.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String? icon;
  final double? fontSize; // Optional font size parameter
  final FontWeight? fontWeight; // Optional font weight parameter
  final Gradient? backgroundGradient; // Optional background gradient parameter
  final bool loading; // Optional loading parameter

  const RoundButton({
    required this.text,
    required this.onPressed,
    this.icon,
    this.fontSize,
    this.fontWeight,
    this.backgroundGradient,
    this.loading = false, // Default loading state is false
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final defaultFontSize = 16.0; // Default font size

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: backgroundGradient ?? LinearGradient(
          colors: Tcolor.primaryG, // Default gradient colors
        ),
        boxShadow: [
          BoxShadow(
            color: Tcolor.primaryColor1.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 1.5),
          ),
        ],
      ),
      width: media.width * 0.85,
      height: media.width * 0.15,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // primary: Colors.transparent,
          // onPrimary: Colors.transparent,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: loading ? null : onPressed, // Disable button when loading
        child: loading // If loading, show CircularProgressIndicator
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : icon != null
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon!,
              width: media.width * 0.065,
              height: media.width * 0.065,
              fit: BoxFit.contain,
              color: Colors.white,
            ),
            SizedBox(
              width: media.width * 0.02,
            ),
            Text(
              text,
              style: TextStyle(
                fontWeight: fontWeight ?? FontWeight.w700,
                fontSize: fontSize ?? defaultFontSize,
                color: Colors.white,
              ),
            ),
          ],
        )
            : Text(
          text,
          style: TextStyle(
            fontWeight: fontWeight ?? FontWeight.w700,
            fontSize: fontSize ?? defaultFontSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
