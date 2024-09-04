import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/color_extension.dart';
import '../../../common_widget/round_button.dart';
import '../../meal_planner/meal_schedule.dart';
import '../../workout_tracker/workout_schedule_view.dart';

class ActivityTrackerView extends StatefulWidget {
  const ActivityTrackerView({super.key});

  @override
  State<ActivityTrackerView> createState() => _ActivityTrackerViewState();
}

class _ActivityTrackerViewState extends State<ActivityTrackerView> {
  User? _currentUser; // Declare a User variable

  List<int> workoutData = List.filled(7, 0); // Initialize workout data list
  List<WorkoutItem> workoutItems = []; // List to hold workout items



  @override
  void initState() {
    super.initState();
    fetchWorkoutData();
    fetchWorkoutDetails();
  }


  Future<void> fetchWorkoutDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        DatabaseReference ref = FirebaseDatabase.instance.reference().child('users/$userId/workouts');

        // Use onData and onCancelled to handle the event
        ref.once().then((DatabaseEvent event) {
          if (event.snapshot != null) {
            DataSnapshot snapshot = event.snapshot!;

            if (snapshot.value != null) {
              Map<dynamic, dynamic> workoutsData = snapshot.value as Map<dynamic, dynamic>;

              workoutsData.forEach((key, value) {
                String workoutName = value['workoutName'];
                String date = value['date'];
                String time = value['time'];
                workoutItems.add(
                  WorkoutItem(
                    workoutName: workoutName,
                    date: date,
                    time: time,
                  ),
                );
              });

              setState(() {});
            }
          }
        }).catchError((error) {
          print('Error fetching workout data: $error');
        });
      }
    } catch (e) {
      print('Error fetching workout data: $e');
    }
  }




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
        workoutData = [
          workoutsData['Sunday'] ?? 0,
          workoutsData['Monday'] ?? 0,
          workoutsData['Tuesday'] ?? 0,
          workoutsData['Wednesday'] ?? 0,
          workoutsData['Thursday'] ?? 0,
          workoutsData['Friday'] ?? 0,
          workoutsData['Saturday'] ?? 0,
        ];


        setState(() {}); // Update the UI with fetched data
      }
          }
        });
      }
    } catch (e) {
      print('Error fetching workout data: $e');
    }
  }

  int touchedIndex = -1;


  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    var media = MediaQuery.of(context).size;
    var mediaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Tcolor.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Activity Tracker",
          style: TextStyle(
              color: Tcolor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        automaticallyImplyLeading: false, // Add this line to remove the back arrow
      ),
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Activity  Progress",
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
                height: media.width * 0.5,
                padding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                decoration: BoxDecoration(
                    color: Tcolor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 3)
                    ]),
                child: BarChart(BarChartData(
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey,
                      tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                      tooltipMargin: 10,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String weekDay;
                        switch (group.x) {
                          case 0:
                            weekDay = 'Sunday';
                            break;
                          case 1:
                            weekDay = 'Monday';
                            break;
                          case 2:
                            weekDay = 'Tuesday';
                            break;
                          case 3:
                            weekDay = 'Wednesday';
                            break;
                          case 4:
                            weekDay = 'Thursday';
                            break;
                          case 5:
                            weekDay = 'Friday';
                            break;
                          case 6:
                            weekDay = 'Saturday';
                            break;
                          default:
                            throw Error();
                        }
                        return BarTooltipItem(
                          '$weekDay\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: (rod.toY - 1).toString(),
                              style: TextStyle(
                                color: Tcolor.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    touchCallback: (FlTouchEvent event, barTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            barTouchResponse == null ||
                            barTouchResponse.spot == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex =
                            barTouchResponse.spot!.touchedBarGroupIndex;
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: getTitles,
                        reservedSize: 38,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingGroups(),
                  gridData: FlGridData(show: false),
                )),
              ),
              SizedBox(
                height: media.width * 0.05,
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(vertical: media.width*0.037,horizontal: media.width*0.06),
              //   decoration: BoxDecoration(
              //       color: Tcolor.primaryColor2.withOpacity(0.3),
              //       borderRadius: BorderRadius.circular(15)
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         "Scheduled Workout",
              //         style: TextStyle(
              //             color: Tcolor.black,
              //             fontSize: media.width*0.036,
              //             fontWeight: FontWeight.w700
              //         ),
              //       ),
              //       SizedBox(
              //         width: 85,
              //         height: 35,
              //         child:
              //         RoundButton(
              //           text: "Check",
              //           backgroundGradient: LinearGradient(
              //             colors: Tcolor.primaryG,
              //           ),
              //           fontSize: 11,
              //           fontWeight: FontWeight.normal,
              //           onPressed: () {
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => workout_schedule_view(
              //                   userId: _currentUser != null
              //                       ? _currentUser!.uid
              //                       : '',
              //                 ),
              //               ),
              //             );
              //
              //           },
              //         ),
              //       )
              //     ],
              //   ),
              //
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   padding: EdgeInsets.symmetric(vertical: media.width*0.037,horizontal: media.width*0.06),
              //   decoration: BoxDecoration(
              //       color: Tcolor.primaryColor2.withOpacity(0.3),
              //       borderRadius: BorderRadius.circular(15)
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         "Scheduled Meals",
              //         style: TextStyle(
              //             color: Tcolor.black,
              //             fontSize: media.width*0.036,
              //             fontWeight: FontWeight.w700
              //         ),
              //       ),
              //       SizedBox(
              //         width: 85,
              //         height: 35,
              //         child:
              //         RoundButton(
              //           text: "Check",
              //           backgroundGradient: LinearGradient(
              //             colors: Tcolor.primaryG,
              //           ),
              //           fontSize: 11,
              //           fontWeight: FontWeight.normal,
              //           onPressed: () {
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => meal_schedule_view(
              //                   userId: _currentUser != null
              //                       ? _currentUser!.uid
              //                       : '',
              //                 ),
              //               ),
              //             );
              //           },
              //         ),
              //       )
              //     ],
              //   ),
              //
              // ),
              //
              // SizedBox(
              //   height: media.width * 0.05,
              // ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Latest Workout",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   itemCount: workoutItems.length,
                    //   itemBuilder: (context, index) {
                    //     return workoutItems[index];
                    //   },
                    // ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: workoutItems.length,
                      itemBuilder: (context, index) {
                        final reversedIndex = workoutItems.length - index - 1;
                        final workout = workoutItems[reversedIndex];
                        return WorkoutItem(
                          workoutName: workout.workoutName,
                          date: workout.date,
                          time: workout.time,
                        );
                      },
                    ),


                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    var style = TextStyle(
      color: Tcolor.gray,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text('Sun', style: style);
        break;
      case 1:
        text = Text('Mon', style: style);
        break;
      case 2:
        text = Text('Tue', style: style);
        break;
      case 3:
        text = Text('Wed', style: style);
        break;
      case 4:
        text = Text('Thu', style: style);
        break;
      case 5:
        text = Text('Fri', style: style);
        break;
      case 6:
        text = Text('Sat', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
    double yValue = workoutData[i].toDouble(); // Convert int value to double
    switch (i) {
      case 0:
        return makeGroupData(0, yValue, Tcolor.primaryG, isTouched: i == touchedIndex);
      case 1:
        return makeGroupData(1, yValue, Tcolor.secondaryG, isTouched: i == touchedIndex);
      case 2:
        return makeGroupData(2, yValue, Tcolor.primaryG, isTouched: i == touchedIndex);
      case 3:
        return makeGroupData(3, yValue, Tcolor.secondaryG, isTouched: i == touchedIndex);
      case 4:
        return makeGroupData(4, yValue, Tcolor.primaryG, isTouched: i == touchedIndex);
      case 5:
        return makeGroupData(5, yValue, Tcolor.secondaryG, isTouched: i == touchedIndex);
      case 6:
        return makeGroupData(6, yValue, Tcolor.primaryG, isTouched: i == touchedIndex);
      default:
        throw Error();
    }
  });


  BarChartGroupData makeGroupData(
      int x,
      double y,
      List<Color> barColor, {
        bool isTouched = false,
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          gradient: LinearGradient(
            colors: barColor,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          width: width,
          borderSide: isTouched ? const BorderSide(color: Colors.green) : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: Tcolor.lightgray,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}

// class WorkoutItem extends StatelessWidget {
//   final String workoutName;
//   final String date;
//   final String time;
//
//   const WorkoutItem({
//     Key? key,
//     required this.workoutName,
//     required this.date,
//     required this.time,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
//       // padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: Tcolor.primaryG, // Add your desired colors here
//         ),              borderRadius: BorderRadius.circular(15),
//         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
//       ),
//       child: ListTile(
//         contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Customize content padding
//         title: Text(
//          workoutName,
//           style: TextStyle(
//             color: Colors.white, // Customize title text color
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         subtitle: Text(
//           '$date, $time',
//           style: TextStyle(
//             color: Colors.white, // Customize subtitle text color
//             fontSize: 14,
//           ),
//         ),
//         // subtitle: Text('$date, $time'),
//       ),
//     );
//   }
// }

class WorkoutItem extends StatelessWidget {
  final String workoutName;
  final String date;
  final String time;

  const WorkoutItem({
    Key? key,
    required this.workoutName,
    required this.date,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: Tcolor.primaryG, // Add your desired colors here
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, top: 5),
            child: Text(
              workoutName,
              style: TextStyle(
                color: Tcolor.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            margin: EdgeInsets.only(left: 15, bottom: 5),
            child: Text(
              '$date, $time',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
