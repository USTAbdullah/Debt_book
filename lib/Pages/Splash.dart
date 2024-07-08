import 'package:dept_notebook/Pages/Home.dart';
import 'package:dept_notebook/Shared/AppColors.dart';
import 'package:dept_notebook/Shared/CustomAppBar.dart';
import 'package:dept_notebook/Shared/Database%20Manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'RegisterPage.dart';
class SplashScreen extends StatefulWidget {
   SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List Data = [];

  bool isLoading = true;

  _NavigateToHome() async{
    List<Map> response = await DatabaseManager.representTable('user');
    Data.addAll(response);
    isLoading = true;
    if(this.mounted){
     setState(() {});
    }
    await Future.delayed(Duration(milliseconds: 1));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder:
      (context) {
      if(Data.isEmpty){
        return Register();
      }
      else{
        return Home();
      }
      },)
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _NavigateToHome();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(),
    );
  }
}
