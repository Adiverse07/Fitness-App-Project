import 'package:fitness_app/view/on_boarding/onb2/onb2_page.dart';
import 'package:fitness_app/view/on_boarding/onb3/onb3_view.dart';
import 'package:flutter/material.dart';
import '../../../common/color_extension.dart';

class OnB2_View extends StatelessWidget {
  const OnB2_View({super.key});

  @override
  Widget build(BuildContext context) {
    // var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Tcolor.white,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          OnB2_Page(),
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    color: Tcolor.primaryColor1,
                    value: 0.50,
                    strokeWidth: 2,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Tcolor.primaryColor1,
                      borderRadius: BorderRadius.circular(50)),
                  child: IconButton(
                    icon: Icon(
                      Icons.navigate_next,
                      color: Tcolor.white,
                    ),
                    color: Tcolor.primaryColor1,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OnB3_View(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
