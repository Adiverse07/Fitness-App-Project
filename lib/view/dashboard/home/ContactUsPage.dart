import 'package:flutter/material.dart';

import '../../../common/color_extension.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  final LinearGradient _gradient = const LinearGradient(
    colors: <Color>[
      Color(0xff9DCEFF),
      Color(0xff92A3FD),
    ],
  );

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Tcolor.white,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        title: Text(
          "Contact Us",
          style: TextStyle(color: Tcolor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Tcolor.white,
      body: SafeArea(
        child: SizedBox(
          width: media.width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                        child: Text(
                          "Fitness",
                          style: TextStyle(
                            color: Tcolor.black,
                            fontSize: media.width * 0.15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (Rect rect) {
                          return _gradient.createShader(rect);
                        },
                        child: Text(
                          'X',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: media.width * 0.185,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Get in Touch',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Tcolor.primaryColor1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 50),
                    child: Text(
                      'For any inquiries or support, please feel free to contact us.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Tcolor.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implement phone number action
                    },
                    icon: Icon(Icons.phone, color: Tcolor.primaryColor1),
                    label: Text(
                      '123-456-7890',
                      style: TextStyle(color: Tcolor.primaryColor1),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 67), // Adjust padding here
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Tcolor.primaryColor1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Increase border radius for rounded corners
                      ),
                      elevation: 0, // Remove shadow
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implement email action
                    },
                    icon: Icon(Icons.email, color: Tcolor.primaryColor1),
                    label: Text(
                      'example@email.com',
                      style: TextStyle(color: Tcolor.primaryColor1),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40), // Adjust padding here
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Tcolor.primaryColor1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Increase border radius for rounded corners
                      ),
                      elevation: 0, // Remove shadow
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
