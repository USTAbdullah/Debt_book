import 'package:dept_notebook/Shared/AppColors.dart';
import 'package:flutter/material.dart';
class MyTextField extends StatelessWidget {
  String title;
  IconData icon;
  double marginTop;
  int maxLines;
  bool useICon;
  TextEditingController controller;
  bool isRequired;
  bool showCounter;
  int maxLength;
   MyTextField({super.key , required this.title, this.showCounter = false,required this.icon , this.marginTop = 10.0 , this.maxLines = 1 , this.useICon = true , required this.controller , this.isRequired = true ,  this.maxLength = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: marginTop , left: 10.0 , right: 10.0),
      child: TextFormField(
        validator: (value) {
          if(isRequired){
            if(value!.isEmpty || value == null){
              return '$title مطلوب ';
            }
            return null;
          }
          return null;
        },
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        textDirection: TextDirection.rtl,
        style: const TextStyle(fontFamily: 'LTKaff'),
        decoration: InputDecoration(
          counterStyle: TextStyle(fontSize: showCounter? 10 : 0),
          hintText: title,
          hintStyle: const TextStyle(fontFamily: 'LTKaff'),
          hintTextDirection: TextDirection.rtl,
          prefixIcon: useICon ? Icon(icon , color: AppColors.mainColor) : null,
          border: const OutlineInputBorder()
        ),
      ),
    );
  }
}
