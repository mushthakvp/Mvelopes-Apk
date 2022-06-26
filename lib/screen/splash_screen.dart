import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mvelopes/colors/colors.dart';
import 'package:mvelopes/dbFunctions/transaction_data_functions.dart';
import 'package:mvelopes/screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    TransactionData().refreshUi();
    Lw().snBars();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    Lw().snBars(snColor: transparentColor, stColor: transparentColor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Center(
        child: Image.asset(
          'assets/image/logo.jpg',
          height: 150,
        ),
      ),
    );
  }
}
