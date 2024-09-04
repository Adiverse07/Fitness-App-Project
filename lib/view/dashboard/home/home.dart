import 'package:fitness_app/common/color_extension.dart';
import 'package:fitness_app/common_widget/nav_tab.dart';
import 'package:fitness_app/view/dashboard/home/profile.dart';
import 'package:flutter/material.dart';
import '../../login/a.dart';
import '../../meal_planner/meal_food_details_view.dart';
import '../../on_boarding/onb1/onb1_view.dart';
import 'activity.dart';
import 'camera.dart';
import 'chatpage.dart';
import 'dashboard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  final List<Widget> screens = [
    Dashboard(),
    ActivityTrackerView(),
    ProfileView(),
    Camera(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Dashboard();

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: screenwidth * 0.18,
        height: screenheight * 0.1,
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: FloatingActionButton(
            elevation: 0,
            shape: CircleBorder(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  ChatPage(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Tcolor.primaryColor1, Tcolor.primaryColor2],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Image.asset(
                  'assets/images/search_icon.png',
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: screenheight * 0.075,
        surfaceTintColor: Colors.white,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(
                    width: screenwidth * 0.03,
                  ),

                  NavTab(
                    selectedImagePath: "assets/images/home_selected_icon.png",
                    unselectedImagePath: "assets/images/home_icon.png",
                    isSelected: currentTab == 0,
                    onTap: () {
                      setState(() {
                        currentScreen = Dashboard();
                        currentTab = 0;
                      });
                    },
                  ),

                  SizedBox(
                    width: screenwidth * 0.11,
                  ),

                  NavTab(
                    selectedImagePath:
                        "assets/images/activity_selected_icon.png",
                    unselectedImagePath: "assets/images/activity_icon.png",
                    isSelected: currentTab == 1,
                    onTap: () {
                      setState(() {
                        currentScreen = ActivityTrackerView();
                        currentTab = 1;
                      });
                    },
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NavTab(
                    selectedImagePath: "assets/images/fill_meal.png",
                    unselectedImagePath: "assets/images/meal.png",
                    isSelected: currentTab == 2,
                    onTap: () {
                      setState(() {
                        currentScreen = Camera();
                        currentTab = 2;
                      });
                    },
                  ),
                  SizedBox(
                    width: screenwidth * 0.11,
                  ),

                  NavTab(
                    selectedImagePath:
                        "assets/images/profile_selected_icon.png",
                    unselectedImagePath: "assets/images/profile_icon.png",
                    isSelected: currentTab == 3,
                    onTap: () {
                      setState(() {
                        currentScreen = ProfileView();
                        currentTab = 3;
                      });
                    },
                  ),

                  SizedBox(
                    width: screenwidth * 0.03,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
