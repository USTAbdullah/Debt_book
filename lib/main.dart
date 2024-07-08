import 'package:dept_notebook/Pages/Splash.dart';
import 'package:dept_notebook/Pages/addCreditor.dart';
import 'package:dept_notebook/Pages/history.dart';
import 'package:dept_notebook/Pages/invoice.dart';
import 'package:flutter/material.dart';
import 'Pages/Home.dart';
import 'Pages/charts.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Tajawal'
      ),
      home: SplashScreen(),
    )
  );
}

