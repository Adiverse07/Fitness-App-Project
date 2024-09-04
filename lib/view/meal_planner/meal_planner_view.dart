import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import  '../../common/color_extension.dart';
import '../../common_widget/find_eat_cell.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_button2.dart';
import '../../common_widget/today_meal_row.dart';
import '../dashboard/home/chatpage.dart';
import 'meal_food_details_view.dart';
import 'meal_schedule.dart';
import 'meal_schedule_view.dart';

class MealPlannerView extends StatefulWidget {
  const MealPlannerView({super.key});

  @override
  State<MealPlannerView> createState() => _MealPlannerViewState();
}

class _MealPlannerViewState extends State<MealPlannerView> {

  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize FirebaseAuth
  User? _currentUser; // Declare a User variable

  @override
  void initState() {
    super.initState();
    _getUser(); // Retrieve current user when the widget is initialized
  }

  void _getUser() {
    _currentUser = _auth.currentUser;
  }

  String selectedOptionMeals = "Breakfast";
  List todayMealArr = [
    {"name": "Salad", "image": "assets/images/salad.png", "time": "28/05/2023 07:00 AM"},
    {"name": "Lowfat Milk", "image": "assets/images/m_2.png", "time": "28/05/2023 08:00 AM"},
  ];
  List todayMealArr1 = [
    {"name": "Oatmeal", "image": "assets/images/oatmeal.png", "time": "28/05/2023 07:00 AM"},
    {"name": "Orange", "image": "assets/images/orange.png", "time": "28/05/2023 08:00 AM"},
  ];
  List todayMealArr2 = [
    {"name": "Chicken", "image": "assets/images/chicken.png", "time": "28/05/2023 07:00 AM"},
    {"name": "Salad", "image": "assets/images/salad.png", "time": "28/05/2023 08:00 AM"},
  ];
  List findEatArr = [
    {"name": "Breakfast", "image": "assets/images/m_3.png", "number": "120+ Foods"},
    {"name": "Lunch", "image": "assets/images/m_4.png", "number": "130+ Foods"},
  ];

  List selectedMealList() {
    switch (selectedOptionMeals) {
      case "Breakfast":
        return todayMealArr;
      case "Lunch":
        return todayMealArr1;
      case "Dinner":
        return todayMealArr2;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Tcolor.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Meal Planner",
          style: TextStyle(
              color: Tcolor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        automaticallyImplyLeading: false, // Add this line to remove the back arrow

        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => const ChatPage(),
        //           ),
        //         );
        //       },
        //       icon: Image.asset(
        //         "assets/images/chat.png",
        //         width: screenwidth * 0.0636390911,
        //         height: screenheight * 0.0291341004,
        //         fit: BoxFit.fitHeight,
        //       ))
        // ],
      ),

      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Schedule your Meal here !",
                        style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: media.width * 0.05,
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(vertical: media.width*0.037,horizontal: media.width*0.06),
                    decoration: BoxDecoration(
                        color: Tcolor.primaryColor2.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily Meal Schedule",
                          style: TextStyle(
                              color: Tcolor.black,
                              fontSize: media.width*0.036,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        SizedBox(
                          width: 85,
                          height: 35,
                          child:
                          RoundButton(
                            text: "Check",
                            backgroundGradient: LinearGradient(
                              colors: Tcolor.primaryG,
                            ),
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => meal_schedule_view(
                                    userId: _currentUser != null
                                        ? _currentUser!.uid
                                        : '',
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),

                  ),

                  SizedBox(
                    height: media.width * 0.05,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today Meals",
                        style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: Tcolor.primaryG),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: selectedOptionMeals,
                            items: [
                              "Breakfast",
                              "Lunch",
                              "Dinner",
                            ]
                                .map((name) => DropdownMenuItem(
                              value: name,
                              child: Text(
                                name,
                                style: TextStyle(
                                    color: Tcolor.lightgray, fontSize: 14),
                              ),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedOptionMeals = value as String;
                              });
                            },
                            icon: Icon(Icons.expand_more, color: Tcolor.white),
                            hint: Text(
                              selectedOptionMeals,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Tcolor.white, fontSize: 12),
                            ),
                            dropdownColor: Tcolor.primaryColor1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),

                  ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: selectedMealList().length,
                      itemBuilder: (context, index) {
                        var mObj = selectedMealList()[index] as Map? ?? {};
                        return TodayMealRow(
                          mObj: mObj,
                        );
                      }),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Find Something to Eat",
                style: TextStyle(
                    color: Tcolor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: media.width * 0.55,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: findEatArr.length,
                  itemBuilder: (context, index) {
                    var fObj = findEatArr[index] as Map? ?? {};
                    return FindEatCell(index: index, fObj: fObj);
                  }),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}


