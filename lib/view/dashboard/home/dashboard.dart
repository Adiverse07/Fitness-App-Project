import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:fitness_app/view/workout_tracker/workout_tracker_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import '../../../common/color_extension.dart';
import '../../../common_widget/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'bmi.dart';
import 'dart:async';

import 'calories.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

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
        DatabaseReference ref = FirebaseDatabase.instance.reference().child('users/$userId/workouts_count');

        ref.onValue.listen((event) {
          if (event.snapshot.value != null) {
            Map<dynamic, dynamic>? workoutsData = event.snapshot.value as Map<dynamic, dynamic>?;

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


  late Timer _timer;
  double _ratio = 0.0; // Initialize _ratio with 0.0

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  String _data = '';
  late User _currentUser; // To store the current user
  double? _bmi;
  late int _cal = 0;
  late int _usercal = 0;

  @override
  void initState() {
    super.initState();
    fetchWorkoutData();
    _getCurrentUser(); // Fetch the current user on initialization
    // Initialize timer to update progress bar every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _ratio = calculateRatio();
      });
    });
  }

  LineChartBarData get lineChartBarData1_1 {
    return LineChartBarData(
      isCurved: true,
      gradient: LinearGradient(
        colors: [
          Tcolor.primaryColor2.withOpacity(0.5),
          Tcolor.primaryColor1.withOpacity(0.5),
        ],
      ),
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


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

// Calculate the ratio based on current time within 6 AM to 8 PM
  double calculateRatio() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, 6, 0, 0);
    final end = DateTime(now.year, now.month, now.day, 20, 0, 0);
    final totalDuration = end.difference(start).inSeconds;
    final elapsedDuration = now.difference(start).inSeconds;
    final ratio = elapsedDuration.toDouble() / totalDuration.toDouble();

    // Ensure ratio is between 0 and 1
    return ratio.clamp(0.0, 1.0);
  }


  void _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
      _listenToUserData(user.uid); // Start listening to user data
    }
  }

  void _listenToUserData(String userId) {
    _databaseReference.child('Users').child(userId).onValue.listen((event) {
      // Convert the event snapshot to DataSnapshot
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        // Cast snapshot value to Map<dynamic, dynamic>
        Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;
        // Use null-aware operators (??) to handle nullable values
        String firstName = userData['firstname'] ?? '';
        String lastName = userData['lastname'] ?? '';
        String bmiString = userData['BMI'] ?? '0.0'; // Default to '0.0' if BMI is not available
        double bmi;
        int cal = userData['calories'] ?? 0;
        int usercal = userData['user_calories'] ?? 0;


        try {
          bmi = double.parse(bmiString);
        } catch (e) {
          print('Error parsing BMI: $e');
          bmi = 0.0; // Set a default value or handle the error as needed
        }
        setState(() {
          // Update the _data string to display first and last name of the current user
          _data = '$firstName $lastName';
          _bmi = bmi;
          _cal = cal;
          _usercal = cal - usercal; // Subtract usercal from cal and assign to _usercal

        });
      }
    }, onError: (error) {
      print('Error fetching user data: $error');
    });
  }


  String getBMIStatus(double bmi) {
    if (bmi != null) {
      if (bmi < 16) {
        return "Severe Thinness";
      } else if (bmi >= 16 && bmi < 17) {
        return "Moderate Thinness";
      } else if (bmi >= 17 && bmi < 18.5) {
        return "Mild Thinness";
      } else if (bmi >= 18.5 && bmi < 25) {
        return "Normal";
      } else if (bmi >= 25 && bmi < 30) {
        return "Overweight";
      } else if (bmi >= 30 && bmi < 35) {
        return "Obese Class I";
      } else if (bmi >= 35 && bmi < 40) {
        return "Obese Class II";
      } else {
        return "Obese Class III";
      }
    }
    return "BMI data not available";
  }

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

  List waterArr = [
    {"title": "5pm - 8pm", "subtitle": "1200ml"},
    {"title": "2pm - 5pm", "subtitle": "400ml"},
    {"title": "11am - 2pm", "subtitle": "800ml"},
    {"title": "8am - 11am", "subtitle": "1000ml"},
    {"title": "6am - 8am", "subtitle": "600ml"},
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

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

    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: screenheight * 0.02,
                        ),
                        Text(
                          "Welcome Back,",
                          style: TextStyle(
                              color: Tcolor.gray,
                              fontSize: screenwidth * 0.0305412063),
                        ),
                        Text(
                          "$_data",
                          style: TextStyle(
                              color: Tcolor.black,
                              fontSize: screenwidth * 0.0509668112,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(
                  height: screenheight * 0.03,
                ),

                Container(
                  height: media.width * 0.4,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: Tcolor.primaryG),
                      borderRadius: BorderRadius.circular(media.width * 0.075)),
                  child: Stack(alignment: Alignment.center, children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "BMI (Body Mass Index)",
                                style: TextStyle(
                                    color: Tcolor.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: media.width * 0.02,
                              ),
                              Text(
                                _bmi != null ? getBMIStatus(_bmi!) : 'BMI data not available',
                                style: TextStyle(
                                    color: Tcolor.white.withOpacity(0.7),
                                    fontSize: 14),
                              ),
                              SizedBox(
                                height: media.width * 0.05,
                              ),
                              SizedBox(
                                  width: 120,
                                  height: 35,
                                  child: RoundButton(
                                    text: "View More",
                                    fontSize: screenwidth * 0.0305412063,
                                    backgroundGradient: LinearGradient(
                                      colors: Tcolor.secondaryG,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BMI(),
                                        ),
                                      );
                                    },
                                  ))
                            ],
                          ),

                          // Use the showingSections method in your widget
                          AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                                ),
                                startDegreeOffset: 350,
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 1,
                                centerSpaceRadius: 0,
                                sections: showingSections(_bmi), // Pass the actual BMI value and gradient color list here
                              ),
                            ),
                          ),

                          // AspectRatio(
                          //   aspectRatio: 1,
                          //   child: PieChart(
                          //     PieChartData(
                          //       pieTouchData: PieTouchData(
                          //         touchCallback:
                          //             (FlTouchEvent event, pieTouchResponse) {},
                          //       ),
                          //       startDegreeOffset: 250,
                          //       borderData: FlBorderData(
                          //         show: false,
                          //       ),
                          //       sectionsSpace: 1,
                          //       centerSpaceRadius: 0,
                          //       sections: showingSections(),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    )
                  ]),
                ),

                SizedBox(
                  height: screenheight * 0.04,
                ),

                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Tcolor.primaryColor2.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today Target",
                        style: TextStyle(
                            color: Tcolor.black,
                            fontSize: screenwidth * 0.0356583858,
                            fontWeight: FontWeight.w700),
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
                                const WorkoutTrackerView(),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: screenheight * 0.04,
                ),

                Text(
                  "Activity Status",
                  style: TextStyle(
                      color: Tcolor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),

                SizedBox(
                  height: screenheight * 0.02,
                ),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: media.width * 0.95,
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 2)
                            ]),
                        child: Row(
                          children: [
                            // SimpleAnimationProgressBar(
                            //   height: _ratio > 0 ? _ratio : 0, // Ensure the height is not negative
                            //   width: media.width * 0.07,
                            //   backgroundColor: Colors.grey.shade100,
                            //   foregrondColor: Colors.white,
                            //   ratio: _ratio,
                            //   direction: Axis.vertical,
                            //   curve: Curves.fastLinearToSlowEaseIn,
                            //   duration: const Duration(seconds: 10),
                            //   borderRadius: BorderRadius.circular(15),
                            //   gradientColor: LinearGradient(
                            //     colors: Tcolor.primaryG,
                            //     begin: Alignment.bottomCenter,
                            //     end: Alignment.topCenter,
                            //   ),

                            // SimpleAnimationProgressBar(
                            //   height: media.width * 0.85,
                            //   width: media.width * 0.06,
                            //   // height: _ratio > 0 ? _ratio : 0, // Ensure the height is not negative
                            //   //   width: media.width * 0.07,
                            //   backgroundColor: Colors.grey.shade100,
                            //   foregrondColor: Colors.blue,
                            //   ratio: _ratio, // Use the calculated ratio here
                            //   direction: Axis.vertical,
                            //   curve: Curves.linear,
                            //   duration: const Duration(milliseconds: 1000),
                            //   borderRadius: BorderRadius.circular(10),
                            //   gradientColor: LinearGradient(
                            //     colors: Tcolor.primaryG,
                            //     begin: Alignment.bottomCenter,
                            //     end: Alignment.topCenter,
                            //   ),
                            // ),

                            // Use the calculateRatio function in your widget
                            SimpleAnimationProgressBar(
                              height: media.width * 0.85,
                              width: media.width * 0.06,
                              backgroundColor: Colors.grey.shade100,
                              foregrondColor: Colors.blue,
                              ratio: calculateRatio(), // Use the calculated ratio here
                              direction: Axis.vertical,
                              curve: Curves.linear,
                              duration: const Duration(milliseconds: 1000),
                              borderRadius: BorderRadius.circular(10),
                              gradientColor: LinearGradient(
                                colors: Tcolor.primaryG,
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Water Intake",
                                      style: TextStyle(
                                          color: Tcolor.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    ShaderMask(
                                      blendMode: BlendMode.srcIn,
                                      shaderCallback: (bounds) {
                                        return LinearGradient(
                                            colors: Tcolor.primaryG,
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight)
                                            .createShader(Rect.fromLTRB(
                                            0, 0, bounds.width, bounds.height));
                                      },
                                      child: Text(
                                        "4 Liters",
                                        style: TextStyle(
                                            color: Tcolor.white.withOpacity(0.7),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Real time updates",
                                      style: TextStyle(
                                        color: Tcolor.gray,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: waterArr.map((wObj) {
                                        var isLast = wObj == waterArr.last;
                                        return Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4),
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    color: Tcolor.secondaryColor1
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                  ),
                                                ),
                                                if (!isLast)
                                                  DottedDashedLine(
                                                      height: media.width * 0.078,
                                                      width: 0,
                                                      dashColor: Tcolor
                                                          .secondaryColor1
                                                          .withOpacity(0.5),
                                                      axis: Axis.vertical)
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  wObj["title"].toString(),
                                                  style: TextStyle(
                                                    color: Tcolor.gray,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                ShaderMask(
                                                  blendMode: BlendMode.srcIn,
                                                  shaderCallback: (bounds) {
                                                    return LinearGradient(
                                                        colors:
                                                        Tcolor.secondaryG,
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight)
                                                        .createShader(Rect.fromLTRB(
                                                        0,
                                                        0,
                                                        bounds.width,
                                                        bounds.height)
                                                    );
                                                  },
                                                  child: Text(
                                                    wObj["subtitle"].toString(),
                                                    style: TextStyle(
                                                        color: Tcolor.white
                                                            .withOpacity(0.7),
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      }).toList(),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      width: screenheight * 0.02,
                    ),

                    Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Container(
                            //   width: double.maxFinite,
                            //   height: media.width * 0.45,
                            //   padding: const EdgeInsets.symmetric(
                            //       vertical: 25, horizontal: 20),
                            //   decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       borderRadius: BorderRadius.circular(25),
                            //       boxShadow: const [
                            //         BoxShadow(color: Colors.black12, blurRadius: 2)
                            //       ]),
                            //   child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Text(
                            //           "Sleep",
                            //           style: TextStyle(
                            //               color: Tcolor.black,
                            //               fontSize: 12,
                            //               fontWeight: FontWeight.w700),
                            //         ),
                            //         ShaderMask(
                            //           blendMode: BlendMode.srcIn,
                            //           shaderCallback: (bounds) {
                            //             return LinearGradient(
                            //                     colors: Tcolor.primaryG,
                            //                     begin: Alignment.centerLeft,
                            //                     end: Alignment.centerRight)
                            //                 .createShader(Rect.fromLTRB(
                            //                     0, 0, bounds.width, bounds.height));
                            //           },
                            //           child: Text(
                            //             "8h 20m",
                            //             style: TextStyle(
                            //                 color: Tcolor.white.withOpacity(0.7),
                            //                 fontWeight: FontWeight.w700,
                            //                 fontSize: 14),
                            //           ),
                            //         ),
                            //         const Spacer(),
                            //         Image.asset("assets/images/sleep_grap.png",
                            //             width: double.maxFinite,
                            //             height: screenheight * 0.1,
                            //             fit: BoxFit.fitWidth)
                            //       ]),
                            // ),

                            SizedBox(
                              height: screenheight * 0.02,
                            ),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateCaloriesPage(),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.maxFinite,
                                height: media.width * 0.45,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25, horizontal: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: const [
                                      BoxShadow(color: Colors.black12, blurRadius: 2)
                                    ]),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Calories",
                                        style: TextStyle(
                                            color: Tcolor.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (bounds) {
                                          return LinearGradient(
                                              colors: Tcolor.primaryG,
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight)
                                              .createShader(Rect.fromLTRB(
                                              0, 0, bounds.width, bounds.height));
                                        },
                                        child: Text(
                                          "$_cal kCal",
                                          style: TextStyle(
                                              color: Tcolor.white.withOpacity(0.7),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          width: media.width * 0.2,
                                          height: media.width * 0.2,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                width: media.width * 0.20,
                                                height: media.width * 0.20,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: Tcolor.primaryG),
                                                  borderRadius: BorderRadius.circular(
                                                      media.width * 0.1),
                                                ),
                                                child: FittedBox(
                                                  child: Text(
                                                    "$_usercal kCal\nleft",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Tcolor.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // SimpleCircularProgressBar(
                                              //   progressStrokeWidth: 10,
                                              //   backStrokeWidth: 10,
                                              //   progressColors: Tcolor.primaryG,
                                              //   backColor: Colors.grey.shade100,
                                              //   valueNotifier: ValueNotifier(10),
                                              //   startAngle: -180,
                                              // ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
                SizedBox(
                  height: screenheight * 0.05,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Workout Progress",
                      style: TextStyle(
                          color: Tcolor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    // Container(
                    //     height: 30,
                    //     padding: const EdgeInsets.symmetric(horizontal: 8),
                    //     decoration: BoxDecoration(
                    //       gradient: LinearGradient(colors: Tcolor.primaryG),
                    //       borderRadius: BorderRadius.circular(15),
                    //     ),
                    //     child: DropdownButtonHideUnderline(
                    //       child: DropdownButton(
                    //         items: ["Weekly", "Monthly"]
                    //             .map((name) => DropdownMenuItem(
                    //                   value: name,
                    //                   child: Text(
                    //                     name,
                    //                     style: TextStyle(
                    //                         color: Tcolor.gray, fontSize: 14),
                    //                   ),
                    //                 ))
                    //             .toList(),
                    //         onChanged: (value) {},
                    //         icon: Icon(Icons.expand_more, color: Tcolor.white),
                    //         hint: Text(
                    //           "Weekly",
                    //           textAlign: TextAlign.center,
                    //           style:
                    //               TextStyle(color: Tcolor.white, fontSize: 12),
                    //         ),
                    //       ),
                    //     )),
                  ],
                ),

                SizedBox(
                  height: screenheight * 0.05,
                ),

                Container(
                    padding: const EdgeInsets.only(left: 15),
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

                SizedBox(
                  height: screenheight * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


// Define the method to show pie chart sections with BMI included
  List<PieChartSectionData> showingSections(double? bmi) {
    return List.generate(
      2, // Increased count to accommodate the BMI section
          (i) {
        var color1 = Colors.white;
        var color2 = Tcolor.secondaryColor1;

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color1,
              value: 149.7,
              title: '',
              radius: 45,
              titlePositionPercentageOffset: 0.55,
            );
          case 1:
            return PieChartSectionData(
              color: color2, // Use the gradient color variable here
              value: bmi ?? 0.0, // Set the value of the BMI section, provide a default value if bmi is null
              title: '',
              radius: 50, // Increased radius for the BMI section
              titlePositionPercentageOffset: 0.55,
              badgeWidget: Container(
                padding: EdgeInsets.all(8), // Add padding for the badge widget
                child: Text(
                  bmi?.toStringAsFixed(1) ?? 'N/A', // Display the BMI value with one decimal place or 'N/A' if bmi is null
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          case 2:
            throw Error(); // Removed the default case since it's not needed
          default:
            throw Error();
        }
      },
    );
  }





  // List<PieChartSectionData> showingSections() {
  //   return List.generate(
  //     2,
  //     (i) {
  //       var color0 = Tcolor.secondaryColor1;
  //
  //       switch (i) {
  //         case 0:
  //           return PieChartSectionData(
  //               color: color0,
  //               value: 33,
  //               title: '',
  //               radius: 55,
  //               titlePositionPercentageOffset: 0.55,
  //               badgeWidget: const Text(
  //                 "20,1",
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w700),
  //               ));
  //         case 1:
  //           return PieChartSectionData(
  //             color: Colors.white,
  //             value: 75,
  //             title: '',
  //             radius: 45,
  //             titlePositionPercentageOffset: 0.55,
  //           );
  //
  //         default:
  //           throw Error();
  //       }
  //     },
  //   );
  // }

  // LineTouchData get lineTouchData1 => LineTouchData(
  //       handleBuiltInTouches: true,
  //       touchTooltipData: LineTouchTooltipData(
  //         tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
  //       ),
  //     );

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData1_1,
  ];

  // LineChartBarData get lineChartBarData1_1 => LineChartBarData(
  //       isCurved: true,
  //       gradient: LinearGradient(colors: [
  //         Tcolor.primaryColor2.withOpacity(0.5),
  //         Tcolor.primaryColor1.withOpacity(0.5),
  //       ]),
  //       barWidth: 4,
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
  //
  // LineChartBarData get lineChartBarData1_2 => LineChartBarData(
  //       isCurved: true,
  //       gradient: LinearGradient(colors: [
  //         Tcolor.secondaryColor2.withOpacity(0.5),
  //         Tcolor.secondaryColor1.withOpacity(0.5),
  //       ]),
  //       barWidth: 2,
  //       isStrokeCapRound: true,
  //       dotData: FlDotData(show: false),
  //       belowBarData: BarAreaData(
  //         show: false,
  //       ),
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

  SideTitles get rightTitles => SideTitles(
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
          color: Tcolor.gray,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: Tcolor.gray,
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
