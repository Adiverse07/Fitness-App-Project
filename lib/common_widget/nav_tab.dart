import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class NavTab extends StatelessWidget {
  final String selectedImagePath;
  final String unselectedImagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const NavTab({
    required this.selectedImagePath,
    required this.unselectedImagePath,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isSelected ? selectedImagePath : unselectedImagePath,
                width: screenwidth * 0.075,
                height: screenwidth * 0.075,
              ),
            ],
          ),
          if (isSelected)
            Positioned(
              bottom: 0,
              left: 12,
              top: 35,
              child: Container(
                width: screenwidth * 0.015,
                height: screenheight * 0.015,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: Tcolor.secondaryG,
                  ), // Change color as needed
                ),
              ),
            ),
        ],
      ),
    );
  }
}
