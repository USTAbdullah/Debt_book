import 'package:dept_notebook/Pages/charts.dart';
import 'package:dept_notebook/Pages/history.dart';
import 'package:dept_notebook/Shared/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class myDrawer extends StatelessWidget {
  String name;
  String des;
   myDrawer({super.key , required this.name , required this.des});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(name , style: TextStyle(fontSize: 15.0 , fontFamily: 'LTKaff'),),
                    Text(des, style: TextStyle(fontSize: 10,fontFamily: 'LTKaff'),),
                  ],
                ),
                SizedBox(width: 20.0),
                CircleAvatar(
                  radius: 40.0,
                  backgroundColor: AppColors.mainColor,
                  child: Text(name,textAlign: TextAlign.center, style: TextStyle(fontSize: 12,color: Colors.white , fontWeight: FontWeight.bold),),
                ),
              ],
            ),
            Divider(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ttt(text: 'سجل العمليات', function: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => history()));} , icon: Icons.history),
                  ttt(text: 'احصائيات الديون', function: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => charts()));} , icon: Icons.multiline_chart),
                  ttt(text: 'تصدير البيانات', function: (){} , icon: Icons.arrow_back),
                  ttt(text: 'استيراد البيانات', function: (){} , icon: Icons.arrow_forward),
                ],
              ),
            ),
            Divider(),
            Text("جميع الحقوق تعود للمطور:" , textDirection: TextDirection.rtl,style: TextStyle(fontFamily: 'LTKAFF'),),
            Text("عبدالله الجابري" , textDirection: TextDirection.rtl,style: TextStyle(fontFamily: 'LTKAFF'),),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("abdullah.ismail.ust@gmail.com" ,style: TextStyle(fontFamily: 'LTKAFF'),),
                SizedBox(width: 5),
                Icon(Icons.email , color: AppColors.mainColor),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("+967773593824" ,style: TextStyle(fontFamily: 'LTKAFF'),),
                SizedBox(width: 5),
                Icon(Icons.phone_android , color: AppColors.mainColor),

              ],
            ),
          ],
        ),
      ),
    );
  }
}


Widget ttt({required String text , required var function , icon = Icons.menu_rounded}){
  return InkWell(
    onTap: function,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon ),
          Text(text , style: TextStyle(fontSize: 20.0 , color: AppColors.mainColor , fontFamily: 'LTKaff' , fontWeight: FontWeight.bold),),

        ],
      ),
    ),
  );
}