import 'package:dept_notebook/Shared/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class message extends StatefulWidget {
  String title;
  String content;
  IconData icon;
  bool areActions;
  var function;
   message({super.key,required String this.title , required String this.content , required IconData this.icon , bool this.areActions = false , this.function = null});

  @override
  State<message> createState() => _messageState();
}

class _messageState extends State<message> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title , style: const TextStyle(fontSize: 30.0),),
      content: Text(textDirection: TextDirection.rtl,textAlign: TextAlign.center,widget.content , style: const TextStyle(fontFamily: 'LTKaff' , fontSize: 25.0),),
      icon: Icon(widget.icon , size: 70.0, color: AppColors.mainColor,),
      actions: widget.areActions? [
        MaterialButton(color: Colors.redAccent.shade200,onPressed: widget.function ,child: const Text('نعم', style: TextStyle(color: Colors.white , fontFamily: 'LTKaff'),),),
        MaterialButton(color: AppColors.mainColor,
          onPressed: (){
            Navigator.pop(context);
        }
        ,child: const Text('لا', style: TextStyle(color: Colors.white , fontFamily: 'LTKaff'),),),

      ] : null,
    );
  }
}
