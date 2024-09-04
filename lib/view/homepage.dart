import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  signout() async{
    await FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HomePage"),),
      body: Center(
        child: Text('${user!.email}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (()=>signout()),
        child: Icon(Icons.login_rounded),
      ),
    );
  }
}
