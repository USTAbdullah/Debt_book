
import 'package:dept_notebook/Shared/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget myButton({required String text , var function,required IconData icon , Color color = Colors.redAccent}){
  return InkWell(
    onTap: function,
    child: Container(
      color: color,
      padding: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 8.0),
      child: Row(
        children: [
          Icon(icon , color: Colors.white,),
          SizedBox(width: 10 ),
          Text(text , style: TextStyle(fontFamily: 'LTKaff' , color: Colors.white),),
        ],
      ),
    ),
  );
}