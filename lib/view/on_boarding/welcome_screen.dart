import 'package:fitness_app/common/color_extension.dart';
import 'package:fitness_app/common_widget/round_button.dart';
import 'package:fitness_app/view/on_boarding/onb1/onb1_view.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Welcome_Screen extends StatefulWidget {
  const Welcome_Screen({super.key});

  @override
  State<Welcome_Screen> createState() => _Welcome_ScreenState();
}

class _Welcome_ScreenState extends State<Welcome_Screen> {
  final LinearGradient _gradient = const LinearGradient(
    colors: <Color>[
      Color(0xff9DCEFF),
      Color(0xff92A3FD),
    ],
  );

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SizedBox(
        width: media.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                      child: Text(
                        "Fitness",
                        style: TextStyle(
                          color: Tcolor.black,
                          fontSize: media.width * 0.093,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (Rect rect) {
                        return _gradient.createShader(rect);
                      },
                      child: Text(
                        'X',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: media.width * 0.13,
                            ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Everybody Can Train",
                  style: TextStyle(
                    color: Tcolor.gray,
                    fontSize: media.width * 0.048,
                  ),
                ),

                const Spacer(),

                RoundButton(
                  text: "Get Started",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnB1_View(),
                      ),
                    );
                  },
                ),


                SizedBox(
                  height: media.width * 0.05,
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
