import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'AppColors.dart';
class CustomAppBar extends StatelessWidget {
  double height;
  Color color;
  String title;
  double fontSize;
  bool canMove;
  Widget destination;
   CustomAppBar({super.key , required this.height , required this.color , required this.title , this.fontSize = 55 , this.canMove = false , this.destination = const SizedBox()});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height:  height * 1.25,
          decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(100),
                  bottomLeft: Radius.circular(200)
              )
          ),
        ).animate().slideY(delay: 200.ms),
        Container(
          height:  height * 1.1,
          decoration: BoxDecoration(
              color: Colors.red.shade300,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(100),
                  bottomLeft: Radius.circular(200)
              )
          ),
        ).animate().slideY(delay: 200.ms),
        Container(
          height:  height * 1.20,
          decoration: BoxDecoration(
            color: AppColors.secondColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(150),
              bottomRight: Radius.circular(200)
            ),
          ),
        ).animate().slideY(delay: 100.ms),
        Container(
          height:  height,
          decoration: BoxDecoration(
            color: color,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(100),
                  bottomLeft: Radius.circular(150)
              )
          ),
          child: Center(child: Row(
            mainAxisAlignment: canMove? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
            children: [
              canMove? IconButton(icon: Icon(Icons.arrow_back_ios_new_outlined , size: 40.0, color: Colors.white,), onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => destination));
              },) : SizedBox(),
              Text(title , style: TextStyle(fontSize: fontSize,fontWeight: FontWeight.bold , color: Colors.white ),),
              SizedBox()

            ],
          ),
          ),
        ).animate().slideY(),
      ],
    );
  }
}