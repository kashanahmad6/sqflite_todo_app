import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_todoapp/provider/provider.dart';

import 'package:sqflite_todoapp/screens/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getToHomePage();
  }

  getToHomePage() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    await Provider.of<TaskProvider>(context, listen: false).fetchItems();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MyhomePage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
