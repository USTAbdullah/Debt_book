import 'package:dept_notebook/Shared/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
class BottomStack extends StatelessWidget {
  var function;
  IconData icon;
   BottomStack({super.key , required this.function , required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            height:  90,
            width: 120,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),

                )
            ),
          ).animate().fade(delay: 200.ms),
          Container(
            height:  80,
            width: 120,
            decoration: BoxDecoration(
                color: Colors.redAccent.shade100,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),

                )
            ),
          ).animate().fade(delay: 220.ms),
          Container(
            height:  70,
            width: 120,
            decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),

                )
            ),
            child: Icon(icon , size: 50.0 , color: Colors.white),
          ).animate().fade(delay: 230.ms),

        ],
      ),
    );
  }
}
