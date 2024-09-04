import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fitness_app/view/dashboard/home/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/round_button.dart';

class EditProfilePage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String dateOfBirth;

  const EditProfilePage({super.key,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Uint8List? _image;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _dateOfBirthController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
    _dateOfBirthController = TextEditingController(text: widget.dateOfBirth);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final imageBytes = await pickedImage.readAsBytes();
      setState(() {
        _image = imageBytes;
      });
    }
  }


  void _updateProfile() {
      Map<String, dynamic> updatedData = {
        'firstname': _firstNameController.text,
        'lastname': _lastNameController.text,
        'dateOfBirth': _dateOfBirthController.text,
      };

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        updateProfileData(userId, updatedData);
      }

      Navigator.pop(context);
    }

    void updateProfileData(String userId, Map<String, dynamic> newData) {
      DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users').child(userId);
      userRef.update(newData).then((_) {
        print('Profile data updated successfully');
      }).catchError((error) {
        print('Error updating profile data: $error');
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center(
              //   child: Stack(
              //     children: [
              //       _image != null
              //           ? CircleAvatar(
              //         radius: 64,
              //         backgroundImage: MemoryImage(_image!),
              //       )
              //           : CircleAvatar(
              //         radius: 60,
              //         backgroundImage: AssetImage('assets/images/pic_4.png'),
              //       ),
              //       Positioned(
              //         child: IconButton(
              //           onPressed: _selectImage,
              //           icon: const Icon(Icons.add_a_photo),
              //         ),
              //         bottom: -10,
              //         left: 80,
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Tcolor.primaryColor2.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Tcolor.primaryColor2.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: InputBorder.none,
                  ),
                ),
              ),

              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Tcolor.primaryColor2.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _dateOfBirthController,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    border: InputBorder.none,
                  ),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _dateOfBirthController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                      });
                    }
                  },
                  readOnly: true,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 170,
                  height: 40,
                  child: RoundButton(
                    text: "Update Profie",
                    backgroundGradient: LinearGradient(
                      colors: Tcolor.primaryG,
                    ),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    onPressed: _updateProfile,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}