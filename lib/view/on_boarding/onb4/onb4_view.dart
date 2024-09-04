import 'package:fitness_app/view/login/login_view.dart';
import 'package:fitness_app/view/login/benefits.dart';
import 'package:fitness_app/view/on_boarding/onb4/onb4_page.dart';
import 'package:flutter/material.dart';
import '../../../common/color_extension.dart';
import '../../login/signup_view.dart';

class OnB4_View extends StatelessWidget {
  const OnB4_View({super.key});

  @override
  Widget build(BuildContext context) {
    // var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Tcolor.white,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          OnB4_Page(),
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
                    value: 1,
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
                          builder: (context) => LoginView(),
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
