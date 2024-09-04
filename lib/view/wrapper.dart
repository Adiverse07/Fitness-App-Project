import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/view/on_boarding/splash_screen_login.dart';
import 'package:fitness_app/view/on_boarding/splash_screen_logout.dart';
import 'package:flutter/material.dart';

import 'dashboard/home/home.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Splash_Screen_Login() ;
          } else {
            return Splash_Screen_Logout();
          }
        },
      ),
    );
  }
}
