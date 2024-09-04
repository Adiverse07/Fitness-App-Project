import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class OnB1_Page extends StatefulWidget {
  const OnB1_Page({Key? key}) : super(key: key);

  @override
  _OnB1_PageState createState() => _OnB1_PageState();
}

class _OnB1_PageState extends State<OnB1_Page> {
  late AssetImage _image;

  @override
  void initState() {
    super.initState();
    _preloadAssets();
  }

  Future<void> _preloadAssets() async {
    _image = AssetImage('assets/images/on_1.png');
    await precacheImage(_image, context);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: media.width,
        height: media.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: _image,
              width: media.width,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(
              height: media.width * 0.1,
            ),
            Container(
              margin: const EdgeInsets.only(left: 30),
              child: Text(
                "Track Your Goal",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 25, 0, 0),
              child: Text(
                "Don't worry if you have trouble determining \nyour goals, We can help you determine your \ngoals and track your goals",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
