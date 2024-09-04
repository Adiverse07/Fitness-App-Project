// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../../common/color_extension.dart';
//
// class PersonalDataPage extends StatefulWidget {
//   PersonalDataPage({Key? key}) : super(key: key);
//
//   @override
//   State<PersonalDataPage> createState() => _PersonalDataPageState();
// }
//
// class _PersonalDataPageState extends State<PersonalDataPage> {
//   final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
//
//   late User _currentUser;
//   String _data = '';
//   String _email = '';
//   late String _weight = ''; // Changed type to int
//   late String _age = ''; // Changed type to int
//   late String _heightFT = '';
//   late String _heightIN = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }
//
//   void _getCurrentUser() {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         _currentUser = user;
//       });
//       _listenToUserData(user.uid);
//     }
//   }
//
//   void _listenToUserData(String userId) {
//     _databaseReference.child('Users').child(userId).onValue.listen((event) {
//       DataSnapshot snapshot = event.snapshot;
//       if (snapshot.value != null) {
//         Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;
//         String firstName = userData['firstname'] ?? '';
//         String lastName = userData['lastname'] ?? '';
//         String email = userData['email'] ?? '';
//         String dateOfBirth = userData['dateOfBirth'] ?? '';
//         String weightString = userData['weight'] ?? '';
//         String heightFTString = userData['heightFT'] ?? '';
//         String heightINString = userData['heightIN'] ?? '';
//
//         setState(() {
//           _data = '$firstName $lastName';
//           _email = email;
//           _heightFT = heightFTString.replaceAll(RegExp(r'\.0*$'), ''); // Remove decimal points and trailing zeros
//           _heightIN = heightINString.replaceAll(RegExp(r'\.0*$'), ''); // Remove decimal points and trailing zeros
//           _weight = weightString.replaceAll(RegExp(r'\.0*$'), ''); // Remove decimal points and trailing zeros
//           _age = dateOfBirth.isNotEmpty ? calculateAgeFromDateOfBirth(dateOfBirth).toString() : '';
//         });
//       }
//     }, onError: (error) {
//       print('Error fetching user data: $error');
//     });
//   }
//
//
//   int calculateAgeFromDateOfBirth(String dateOfBirthString) {
//     DateTime dateOfBirth = DateFormat('dd/MM/yyyy').parse(dateOfBirthString);
//     DateTime now = DateTime.now();
//     int age = now.year - dateOfBirth.year;
//     if (now.month < dateOfBirth.month || (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
//       age--;
//     }
//     return age;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var mediaWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: Tcolor.white,
//       appBar: AppBar(
//         backgroundColor: Tcolor.white,
//         centerTitle: true,
//         elevation: 0,
//         leading: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Container(
//             margin: const EdgeInsets.all(8),
//             height: mediaWidth * 0.1, // Adjusted height
//             width: mediaWidth * 0.1, // Adjusted width
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: Tcolor.lightgray,
//               borderRadius: BorderRadius.circular(mediaWidth * 0.025), // Adjusted borderRadius
//             ),
//             child: Image.asset(
//               "assets/images/black_btn.png",
//               width: mediaWidth * 0.038, // Adjusted width
//               height: mediaWidth * 0.038, // Adjusted height
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//         title: Text(
//           "Personal Data",
//           style: TextStyle(
//             color: Tcolor.black,
//             fontSize: mediaWidth * 0.046, // Adjusted font size
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Name: $_data',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Row(
//               children: [
//                 Text(
//                   "Age: ",
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 Text(
//                   _age.toString(),
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             Row(
//               children: [
//                 Text(
//                   'Height: ',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 Text(
//                   "$_heightFT\'$_heightIN\"",
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Weight: $_weight',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Email: $_email',
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PersonalDataPage extends StatefulWidget {
  PersonalDataPage({Key? key}) : super(key: key);

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  late User _currentUser;
  String _data = '';
  String _email = '';
  late String _weight = ''; // Changed type to String
  late String _age = ''; // Changed type to String
  late String _heightFT = '';
  late String _heightIN = '';

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

  void _listenToUserData(String userId) {
    _databaseReference.child('Users').child(userId).onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;
        String firstName = userData['firstname'] ?? '';
        String lastName = userData['lastname'] ?? '';
        String email = userData['email'] ?? '';
        String dateOfBirth = userData['dateOfBirth'] ?? '';
        String weightString = userData['weight'] ?? '';
        String heightFTString = userData['heightFT'] ?? '';
        String heightINString = userData['heightIN'] ?? '';

        setState(() {
          _data = '$firstName $lastName';
          _email = email;
          _heightFT = heightFTString;
          _heightIN = heightINString;
          _weight = weightString;
          _age = dateOfBirth.isNotEmpty ? calculateAgeFromDateOfBirth(dateOfBirth) : '';
        });
      }
    }, onError: (error) {
      print('Error fetching user data: $error');
    });
  }

  String calculateAgeFromDateOfBirth(String dateOfBirthString) {
    DateTime dateOfBirth = DateFormat('dd/MM/yyyy').parse(dateOfBirthString);
    DateTime now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month || (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              width: 173,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    '$_data', // Placeholder for BMI value
                    style: TextStyle(fontSize: 18,),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Height:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Feet',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '$_heightFT', // Placeholder for feet value
                          style: TextStyle(fontSize: 24,),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Inches',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '$_heightIN', // Placeholder for inches value
                          style: TextStyle(fontSize: 24,),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Weight:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              width: 173,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'KG',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '$_weight', // Placeholder for weight value
                    style: TextStyle(fontSize: 24,),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Your Email:',
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              width: 600,
              height: 50,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    '$_email', // Placeholder for email value
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
