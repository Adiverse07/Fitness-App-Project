import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../login/login_view.dart';
import '../../workout_tracker/workout_tracker_view.dart';
import 'ActivityHistoryPage.dart';
import 'ContactUsPage.dart';
import 'PersonalDataPage.dart';
import 'PrivacyPolicyPage.dart';
import 'activity.dart';
import 'edit_profile_info.dart';
import 'notification.dart';
import '../../../common/color_extension.dart';
import '../../../common_widget/round_button.dart';
import '../../../common_widget/setting_row.dart';
import '../../../common_widget/title_subtitle_cell.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  late User _currentUser;
  String _data = '';
  late String _firstName = '';
  late String _lastName = '';
  late String _dateOfBirth = '';
  late int _age = 0;
  String _weight = '0'; // Initialize as string
  String _heightFT = '0'; // Initialize as string
  String _heightIN = '0'; // Initialize as string
  String _profilePicture = ''; // Initialize with an empty string for the profile picture



  @override
  void initState() {
    super.initState();
    _getCurrentUser();

  }

  void _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
      _listenToUserData(user.uid);
    }
  }

  int calculateAgeFromDateOfBirth(String dateOfBirthString) {
    print('Date of Birth String Received: $dateOfBirthString'); // Debug print
    DateTime dateOfBirth = DateFormat('dd/MM/yyyy').parse(dateOfBirthString);
    print('Parsed Date of Birth: $dateOfBirth'); // Debug print
    DateTime now = DateTime.now();
    print('Current Date: $now'); // Debug print

    // Extract year, month, and day components from DateTime objects
    int birthYear = dateOfBirth.year;
    int birthMonth = dateOfBirth.month;
    int birthDay = dateOfBirth.day;

    int currentYear = now.year;
    int currentMonth = now.month;
    int currentDay = now.day;

    // Calculate age based on year difference
    int age = currentYear - birthYear;

    // Adjust age based on month and day comparison
    if (currentMonth < birthMonth || (currentMonth == birthMonth && currentDay < birthDay)) {
      age--; // Subtract 1 from age if the birthday hasn't occurred yet this year
    }

    print('Calculated Age: $age'); // Debug print
    return age;
  }


  void _listenToUserData(String userId) {
    _databaseReference.child('Users').child(userId).onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;
        String firstName = userData['firstname'] ?? '';
        String lastName = userData['lastname'] ?? '';
        String dateOfBirthString = userData['dateOfBirth'] ?? '';
        String heightFTString = userData['heightFT'] ?? '0'; // Default to '0' if heightFT is not available
        String heightINString = userData['heightIN'] ?? '0'; // Default to '0' if heightIN is not available
        String weightString = userData['weight'] ?? '0'; // Default to '0' if weight is not available

        // Print debug information
        print('First Name: $firstName, Last Name: $lastName');
        print('Date of Birth from Database: $dateOfBirthString');
        print('Height FT String: $heightFTString, Height IN String: $heightINString, Weight String: $weightString');

        // Calculate age from date of birth
        int age = calculateAgeFromDateOfBirth(dateOfBirthString);

        // Print debug information
        print('Calculated Age: $age');

        // Parse height and weight values as doubles
        double heightFT = double.tryParse(heightFTString) ?? 0.0;
        double heightIN = double.tryParse(heightINString) ?? 0.0;
        double weight = double.tryParse(weightString) ?? 0.0;

        // Convert doubles to integers without decimals
        int heightFTInt = heightFT.toInt();
        int heightINInt = heightIN.toInt();
        int weightInt = weight.toInt();

        // Print parsed values
        print('Parsed Height FT: $heightFTInt, Parsed Height IN: $heightINInt, Parsed Weight: $weightInt');

        setState(() {
          _data = '$firstName $lastName';
          _heightFT = heightFTInt.toString(); // Convert to string after parsing
          _heightIN = heightINInt.toString(); // Convert to string after parsing
          _weight = weightInt.toString(); // Convert to string after parsing
          _age = age; // Set the age value
          // Update other state variables...
        });
      }
    }, onError: (error) {
      print('Error fetching user data: $error');
    });
  }




  // int calculateAgeFromDateOfBirth(String dateOfBirthString) {
  //   DateTime dateOfBirth = DateFormat('dd/MM/yyyy').parse(dateOfBirthString);
  //   DateTime now = DateTime.now();
  //   int age = now.year - dateOfBirth.year;
  //   if (now.month < dateOfBirth.month || (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
  //     age--;
  //   }
  //   return age;
  // }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginView()));
  }

  String _getHeightDisplay() {
    int heightFT = int.tryParse(_heightFT) ?? 0; // Parse heightFT string to int or default to 0
    int heightIN = int.tryParse(_heightIN) ?? 0; // Parse heightIN string to int or default to 0
    return '$heightFT\' $heightIN\"'; // Format height without decimal points
  }

  String _getWeightDisplay() {
    int weight = int.tryParse(_weight) ?? 0; // Parse weight string to int or default to 0
    return '$weight'; // Format weight without decimal points
  }


  void editProfile() {
    print('_firstName: $_firstName, _lastName: $_lastName, _dateOfBirth: $_dateOfBirth');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          firstName: _firstName,
          lastName: _lastName,
          dateOfBirth: _dateOfBirth,
        ),
      ),
    );
  }


  bool positive = false;

  List accountArr = [
    {"image": "assets/images/p_personal.png", "name": "Personal Data", "tag": "1"},
    // {
    //   "image": "assets/images/p_activity.png",
    //   "name": "Activity History",
    //   "tag": "2"
    // },
    // {
    //   "image": "assets/images/p_workout.png",
    //   "name": "Workout Progress",
    //   "tag": "3"
    // }
  ];

  List otherArr = [
    {"image": "assets/images/p_contact.png", "name": "Contact Us", "tag": "4"},
    {"image": "assets/images/p_privacy.png", "name": "Privacy Policy", "tag": "5"},
  ];

  @override
  Widget build(BuildContext context) {
    String heightDisplay = _getHeightDisplay(); // Call the method to get height display
    String weightDisplay = _getWeightDisplay(); // Call the method to get weight display
    String profilePictureAsset = _profilePicture.isNotEmpty
        ? _profilePicture // Use profile picture URL if available
        : 'assets/images/pic_4.png'; // Set default picture if URL is empty

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Tcolor.white,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        title: Text(
          "Profile",
          style: TextStyle(color: Tcolor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        automaticallyImplyLeading: false, // Add this line to remove the back arrow
      ),
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      profilePictureAsset,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _data,
                          style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "",
                          style: TextStyle(
                            color: Tcolor.gray,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 25,
                    child: RoundButton(
                      text: "Edit",
                      backgroundGradient: LinearGradient(
                        colors: Tcolor.primaryG,
                      ),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      onPressed: editProfile,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: TitleSubtitleCell(
                      title: heightDisplay, // Display height
                      subtitle: "Height",
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: weightDisplay, // Display weight
                      subtitle: "Weight",
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: _age.toString(),
                      subtitle: "Age",
                    ),
                  ),
                ],
              ),const SizedBox(
                height: 25,
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: Tcolor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: accountArr.length,
                      itemBuilder: (context, index) {
                        var iObj = accountArr[index] as Map? ?? {};
                        return SettingRow(
                          icon: iObj["image"].toString(),
                          title: iObj["name"].toString(),
                          onPressed: () {
                            // Determine which page to navigate based on the tag value
                            String tag = iObj["tag"].toString();
                            switch (tag) {
                              case "1":
                              // Navigate to Personal Data page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PersonalDataPage(),
                                  ),
                                );
                                break;
                              case "2":
                              // Navigate to Activity History page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ActivityTrackerView(),
                                  ),
                                );
                                break;
                              case "3":
                              // Navigate to Workout Progress page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkoutTrackerView(),
                                  ),
                                );
                                break;
                              default:
                                break;
                            }
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: Tcolor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Other",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: otherArr.length,
                      itemBuilder: (context, index) {
                        var iObj = otherArr[index] as Map? ?? {};
                        return SettingRow(
                          icon: iObj["image"].toString(),
                          title: iObj["name"].toString(),
                          onPressed: () {
                            // Determine which page to navigate based on the tag value
                            String tag = iObj["tag"].toString();
                            switch (tag) {
                              case "4":
                              // Navigate to Contact Us page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ContactUsPage(),
                                  ),
                                );
                                break;
                              case "5":
                              // Navigate to Privacy Policy page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PrivacyPolicyPage(),
                                  ),
                                );
                                break;
                              default:
                                break;
                            }
                          },
                        );
                      },
                    )
                  ],
                ),
              ),

              const SizedBox(
                height: 25,
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: Tcolor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Logout",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 30,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/logout.png",
                                height: 15, width: 15, fit: BoxFit.contain),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                "Logout account",
                                style: TextStyle(
                                  color: Tcolor.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Container(
                                width: 85,
                                child: RoundButton(
                                  text: "Logout",
                                  fontSize: 10,
                                  onPressed: logout,
                                )
                            )
                          ]),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
