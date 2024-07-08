import 'package:dept_notebook/Shared/AppColors.dart';
import 'package:dept_notebook/Shared/CustomAppBar.dart';
import 'package:dept_notebook/Shared/Database%20Manager.dart';
import 'package:dept_notebook/Shared/sharedTextField.dart';
import 'package:flutter/material.dart';
class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();


  _addUser(){
     DatabaseManager.insertUser(name: name.text, desc: description.text);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
            CustomAppBar(height: 140, color: AppColors.mainColor, title: 'التسجيل'),
              MyTextField(title: 'اسم المحل (مثلا: بقالة الفاروق)', showCounter: true,icon: Icons.business, controller: name , maxLength: 25),
              MyTextField(title: 'الوصف(مثلا: للمواد الغذائية والكماليات)', isRequired: true,showCounter: true,icon: Icons.description, controller: description , maxLength: 35,),
              Container(padding: const EdgeInsets.only(right: 10),child: MaterialButton(onPressed: (){
                if(formKey.currentState!.validate()){
                  _addUser();
                }
              } , child: Text("تسجيل" , style: TextStyle(fontFamily: 'LTKAFF' , color: Colors.white , fontWeight: FontWeight.bold),), color: AppColors.mainColor)),
            ],
          ),
        ),
      ),
    );
  }
}
