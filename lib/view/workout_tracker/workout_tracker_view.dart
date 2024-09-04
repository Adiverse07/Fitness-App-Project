import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/common_widget/round_button.dart';
import 'package:fitness_app/view/workout_tracker/workout_schedule_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common_widget/what_train_row.dart';
import '../dashboard/home/chatpage.dart';
import 'package:firebase_database/firebase_database.dart';


class WorkoutTrackerView extends StatefulWidget {
  const WorkoutTrackerView({super.key});

  @override
  State<WorkoutTrackerView> createState() => _WorkoutTrackerViewState();
}

class _WorkoutTrackerViewState extends State<WorkoutTrackerView> {

  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize FirebaseAuth
  User? _currentUser; // Declare a User variable


  int? mondayCount;
  int? tuesdayCount;
  int? wednesdayCount;
  int? thursdayCount;
  int? fridayCount;
  int? saturdayCount;
  int? sundayCount;

  Future<void> fetchWorkoutData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        DatabaseReference ref = FirebaseDatabase.instance.reference().child(
            'users/$userId/workouts_count');

        ref.onValue.listen((event) {
          if (event.snapshot.value != null) {
            Map<dynamic, dynamic>? workoutsData = event.snapshot.value as Map<
                dynamic,
                dynamic>?;

            if (workoutsData != null) {
              mondayCount = workoutsData['Monday'];
              tuesdayCount = workoutsData['Tuesday'];
              wednesdayCount = workoutsData['Wednesday'];
              thursdayCount = workoutsData['Thursday'];
              fridayCount = workoutsData['Friday'];
              saturdayCount = workoutsData['Saturday'];
              sundayCount = workoutsData['Sunday'];

              setState(() {}); // Update the UI with fetched data
            }
          }
        });
      }
    } catch (e) {
      print('Error fetching workout data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWorkoutData();
    _getUser(); // Retrieve current user when the widget is initialized
  }

  void _getUser() {
    _currentUser = _auth.currentUser;
  }

  LineChartBarData get lineChartBarData1_1 {
    return LineChartBarData(
      isCurved: true,
      color: Colors.white,
      // gradient: LinearGradient(
      //   colors: [
      //     Tcolor.primaryColor2.withOpacity(0.5),
      //     Tcolor.primaryColor1.withOpacity(0.5),
      //   ],
      // ),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: [
        FlSpot(1, sundayCount?.toDouble() ?? 0),
        FlSpot(2, mondayCount?.toDouble() ?? 0),
        FlSpot(3, tuesdayCount?.toDouble() ?? 0),
        FlSpot(4, wednesdayCount?.toDouble() ?? 0),
        FlSpot(5, thursdayCount?.toDouble() ?? 0),
        FlSpot(6, fridayCount?.toDouble() ?? 0),
        FlSpot(7, saturdayCount?.toDouble() ?? 0),
      ],
    );
  }

  List whatArr = [
    {
      "id": 1,
      "image": "assets/images/what_1.png",
      "title": "Fullbody Workout",
      "exercises": "11 Exercises",
      "time": "10 mins"
    },
    {
      "id": 2,
      "image": "assets/images/what_2.png",
      "title": "Lowebody Workout",
      "exercises": "17 Exercises",
      "time": "18 mins"
    },
    {
      "id": 3,
      "image": "assets/images/what_3.png",
      "title": "ABS Workout",
      "exercises": "16 Exercises",
      "time": "20 mins"
    },
    {
      "id": 4,
      "image": "assets/images/what_1.png",
      "title": "Chest Workout",
      "exercises": "11 Exercises",
      "time": "11 mins"
    },
    {
      "id": 5,
      "image": "assets/images/what_2.png",
      "title": "ARM Workout",
      "exercises": "19 Exercises",
      "time": "17 mins"
    },
    {
      "id": 6,
      "image": "assets/images/what_3.png",
      "title": "Shoulder & Back Workout",
      "exercises": "13 Exercises",
      "time": "13 mins"
    }
  ];

  List<int> showingTooltipOnSpots = [21];

  List<FlSpot> get allSpots => const [
    FlSpot(0, 0),
    FlSpot(0, 0),
    FlSpot(0, 0),
    FlSpot(0, 0),
    FlSpot(0, 0),
    FlSpot(0, 0),
    FlSpot(0, 0),
    FlSpot(7, 20),
    FlSpot(8, 25),
    FlSpot(9, 40),
    FlSpot(10, 50),
    FlSpot(11, 35),
    FlSpot(12, 50),
    FlSpot(13, 60),
    FlSpot(14, 40),
    FlSpot(15, 50),
    FlSpot(16, 20),
    FlSpot(17, 25),
    FlSpot(18, 40),
    FlSpot(19, 50),
    FlSpot(20, 35),
    FlSpot(21, 80),
    FlSpot(22, 30),
    FlSpot(23, 20),
    FlSpot(24, 25),
    FlSpot(25, 40),
    FlSpot(26, 50),
    FlSpot(27, 35),
    FlSpot(28, 50),
    FlSpot(29, 60),
    FlSpot(30, 40)
  ];



  @override
  Widget build(BuildContext context) {

    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        spots: allSpots,
        isCurved: true,
        barWidth: 2,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(colors: [
            Tcolor.primaryColor2.withOpacity(0.1),
            Tcolor.primaryColor1.withOpacity(0.1),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        dotData: FlDotData(show: false),
        gradient: LinearGradient(
          colors: Tcolor.primaryG,
        ),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];


    var media = MediaQuery
        .of(context)
        .size;
    var mediaWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Container(
      decoration:
      BoxDecoration(gradient: LinearGradient(colors: Tcolor.primaryG)),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leading: Container(
                margin: const EdgeInsets.all(10),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      height: mediaWidth * 0.1,
                      // Adjusted height
                      width: mediaWidth * 0.1,
                      // Adjusted width
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Tcolor.lightgray,
                        borderRadius: BorderRadius.circular(mediaWidth *
                            0.025), // Adjusted borderRadius
                      ),
                      child: Image.asset(
                        "assets/images/black_btn.png",
                        width: mediaWidth * 0.038, // Adjusted width
                        height: mediaWidth * 0.038, // Adjusted height
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                "Workout Tracker",
                style: TextStyle(
                    color: Tcolor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              // actions: [
              //   InkWell(
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const ChatPage(),
              //         ),
              //       );
              //     },
              //     splashColor: Colors.transparent,
              //     highlightColor: Colors.transparent,
              //     child: Container(
              //       margin: const EdgeInsets.fromLTRB(8, 12, 8, 8),
              //       height: mediaWidth * 0.092,
              //       width: mediaWidth * 0.092,
              //       alignment: Alignment.center,
              //       decoration: BoxDecoration(
              //           color: Tcolor.lightgray,
              //           borderRadius: BorderRadius.circular(10)),
              //       child: Image.asset(
              //         "assets/images/chat.png",
              //         width: 30,
              //         height: 30,
              //         fit: BoxFit.contain,
              //       ),
              //     ),
              //   )
              //
              // ],
            ),
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leadingWidth: 0,
              leading: const SizedBox(),
              expandedHeight: media.width * 0.5,
              flexibleSpace: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: media.width * 0.5,
                width: double.maxFinite,
                child: LineChart(
          LineChartData(
          showingTooltipIndicators:
          showingTooltipOnSpots.map((index) {
          return ShowingTooltipIndicators([
          LineBarSpot(
          tooltipsOnBar,
          lineBarsData.indexOf(tooltipsOnBar),
          tooltipsOnBar.spots[index],
          ),
          ]);
          }).toList(),
          // lineTouchData: LineTouchData(
          //   enabled: true,
          //   handleBuiltInTouches: false,
          //   touchCallback: (FlTouchEvent event,
          //       LineTouchResponse? response) {
          //     if (response == null ||
          //         response.lineBarSpots == null) {
          //       return;
          //     }
          //     if (event is FlTapUpEvent) {
          //       final spotIndex =
          //           response.lineBarSpots!.first.spotIndex;
          //       showingTooltipOnSpots.clear();
          //       setState(() {
          //         showingTooltipOnSpots.add(spotIndex);
          //       });
          //     }
          //   },
          //   mouseCursorResolver: (FlTouchEvent event,
          //       LineTouchResponse? response) {
          //     if (response == null ||
          //         response.lineBarSpots == null) {
          //       return SystemMouseCursors.basic;
          //     }
          //     return SystemMouseCursors.click;
          //   },
          //   getTouchedSpotIndicator: (LineChartBarData barData,
          //       List<int> spotIndexes) {
          //     return spotIndexes.map((index) {
          //       return TouchedSpotIndicatorData(
          //         FlLine(
          //           color: Colors.transparent,
          //         ),
          //         FlDotData(
          //           show: true,
          //           getDotPainter:
          //               (spot, percent, barData, index) =>
          //                   FlDotCirclePainter(
          //             radius: 3,
          //             color: Colors.white,
          //             strokeWidth: 3,
          //             strokeColor: Tcolor.secondaryColor1,
          //           ),
          //         ),
          //       );
          //     }).toList();
          //   },
          // ),
          lineBarsData: lineBarsData1,
          minY: -0.5,
          maxY: 110,
          titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(),
          topTitles: AxisTitles(),
          bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
          ),
          rightTitles: AxisTitles(
          sideTitles: rightTitles,
          )),
          gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          horizontalInterval: 25,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
          return FlLine(
          color: Tcolor.gray.withOpacity(0.15),
          strokeWidth: 2,
          );
          },
          ),
          borderData: FlBorderData(
          show: true,
          border: Border.all(
          color: Colors.transparent,
          ),
          ),
          ),
          )),
            ),
          ];
        },

        body: Container(
          padding: EdgeInsets.symmetric(horizontal: media.width * 0.05),
          decoration: BoxDecoration(
              color: Tcolor.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: media.width * 0.03,),
                  Center(
                    child: Container(
                      width: media.width * 0.15,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Tcolor.lightgray,
                          borderRadius: BorderRadius.circular(3)
                      ),
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: media.width * 0.037,
                        horizontal: media.width * 0.06),
                    decoration: BoxDecoration(
                        color: Tcolor.primaryColor2.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily Workout Schedule",
                          style: TextStyle(
                              color: Tcolor.black,
                              fontSize: media.width * 0.036,
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
                                  builder: (context) =>
                                      workout_schedule_view(
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
                        "What Do You Want to Train",
                        style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: media.width * 0.02,
                  ),
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: whatArr.length,
                      itemBuilder: (context, index) {
                        var wObj = whatArr[index] as Map? ?? {};
                        return WhatTrainRow.abs_workout(wObj: wObj);
                      }),
                  SizedBox(
                    height: media.width * 0.1,
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  List<PieChartSectionData> showingSections() {
    return List.generate(
      2,
          (i) {
        var color0 = Tcolor.secondaryColor1;

        switch (i) {
          case 0:
            return PieChartSectionData(
                color: color0,
                value: 33,
                title: '',
                radius: 55,
                titlePositionPercentageOffset: 0.55,
                badgeWidget: const Text(
                  "20,1",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ));
          case 1:
            return PieChartSectionData(
              color: Colors.white,
              value: 75,
              title: '',
              radius: 45,
              titlePositionPercentageOffset: 0.55,
            );

          default:
            throw Error();
        }
      },
    );
  }

  LineTouchData get lineTouchData1 =>
      LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  List<LineChartBarData> get lineBarsData1 =>
      [
        lineChartBarData1_1,
      ];

  // LineChartBarData get lineChartBarData1_1 =>
  //     LineChartBarData(
  //       isCurved: true,
  //       color: Tcolor.white,
  //       // gradient: LinearGradient(colors: [
  //       //   Tcolor.primaryColor2.withOpacity(0.5),
  //       //   Tcolor.primaryColor1.withOpacity(0.5),
  //       // ]),
  //       barWidth: 2,
  //       isStrokeCapRound: true,
  //       dotData: FlDotData(show: false),
  //       belowBarData: BarAreaData(show: false),
  //       spots: const [
  //         FlSpot(1, 0),
  //         FlSpot(2, 0),
  //         FlSpot(3, 0),
  //         FlSpot(4, 0),
  //         FlSpot(5, 0),
  //         FlSpot(6, 0),
  //         FlSpot(7, 0),
  //       ],
  //     );


  SideTitles get rightTitles =>
      SideTitles(
        getTitlesWidget: rightTitleWidgets,
        showTitles: true,
        interval: 20,
        reservedSize: 40,
      );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0%';
        break;
      case 20:
        text = '20%';
        break;
      case 40:
        text = '40%';
        break;
      case 60:
        text = '60%';
        break;
      case 80:
        text = '80%';
        break;
      case 100:
        text = '100%';
        break;
      default:
        return Container();
    }

    return Text(text,
        style: TextStyle(
          color: Tcolor.white,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }

  SideTitles get bottomTitles =>
      SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: Tcolor.white,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Sun', style: style);
        break;
      case 2:
        text = Text('Mon', style: style);
        break;
      case 3:
        text = Text('Tue', style: style);
        break;
      case 4:
        text = Text('Wed', style: style);
        break;
      case 5:
        text = Text('Thu', style: style);
        break;
      case 6:
        text = Text('Fri', style: style);
        break;
      case 7:
        text = Text('Sat', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }
}