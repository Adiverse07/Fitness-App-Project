import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class Navbar_Button extends StatelessWidget {
  final String icon;
  final String selectIcon;
  final VoidCallback onTap;
  final bool isActive;
  const Navbar_Button({
    super.key,
    required this.icon,
    required this.selectIcon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isActive ? selectIcon : icon,
            width: 25,
            height: 24,
            // fit: BoxFit.fitWidth,
          ),
          SizedBox(
            height: isActive ? 8 : 12,
          ),
          if (isActive)
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: Tcolor.secondaryG,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            )
        ],
      ),
    );
  }
}
