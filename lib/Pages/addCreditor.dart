import 'package:dept_notebook/Pages/Home.dart';
import 'package:dept_notebook/Shared/Database%20Manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../Shared/AppColors.dart';
import '../Shared/CustomAppBar.dart';
import '../Shared/sharedTextField.dart';
class AddCreditor extends StatelessWidget {

  const AddCreditor({super.key});

  @override
  Widget build(BuildContext context) {
    String months(int monthNumber) {
      List month = [
        'يناير',
        'فبراير',
        'مارس',
        'ابريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'اكتوبر',
        'نوفمبر',
        'ديسيمبر',
      ];
      return month[monthNumber];
    };


    TextEditingController name = TextEditingController();
    TextEditingController phone = TextEditingController();
    TextEditingController address = TextEditingController();
    TextEditingController purchases = TextEditingController();
    TextEditingController purchasesValue = TextEditingController();
    var formKey = GlobalKey<FormState>();


    String currentTimeAndDate(){
      DateTime now = DateTime.now();
      int hour = now.hour;
      int minute = now.minute;
      String  textMinute = '';
      if(hour > 12){
        hour = hour - 12;

      }
     if(minute < 10){
       textMinute = '0$minute';

     }
     else{
       textMinute = '$minute';
     }

      String timeNow = '${now.day}/${months(now.month - 1)}/${now.year} - $hour:$textMinute';
      return timeNow;
    }
    insert_Creditor(){
      try{
        DatabaseManager.insertCreditor(
            table1: 'creditor',
            table2: 'invoice',
            table3: 'history',
            name: name.text,
            address: address.text,
            phone: int.parse(phone.text) ,
            price: int.parse(purchasesValue.text) ,
            purchases: purchases.text,
        processType: 'حساب جديد',
          date: currentTimeAndDate()
        ).then((value) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Home())));
        
      }
      catch(e){
        print(e);
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomAppBar(height: 100, color: AppColors.mainColor, title: 'حساب جديد' , fontSize: 45.0 , canMove: true , destination: const Home()),
              MyTextField(title: 'الاسم' , icon: Icons.person , controller: name),
              MyTextField(title: 'رقم الهاتف' , icon: Icons.phone , controller: phone),
              MyTextField(title: 'العنوان' , icon: Icons.location_on , controller: address),
              MyTextField(title: 'المشتريات' , icon: Icons.tag_faces , maxLines: 8, useICon: false , controller: purchases , isRequired: true),
              MyTextField(title: 'قيمة المشتريات' , icon: Icons.price_check, controller: purchasesValue , isRequired: true),
              Padding(padding: const EdgeInsets.only(right: 10.0),child: MaterialButton(onPressed: (){
                if(formKey.currentState!.validate()){
                  insert_Creditor();

                }
              } , color: AppColors.mainColor , child: const Text("اضافة" , style: TextStyle(color: Colors.white , fontFamily: 'LTKaff'),),)),
            ],
          ),
        ),
      ),
    );
  }
}
