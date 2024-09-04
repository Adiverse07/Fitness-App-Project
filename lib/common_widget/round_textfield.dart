import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class RoundTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hinttext;
  final String icon;
  final EdgeInsets? margin;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? rightIcon;

  const RoundTextField({
    Key? key,
    required this.hinttext,
    required this.icon,
    this.controller,
    this.margin,
    this.keyboardType,
    this.obscureText = false,
    this.rightIcon,
  });

  @override
  State<RoundTextField> createState() => _RoundTextFieldState();
}

class _RoundTextFieldState extends State<RoundTextField> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: media.width * 0.85,
          margin: widget.margin,
          decoration: BoxDecoration(
            color: Tcolor.lightgray,
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: widget.hinttext,
              suffixIcon: widget.rightIcon,
              hintStyle: TextStyle(color: Tcolor.lightgray2, fontSize: 15),
              prefixIcon: Container(
                alignment: Alignment.center,
                height: media.width * 0.05,
                width: media.width * 0.05,
                child: Image.asset(
                  widget.icon,
                  width: media.width * 0.05,
                  fit: BoxFit.contain,
                  color: Tcolor.gray,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
